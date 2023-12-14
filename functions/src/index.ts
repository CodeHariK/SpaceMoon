import * as admin from "firebase-admin";
import { onCall, onRequest } from "firebase-functions/v2/https";
import * as users from "./users";
import * as room from "./room";
import * as roomuser from "./roomuser";
import * as tweet from "./tweet";
import * as image from "./image";
import * as messaging from "./messaging";

let serviceAccount = require("../serviceAccountKey.json");
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    projectId: "spacemoonfire",
    storageBucket: 'spacemoonfire.appspot.com',
});

export const onUserCreate = users.onUserCreate;
export const callUserUpdate = users.callUserUpdate;
export const deleteAuthUser = users.deleteAuthUser;
export const deleteUser = users.deleteUser;

export const callCreateRoom = room.callCreateRoom;
export const updateRoomInfo = room.updateRoomInfo;
export const deleteRoom = room.deleteRoom;
export const onRoomDeleted = room.onRoomDeleted;

export const deleteRoomUser = roomuser.deleteRoomUser;
export const onRoomUserDeleted = roomuser.onRoomUserDeleted;
export const updateRoomUserTime = roomuser.updateRoomUserTime;
export const upgradeAccessToRoom = roomuser.upgradeAccessToRoom;

export const sendTweet = tweet.sendTweet;
export const updateTweet = tweet.updateTweet;
export const onTweetDeleted = tweet.onTweetDeleted;
export const deleteTweet = tweet.deleteTweet;

export const generateThumbnail = image.generateThumbnail;

export const callSubscribeFromTopic = messaging.callSubscribeFromTopic;
export const callUnsubscribeFromTopic = messaging.callUnsubscribeFromTopic;
export const callFCMtokenUpdate = messaging.callFCMtokenUpdate;
export const pruneTokens = messaging.pruneTokens;

export const helloWorld = onRequest((request, response) => {
    console.log(request.query);
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

