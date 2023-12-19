import * as admin from "firebase-admin";
import * as users from "./users";
import * as room from "./room";
import * as roomuser from "./roomuser";
import * as tweet from "./tweet";
import * as image from "./image";
import * as messaging from "./messaging";
import { setGlobalOptions } from "firebase-functions/v2";

setGlobalOptions({
    maxInstances: 10,
    region: "asia-south1",
    timeoutSeconds: 60,
    memory: "2GiB",
});

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

// export const helloWorld = onRequest((request, response) => {
//     console.log(request.query);
//     response.set("Access-Control-Allow-Origin", "*");
//     console.log('Hello');
//     response.send("Hello from Firebase!");
// });

// export const sayHello = onCall((request) => {
//     console.log(request.data);

//     return {
//         message: "Hello from the emulator",
//         data: request.data,
//         auth: request.auth,
//     };
// });
