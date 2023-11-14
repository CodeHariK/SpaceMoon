import * as admin from "firebase-admin";
// import { firestore } from "firebase-functions";
import { onCall, onRequest } from "firebase-functions/v2/https";
// import { beforeUserCreated, AuthBlockingEvent } from "firebase-functions/v2/identity";
// import { onDocumentWritten, onDocumentCreated, onDocumentDeleted } from "firebase-functions/v2/firestore";
// import { FieldValue } from "firebase-admin/firestore";
import * as users from "./users";
import * as chat from "./room";
import * as tweet from "./tweet";
import * as image from "./image";

admin.initializeApp({ projectId: "spacemoonfire" });

export const onUserCreate = users.onUserCreate;
export const callUserUpdate = users.callUserUpdate;
export const addAdmin = users.addAdmin;
export const userHi = users.userHi;
export const deleteAuthUser = users.deleteAuthUser;
export const deleteUser = users.deleteUser;

export const callCreateRoom = chat.callCreateRoom;
export const requestAccessToRoom = chat.requestAccessToRoom;
export const deleteRoomUser = chat.deleteRoomUser;
export const acceptAccessToRoom = chat.acceptAccessToRoom;

export const sendTweet = tweet.sendTweet;
export const deleteTweet = tweet.deleteTweet;

export const generateThumbnail = image.generateThumbnail;

export const helloWorld = onRequest((request, response) => {
    response.set("Access-Control-Allow-Origin", "*");
    console.log('Hello');
    response.send("Hello from Firebase!");
});

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

