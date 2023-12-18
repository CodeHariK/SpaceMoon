import * as admin from "firebase-admin";
import { Const, Messaging, RoomUser, Tweet, User, constToJSON, mediaTypeToJSON } from "./Gen/data";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { logger } from "firebase-functions";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { checkUserExists, getUserById } from "./users";
import { getRoomById } from "./room";
const mime = require('mime-types')

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

export const callUnsubscribeFromTopic = onCall({
    enforceAppCheck: true,
}, async (request): Promise<void> => {
    let uid = request.auth!.uid;

    const roomuser = RoomUser.fromJSON(request.data);

    toggleTopicSubsription(false, uid, roomuser.room!, null)

    return;
})

export const callSubscribeFromTopic = onCall({
    enforceAppCheck: true,
}, async (request): Promise<void> => {
    let uid = request.auth!.uid;

    const roomuser = RoomUser.fromJSON(request.data);

    toggleTopicSubsription(true, uid, roomuser.room!, null)

    return;
})

export async function toggleTopicSubsription(subscribe: boolean, userId: string, roomId: string, token: string | null) {
    let fcmToken = token ?? Messaging.fromJSON((await admin.firestore()
        .doc(`fcmTokens/${userId}`).get().catch((e) => {
            throw new HttpsError('aborted', e);
        })).data()).fcmToken;

    if (fcmToken) {
        (subscribe ?
            admin.messaging().subscribeToTopic(fcmToken, roomId)
            : admin.messaging().unsubscribeFromTopic(fcmToken, roomId))
            .then(async (v) => {
                await admin.firestore().collection(constToJSON(Const.roomusers))
                    .doc(`${userId}_${roomId}`)
                    .update(
                        RoomUser.toJSON(RoomUser.create({
                            subscribed: subscribe,
                            updated: new Date(),
                        }))!)
                    .then(
                        async () => {
                            // await admin.firestore().collection(constToJSON(Const.users))
                            //     .doc(userId)
                            //     .update(
                            //         User.toJSON(User.create({
                            //             updated: new Date()
                            //         }))!
                            //     )
                            //     .catch((err) => {
                            //         throw new HttpsError('aborted', 'updateUserTime error');
                            //     });
                        }
                    )
                    .catch((err) => {
                        throw new HttpsError('aborted', 'updateRoomUser failed');
                    });
            }).catch((e) => {
                console.log(e)
            });
    }
    return;
}

export async function tweetToTopic(tweet: Tweet) {

    let imgMeta = tweet.gallery?.find((imageMeta) => {
        if (imageMeta.url == null) {
            return false;
        }
        console.log(mime.lookup(imageMeta.url))
        return imageMeta.url.includes('unsplash') || mime.lookup(imageMeta.url)?.includes('image');
    })

    let user = await getUserById(tweet.user!)
    let room = await getRoomById(tweet.room!)
    let text = tweet.text?.substring(0, 120);
    text = text?.includes('AppFlowy') ? 'Post' : text

    admin.messaging().send(
        {
            topic: tweet.room!,
            // token: '',
            android: {
                priority: "high",
            },
            data: {
                'uid': tweet.uid!,
                'room': tweet.room!,
                'user': tweet.user!,
                'mediaType': mediaTypeToJSON(tweet.mediaType!),
            },
            notification: {
                "title": `${room?.displayName}  (${user?.displayName})`,
                "body": text,
                imageUrl: imgMeta ? imgMeta.url : undefined,
            }
        }
    ).then((v) => {
        console.log(`send ${v}`)
    }).catch((e) => {
        console.log(e)
    });
    return;
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

export async function deleteFCMToken(userId: string) {
    await admin.firestore().doc(`fcmTokens/${userId}`).delete().catch((e) => {
        console.log('Failed deleteFCMToken')
    })
}

export const callFCMtokenUpdate = onCall({
    enforceAppCheck: true,
}, async (request): Promise<void> => {
    let uid = request.auth?.uid;

    const { fcmToken } = request.data;

    let userExists = await checkUserExists(uid!)

    if (userExists) {
        admin.firestore().doc(`fcmTokens/${uid}`).set(
            Messaging.toJSON(
                Messaging.create({
                    fcmToken: fcmToken,
                    timestamp: new Date(),
                })
            )!, { merge: true })
            .catch((error) => {
                throw new HttpsError('aborted', 'Error adding new field to custom claims');
            });
    } else {
        throw new HttpsError('aborted', 'No user error');
    }
    return;
});


const EXPIRATION_TIME = 1000 * 60 * 60 * 24 * 60;
export const pruneTokens = onSchedule('every 24 hours', async (event) => {
    const staleTokensResult = await admin.firestore().collection('fcmTokens')
        .where("timestamp", "<", new Date(Date.now() - EXPIRATION_TIME))
        .get();

    // Delete devices with stale tokens
    staleTokensResult.forEach(function (doc) { doc.ref.delete(); });

    logger.log("Token cleanup finished");
    return;
});
