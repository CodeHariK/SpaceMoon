import { onObjectFinalized } from "firebase-functions/v2/storage";
import { getStorage } from "firebase-admin/storage";
import logger = require("firebase-functions/logger");
import path = require("path");
import * as admin from "firebase-admin";

// library for image resizing
import sharp = require("sharp");
import { FieldValue } from "firebase-admin/firestore";
import { ImageMetadata, Tweet } from "./Gen/data";

/**
 * When an image is uploaded in the Storage bucket,
 * generate a thumbnail automatically using sharp.
 */
export const generateThumbnail = onObjectFinalized({ cpu: 2 }, async (event) => {

    const fileBucket = event.data.bucket; // Storage bucket containing the file.
    const filePath = event.data.name; // File path in the bucket.
    const contentType = event.data.contentType; // File content type.

    // Exit if this is triggered on a file that is not an image.
    if (!contentType?.startsWith("image/")) {
        return logger.log("This is not an image.");
    }
    // Exit if the image is already a thumbnail.
    var fileName = path.basename(filePath);
    if (fileName.startsWith("thumb_")) {
        return logger.log("Already a Thumbnail.");
    }

    const user = filePath.split('/')[0];
    const docpath = filePath.replace(user + '/', '').replace('/' + fileName, '')

    console.log(event.data.metadata?.localUrl)
    let oldImageData = Tweet.fromJSON((await admin.firestore().doc(docpath).get()).data()).gallery.find((imgData, __, ___) => {
        return imgData.localUrl == event.data.metadata?.localUrl;
    })

    if (!oldImageData) return;

    let newImageData = ImageMetadata.fromPartial(oldImageData)
    newImageData.url = event.data.mediaLink!
    newImageData.localUrl = '';

    if (event.data.metadata?.single) {

        admin.firestore().doc(docpath).set({
            [event.data.metadata?.single]: event.data.mediaLink
        },
            {
                merge: true
            }
        );
    }
    if (event.data.metadata?.multi) {
        await admin.firestore().doc(docpath).set({
            [event.data.metadata?.multi!]: FieldValue.arrayRemove(...[ImageMetadata.toJSON(oldImageData)]),
        }, { merge: true }
        );
        await admin.firestore().doc(docpath).set({
            [event.data.metadata?.multi!]: FieldValue.arrayUnion(...[ImageMetadata.toJSON(newImageData)])
        }, { merge: true }
        );
    }

    // Download file into memory from bucket.
    const bucket = getStorage().bucket(fileBucket);
    const downloadResponse = await bucket.file(filePath).download();
    const imageBuffer = downloadResponse[0];
    logger.log("Image downloaded!");

    // Generate a thumbnail using sharp.
    const thumbnailBuffer = await sharp(imageBuffer).resize({
        width: 200,
        height: 200,
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
    return logger.log("Thumbnail uploaded!");
});