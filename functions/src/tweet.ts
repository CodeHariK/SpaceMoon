import { HttpsError, onCall } from "firebase-functions/v2/https";
import { Const, Role, Room, Tweet } from "./Gen/data";
import { constName } from "./Helpers/const";
import * as admin from "firebase-admin";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { getRoomUserById } from "./roomuser";
import { roomToJson } from "./Helpers/convertors";
import { updateRoomTime } from "./room";

export const sendTweet = onCall({
    enforceAppCheck: true,
}, async (request) => {
    let userId = request.auth!.uid;

    let tweet = Tweet.fromJSON(request.data)

    if (!tweet.room) {
        throw new HttpsError('invalid-argument', 'Invalid Room ID')
    }

    let user = await getRoomUserById(userId, tweet.room)

    tweet.created = new Date()
    tweet.user = userId

    if (user && user.role >= Role.USER && user.role != Role.INVITE) {
        const sent = await admin.firestore().collection(`${constName(Const.rooms)}/${tweet.room}/${constName(Const.tweets)}`).add(
            Tweet.toJSON(Tweet.create({
                user: userId,
                created: new Date(),
                text: tweet.text,
                mediaType: tweet.mediaType,
                link: tweet.link,
                gallery: tweet.gallery,
            })) as Map<string, any>
        );

        tweet.uid = sent.id;

        // console.log(tweet)

        // admin.messaging().sendToTopic('Hello', {
        //     data: Tweet.toJSON(tweet) as {},
        //     notification: {
        //         "title": user?.uid,
        //         "body": tweet.text,
        //     }
        // })

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

        // admin.messaging().sendEachForMulticast({
        //     tokens: ['cpx_7x41SXmPSV3G8mbql3:APA91bE0n3euIfNykVtgLc_6nhCj2CgiCm0-DhKmGRaQUXGBUjpM2f5kyjOe8UYkL3RxQ1l6P89Bvfp6-LZH9QXxhnRIVAALJAwyDRYXboZPB-HFnGS7z13XlyZgY-p7za5P6GPfbxFV'],
        //     android: {
        //         priority: "high",
        //     },
        //     data: Tweet.toJSON(tweet) as {},
        //     notification: {
        //         "title": user?.uid,
        //         "body": tweet.text,
        //         imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTE5fPhctwNLodS9VmAniEw_UiLWHgKs0fs1w&usqp=CAU',
        //     }
        // })

        admin.messaging().send(
            {
                topic: tweet.room,
                // token: 'cpx_7x41SXmPSV3G8mbql3:APA91bE0n3euIfNykVtgLc_6nhCj2CgiCm0-DhKmGRaQUXGBUjpM2f5kyjOe8UYkL3RxQ1l6P89Bvfp6-LZH9QXxhnRIVAALJAwyDRYXboZPB-HFnGS7z13XlyZgY-p7za5P6GPfbxFV',
                android: {
                    priority: "high",
                },
                data: Tweet.toJSON(tweet) as {},
                notification: {
                    "title": user?.uid,
                    "body": tweet.text.substring(0, 30),
                    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTE5fPhctwNLodS9VmAniEw_UiLWHgKs0fs1w&usqp=CAU',
                }
            }
        ).then((v) => {
            console.log(`send ${v}`)
        })

        // admin.messaging().sendEach(
        //     [
        //         {
        //             token: 'cpx_7x41SXmPSV3G8mbql3:APA91bE0n3euIfNykVtgLc_6nhCj2CgiCm0-DhKmGRaQUXGBUjpM2f5kyjOe8UYkL3RxQ1l6P89Bvfp6-LZH9QXxhnRIVAALJAwyDRYXboZPB-HFnGS7z13XlyZgY-p7za5P6GPfbxFV',
        //             android: {
        //                 priority: "high",
        //             },
        //             data: Tweet.toJSON(tweet) as {},
        //             notification: {
        //                 "title": user?.uid,
        //                 "body": tweet.text,
        //                 imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTE5fPhctwNLodS9VmAniEw_UiLWHgKs0fs1w&usqp=CAU',
        //             }

        //         }
        //     ]
        // ).then((v) => {
        //     console.log(`sendEach ${v.successCount}`)
        // })



        // admin.messaging().sendToTopic(
        //     tweet.room,
        //     {
        //         'data': {
        //             'type': 'new_message',
        //             'user': userId,
        //             'messageId': sent.path,
        //             'content': 'Hello, world! ' + tweet.text,
        //         },
        //     }
        // );

        await updateRoomTime(tweet.room);

        return sent.path
    } else {
        console.log('Invalid User')
        throw new HttpsError('invalid-argument', 'Invalid User')
    }
});

export const updateTweet = onCall({
    enforceAppCheck: true,
}, async (request) => {
    let userId = request.auth!.uid;

    let tweet = Tweet.fromJSON(request.data)

    if (!tweet.room) {
        throw new HttpsError('invalid-argument', 'Invalid Room ID')
    }
    if (!tweet.path) {
        throw new HttpsError('invalid-argument', 'Invalid Tweet ID')
    }

    let fetchTweet = await getTweetById(tweet.uid, tweet.room);

    if (fetchTweet && userId === fetchTweet.user && fetchTweet?.gallery.length != tweet?.gallery.length && tweet?.gallery.length == 0) {
        await admin.firestore().collection(`${constName(Const.rooms)}/${tweet.room}/${constName(Const.tweets)}`)
            .doc(tweet.uid).delete();

        return;
    }

    if (fetchTweet && userId === fetchTweet.user) {
        await admin.firestore().collection(`${constName(Const.rooms)}/${tweet.room}/${constName(Const.tweets)}`)
            .doc(tweet.uid).set(
                Tweet.toJSON(Tweet.create({
                    user: userId,
                    created: fetchTweet.created,
                    text: tweet.text,
                    mediaType: tweet.mediaType,
                    link: tweet.link,
                    gallery: tweet.gallery,
                })) as Map<string, any>
            );
    }
    else {
        throw new HttpsError('invalid-argument', 'Invalid User')
    }
});

export const deleteTweet = onCall({
    enforceAppCheck: true,
}, async (request) => {
    let userId = request.auth!.uid;

    let tweet = Tweet.fromJSON(request.data)

    if (!tweet.room) {
        throw new HttpsError('invalid-argument', 'Invalid Room ID')
    }
    if (!tweet.uid) {
        throw new HttpsError('invalid-argument', 'Invalid Tweet ID')
    }

    let u = await getRoomUserById(userId, tweet.room)
    let fetchTweet = await getTweetById(tweet.uid, tweet.room);

    if (!fetchTweet) {
        throw new HttpsError('invalid-argument', 'Invalid Tweet')
    }

    let tweetUser = await getRoomUserById(fetchTweet.user, tweet.room)

    if (!u) {
        throw new HttpsError('invalid-argument', 'Not part of room')
    }

    if (tweet.user == userId || !tweetUser || u.role > tweetUser?.role) {
        await admin.firestore().doc(tweet.path).delete();
    } else {
        throw new HttpsError('invalid-argument', 'Not enough privilege')
    }
});

export const onTweetDeleted = onDocumentDeleted("rooms/{roomId}/tweets/{tweetId}", async (event) => {
    let path = `${Tweet.fromJSON(event.data?.data()).user}/${constName(Const.rooms)}/${event.params.roomId}/${constName(Const.tweets)}/${event.params.tweetId}`;

    await admin.storage().bucket().deleteFiles({
        prefix: path
    });
});

export const getTweetById = async (tweetId: string, roomId: string) => {
    const tweetQuery = admin.firestore()
        .collection(`${constName(Const.rooms)}/${roomId}/${constName(Const.tweets)}`).doc(tweetId)

    const tweetMap = (await tweetQuery.get()).data();

    return !tweetMap ? null : Tweet.fromJSON(tweetMap);
}
