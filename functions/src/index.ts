import * as admin from "firebase-admin";
import { firestore } from "firebase-functions";
import { onCall, onRequest } from "firebase-functions/v2/https";
import { beforeUserCreated, AuthBlockingEvent } from "firebase-functions/v2/identity";
import { onDocumentWritten, onDocumentCreated, onDocumentDeleted } from "firebase-functions/v2/firestore";
import { FieldValue } from "firebase-admin/firestore";
import * as users from "./users";

admin.initializeApp({ projectId: "spacemoonfire" });

export const helloWorld = onRequest((request, response) => {
    response.set("Access-Control-Allow-Origin", "*");
    console.log('Hello');
    response.send("Hello from Firebase!");
});

export const onUserCreate = users.onUserCreate;
export const callUserUpdate = users.callUserUpdate;
export const userHi = users.userHi;

export const sayHello = onCall((request) => {

    console.log(request.data);

    return {
        message: "Hello from the emulator",
        data: request.data,
        auth: request.auth,
    };
});

// export const docWrite = onDocumentWritten('counter/{spider}/{giraffe}/{deer}', (change) => {
//     console.log(change)
//     console.log(change.data?.before.data())
//     console.log(change.data?.after.data())
//     if (change.data?.before.data() === change.data?.after.data()) {
//         console.log('Same data');
//         return null;
//     }
//     change.data?.after.ref.update({ "Count": FieldValue.increment(2) });
//     return change;
// })

// export const upperCase = onDocumentCreated('/messages/{documentId}', (event) => {
//     let m = event.data?.data()!;
//     m['Counter'] = m['Counter'].toUpperCase();
//     event.data?.ref.set(m, { merge: true });
// })
