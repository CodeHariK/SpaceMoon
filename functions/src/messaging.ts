import * as admin from "firebase-admin";
import { Messaging, Tweet } from "./Gen/data";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { logger } from "firebase-functions";
import { onCall } from "firebase-functions/v2/https";

// export const sendMessage = onCall({
//     enforceAppCheck: true,
// }, (request): void => {
//     admin.messaging().send({
//         token: "device token",
//         data: {
//             hello: "world",
//         },
//         "notification": {
//             "title": "Match update",
//             "body": "Arsenal goal in added time, score is now 3-0"
//         },
//         // Set Android priority to "high"
//         android: {
//             priority: "high",
//         },
//         // Add APNS (Apple) config
//         apns: {
//             payload: {
//                 aps: {
//                     contentAvailable: true,
//                 },
//             },
//             headers: {
//                 "apns-push-type": "background",
//                 "apns-priority": "5", // Must be `5` when `contentAvailable` is set to true.
//                 "apns-topic": "io.flutter.plugins.firebase.messaging", // bundle identifier
//             },
//         },
//     });
// });

// export async function unsubscribeFromTopic(userId: string, roomId: string) {
//     let fcmToken = (await admin.auth().getUser(userId)).customClaims!['fcmToken'];
//     console.log('');
//     console.log(userId);
//     console.log(fcmToken);
//     console.log('');
//     if (fcmToken) {
//         admin.messaging().unsubscribeFromTopic(fcmToken, roomId).then((v) => {
//             console.log(v)
//         }).catch((e) => {
//             console.log(e)
//         });
//     }
// }

// export async function subscribeToTopic(userId: string, roomId: string) {
//     let fcmToken = (await admin.auth().getUser(userId)).customClaims!['fcmToken'];
//     console.log('');
//     console.log(userId);
//     console.log(fcmToken);
//     console.log('');
//     if (fcmToken) {
//         admin.messaging().subscribeToTopic(fcmToken, roomId).then((v) => {
//             console.log(v)
//         }).catch((e) => {
//             console.log(e)
//         });
//     }
// }

export async function tweetToTopic(roomId: string, userId: string, tweet: Tweet) {
    admin.messaging().send(
        {
            topic: roomId,
            // token: '',
            android: {
                priority: "high",
            },
            data: Tweet.toJSON(tweet) as {},
            notification: {
                "title": userId,
                "body": tweet.text,
                imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTE5fPhctwNLodS9VmAniEw_UiLWHgKs0fs1w&usqp=CAU',
            }
        }
    ).then((v) => {
        console.log(`send ${v}`)
    }).catch((e) => {
        console.log(e)
    });
}

// fetch(
//     "https://fcm.googleapis.com/v1/projects/spacemoonfire/messages:send",
//     {
//         method: "POST",
//         headers: {
//             "Content-Type": "application/json",
//         },
//         body: JSON.stringify({
//             "message": {
//                 "name": "string",
//                 "token": "cpx_7x41SXmPSV3G8mbql3:APA91bE0n3euIfNykVtgLc_6nhCj2CgiCm0-DhKmGRaQUXGBUjpM2f5kyjOe8UYkL3RxQ1l6P89Bvfp6-LZH9QXxhnRIVAALJAwyDRYXboZPB-HFnGS7z13XlyZgY-p7za5P6GPfbxFV",
//                 "data": Tweet.toJSON(tweet),
//                 "android": {
//                     "priority": "high",
//                 },
//                 "notification": {
//                     "title": user?.uid,
//                     "body": tweet.text,
//                 }
//             }
//         })
//     },
// ).then((v) => {
//     console.log(v.status)
//     return;
// })

// export const callFCMtokenUpdate = onCall({
//     enforceAppCheck: true,
// }, (request): void => {
//     let uid = request.auth?.uid;

//     const { fcmToken } = request.data;

//     if (uid != null) {
//         admin.auth().getUser(uid)
//             .then(async (userRecord) => {
//                 const currentCustomClaims = userRecord.customClaims || {};
//                 currentCustomClaims.fcmToken = fcmToken;

//                 await admin.auth().setCustomUserClaims(uid!, currentCustomClaims).then(() => {
//                     console.log(`Custom claim set ${fcmToken}`);
//                 }).catch((err) => {
//                     console.log(err)
//                 });
//             }).catch((error) => {
//                 throw new HttpsError('aborted', 'Error adding new field to custom claims');
//             });
//     } else {
//         throw new HttpsError('aborted', 'No user error');
//     }
// });


const EXPIRATION_TIME = 1000 * 60 * 60 * 24 * 10; // 10 days
export const pruneTokens = onSchedule('every 24 hours', async (event) => {
    const staleTokensResult = await admin.firestore().collection('fcmTokens')
        .where("timestamp", "<", new Date(Date.now() - EXPIRATION_TIME))
        .get();

    // Delete devices with stale tokens
    staleTokensResult.forEach(function (doc) { doc.ref.delete(); });

    logger.log("Token cleanup finished");
});
