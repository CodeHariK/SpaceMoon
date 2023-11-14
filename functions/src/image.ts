import { onObjectFinalized } from "firebase-functions/v2/storage";
import { getStorage } from "firebase-admin/storage";
import logger = require("firebase-functions/logger");
import path = require("path");
import * as admin from "firebase-admin";

// library for image resizing
import sharp = require("sharp");
import { FieldValue } from "firebase-admin/firestore";

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

    const meta = {
        width: event.data.metadata?.width,
        height: event.data.metadata?.height,
        blurhash: event.data.metadata?.blurhash,
        path: event.data.mediaLink
    }

    if (event.data.metadata?.single) {
        const e = event.data.metadata?.single?.split('/')
        const path = e?.pop()
        const collection = e?.join('/')

        admin.firestore().doc(
            collection).set({ [path!]: meta },
                {
                    merge: true
                }
            );
    }
    if (event.data.metadata?.multi) {
        const e = event.data.metadata?.multi?.split('/')
        const path = e?.pop()
        const collection = e?.join('/')

        admin.firestore().doc(
            collection).set({
                [path!]: FieldValue.arrayUnion(...[meta])
            },
                {
                    merge: true
                }
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
    }).toBuffer();
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