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
    region: 'asia-south1',
    timeoutSeconds: 60,
    memory: "2GiB",
});

let serviceAccount = require("../serviceAccountKey.json");
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    projectId: "spacemoonfire",
    storageBucket: 'spacemoonfire.appspot.com',
});

exports.user = {
    onUserCreate: users.onUserCreate,
    callUserUpdate: users.callUserUpdate,
    deleteAuthUser: users.deleteAuthUser,
    deleteUser: users.deleteUser,
}

exports.room = {
    callCreateRoom: room.callCreateRoom,
    updateRoomInfo: room.updateRoomInfo,
    deleteRoom: room.deleteRoom,
    onRoomDeleted: room.onRoomDeleted,
}

exports.roomuser = {
    deleteRoomUser: roomuser.deleteRoomUser,
    onRoomUserDeleted: roomuser.onRoomUserDeleted,
    updateRoomUserTime: roomuser.updateRoomUserTime,
    upgradeAccessToRoom: roomuser.upgradeAccessToRoom,
}

exports.tweet = {
    sendTweet: tweet.sendTweet,
    updateTweet: tweet.updateTweet,
    onTweetDeleted: tweet.onTweetDeleted,
    deleteTweet: tweet.deleteTweet,
}

export const generateThumbnail = image.generateThumbnail;

exports.messaging = {
    callSubscribeFromTopic: messaging.callSubscribeFromTopic,
    callUnsubscribeFromTopic: messaging.callUnsubscribeFromTopic,
    callFCMtokenUpdate: messaging.callFCMtokenUpdate,
    pruneTokens: messaging.pruneTokens,
}

// export const helloWorld = onRequest((request, response) => {
//     console.log(request.query);
//     response.set("Access-Control-Allow-Origin", "*");
//     console.log('Hello');
//     response.send("Hello from Firebase!");
// });


// const sayHello = onCall((request) => {
//     console.log(request.data);

//     return {
//         message: "Hello from the emulator",
//         data: request.data,
//         auth: request.auth,
//     };
// });

// exports.hello = {
//     sh: sayHello
// }
