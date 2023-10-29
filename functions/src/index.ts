/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { auth, logger } from "firebase-functions";
import { onCall, onRequest } from "firebase-functions/v2/https";
import { beforeUserCreated, AuthBlockingEvent } from "firebase-functions/v2/identity";
import { onDocumentWritten } from "firebase-functions/v2/firestore";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = onRequest((request, response) => {
    response.set("Access-Control-Allow-Origin", "*");
    logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
});

export const onUserCreate = beforeUserCreated((event: AuthBlockingEvent) => {
    console.log(event.additionalUserInfo?.isNewUser);
    console.log(event.additionalUserInfo?.profile);
    console.log(event.additionalUserInfo?.username);
    console.log(event.data);
    console.log(event.data.email);
    console.log(event.data.phoneNumber);
    console.log(event.data.photoURL);
    console.log(event.auth?.uid);
});

exports.sendWelcomeEmail = auth.user().onCreate((user) => {
    const { uid, email, displayName, phoneNumber, photoURL } = user;

    console.log(uid);
    console.log(email);
    console.log(displayName);
    console.log(phoneNumber);
    console.log(photoURL);
});

export const sayHello = onCall((request) => {
    return {
        message: "Hello from the emulator",
        data: request.data,
        auth: request.auth,
    };
});

export const docWrite = onDocumentWritten('counter/{count}', (change) => {
    let hello = {
        'subject': change.subject,
        'type': change.type,
        'after': change.data?.after.data(),
        'before': change.data?.before.data(),
        'params': change.params,
        'location': change.location,
        'id': change.id,
    }
    logger.log('--------------------');
    console.log(hello)
    console.log('~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    // change.data?.after.ref.update({ newField: 'newFieldValue' });
    return hello;
})