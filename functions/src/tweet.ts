import { HttpsError, onCall } from "firebase-functions/v2/https";
import { Const, Role, Room, Tweet } from "./Gen/data";
import { getRoomUserById, roomToJson } from "./room";
import { constName } from "./Helpers/const";
import * as admin from "firebase-admin";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";

export const sendTweet = onCall({
    enforceAppCheck: true,
}, async (request) => {
    let userId = request.auth!.uid;

    let tweet = Tweet.fromJSON(request.data)

    if (!tweet.room) {
        throw new HttpsError('invalid-argument', 'Invalid Room ID')
    }

    let u = await getRoomUserById(userId, tweet.room)

    if (u && u.role >= Role.USER) {
        const sentTweet = await admin.firestore().collection(`${constName(Const.rooms)}/${tweet.room}/${constName(Const.tweets)}`).add(
            Tweet.toJSON(Tweet.create({
                user: userId,
                created: new Date(),
                text: tweet.text,
                mediaType: tweet.mediaType,
                link: tweet.link,
                gallery: tweet.gallery,
            })) as Map<string, any>
        );

        await admin.firestore().collection(constName(Const.rooms)).doc(tweet.room).set(
            roomToJson(Room.create({
                updated: new Date()
            })
            ),
            { merge: true },
        );

        return sentTweet.path
    } else {
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

    console.log(`${userId}   ${fetchTweet?.user}`)

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

    console.log(tweet)

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
    const tweetQuery = admin.firestore().collection(`${constName(Const.rooms)}/${roomId}/${constName(Const.tweets)}`).doc(tweetId)

    const tweetMap = (await tweetQuery.get()).data();

    if (!tweetMap) {
        return null;
    }

    return Tweet.fromJSON(tweetMap);
}
