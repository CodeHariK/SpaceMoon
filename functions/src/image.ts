import { onObjectFinalized } from "firebase-functions/v2/storage";
import { getStorage } from "firebase-admin/storage";
import logger = require("firebase-functions/logger");
import path = require("path");
import * as admin from "firebase-admin";

import sharp = require("sharp");
import { FieldValue } from "firebase-admin/firestore";
import { ImageMetadata, Tweet } from "./Gen/data";

export const generateThumbnail = onObjectFinalized({
    cpu: 2,
    region: 'asia-south1',
}, async (event) => {

    const fileBucket = event.data.bucket; // Storage bucket containing the file.
    const filePath = event.data.name; // File path in the bucket.
    const contentType = event.data.contentType; // File content type.

    // Exit if this is triggered on a file that is not an image.
    if (contentType?.startsWith("image/")) {
        // Exit if the image is already a thumbnail.
        var fileName = path.basename(filePath);
        if (fileName.startsWith("thumb_")) {
            return logger.log("Already a Thumbnail.");
        }

        // Download file into memory from bucket.
        const bucket = getStorage().bucket(fileBucket);
        const downloadResponse = await bucket.file(filePath).download();
        const imageBuffer = downloadResponse[0];
        logger.log("Image downloaded!");

        const sharpImageMetaData = (await sharp(imageBuffer).metadata());

        // Generate a thumbnail using sharp.
        const thumbnailBuffer = await sharp(imageBuffer).resize({
            width: 300,
            height: 300,
            withoutEnlargement: true,
        }).withMetadata().toBuffer();
        logger.log("Thumbnail created");

        // Prefix 'thumb_' to file name.
        const thumbFileName = `thumb_${fileName}`;
        const thumbFilePath = path.join(path.dirname(filePath), thumbFileName);

        // Upload the thumbnail.
        const metadata = { contentType: contentType };
        await bucket.file(thumbFilePath).save(thumbnailBuffer, {
            metadata: metadata,
        });

        // const thumbDownloadURL = (await bucket.file(thumbFilePath).getSignedUrl({
        //     action: 'read',
        //     expires: '01-01-2100', // Set an expiration date if needed
        // }))[0]
        // const imgDownloadURL = (await bucket.file(filePath).getSignedUrl({
        //     action: 'read',
        //     expires: '01-01-2100', // Set an expiration date if needed
        // }))[0]
        // console.log(thumbDownloadURL)
        // console.log(imgDownloadURL)

        //------------------

        let docpath = event.data.metadata!.path;

        if (event.data.metadata?.single) {
            admin.firestore().doc(docpath).update({
                [event.data.metadata?.single]: filePath
            });
        }
        if (event.data.metadata?.multi) {

            let oldImageData = Tweet.fromJSON((await admin.firestore().doc(docpath).get())
                .data()).gallery.find((imgData, __, ___) => {
                    return imgData.localUrl === event.data.metadata?.localUrl;
                })

            if (!oldImageData) return;

            let newImageData = ImageMetadata.fromPartial(oldImageData)
            newImageData.localUrl = undefined;
            newImageData.path = filePath;
            newImageData.width = sharpImageMetaData.width!;
            newImageData.height = sharpImageMetaData.height!;

            await admin.firestore().doc(docpath).update({
                [event.data.metadata?.multi!]: FieldValue.arrayRemove(...[ImageMetadata.toJSON(oldImageData)]),
            });
            await admin.firestore().doc(docpath).update({
                [event.data.metadata?.multi!]: FieldValue.arrayUnion(...[ImageMetadata.toJSON(newImageData)])
            });
        }

        return logger.log("Thumbnail uploaded!");
    }

    if (contentType?.startsWith("video/")) {
        let docpath = event.data.metadata!.path;

        if (event.data.metadata?.single) {
            admin.firestore().doc(docpath).update({
                [event.data.metadata?.single]: filePath
            });
        }

        if (event.data.metadata?.multi) {

            let oldImageData = Tweet.fromJSON((await admin.firestore().doc(docpath).get())
                .data()).gallery.find((imgData, __, ___) => {
                    return imgData.localUrl === event.data.metadata?.localUrl;
                })

            if (!oldImageData) return;

            let newImageData = ImageMetadata.fromPartial(oldImageData)
            newImageData.localUrl = undefined;
            newImageData.path = filePath;

            await admin.firestore().doc(docpath).update({
                [event.data.metadata?.multi!]: FieldValue.arrayRemove(...[ImageMetadata.toJSON(oldImageData)]),
            });
            await admin.firestore().doc(docpath).update({
                [event.data.metadata?.multi!]: FieldValue.arrayUnion(...[ImageMetadata.toJSON(newImageData)])
            });
        }

        return logger.log("Video uploaded!");
    }

    return 'File Error';
});