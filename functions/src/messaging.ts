import * as admin from "firebase-admin";
import { onCall } from "firebase-functions/v2/https";
import { Tweet } from "./Gen/data";

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

