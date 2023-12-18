import { HttpsError, onCall, onRequest } from "firebase-functions/v2/https";
import { Const, Role, Tweet, constToJSON } from "./Gen/data";
import * as admin from "firebase-admin";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { getRoomUserById } from "./roomuser";
import { updateRoomTime } from "./room";
import { tweetToTopic } from "./messaging";
import { generateRandomString } from "./name_gen";

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

    if (user && user.role! >= Role.USER && user.role != Role.INVITE) {
        const sent = await admin.firestore()
            .collection(`${constToJSON(Const.rooms)}/${tweet.room}/${constToJSON(Const.tweets)}`)
            .add(
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

        tweetToTopic(tweet);

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

    let fetchTweet = await getTweetById(tweet.uid!, tweet.room);

    if (fetchTweet && userId === fetchTweet.user && fetchTweet?.gallery.length != tweet?.gallery.length && tweet?.gallery.length === 0) {
        await admin.firestore()
            .collection(`${constToJSON(Const.rooms)}/${tweet.room}/${constToJSON(Const.tweets)}`)
            .doc(tweet.uid!).delete();

        return;
    }

    if (fetchTweet && userId === fetchTweet.user) {
        await admin.firestore()
            .collection(`${constToJSON(Const.rooms)}/${tweet.room}/${constToJSON(Const.tweets)}`)
            .doc(tweet.uid!).set(
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

    let tweetUser = await getRoomUserById(fetchTweet.user!, tweet.room)

    if (!u) {
        throw new HttpsError('invalid-argument', 'Not part of room')
    }

    if (tweet.user === userId || !tweetUser || u.role! > tweetUser!.role!) {
        await admin.firestore().doc(tweet.path!).delete();
    } else {
        throw new HttpsError('invalid-argument', 'Not enough privilege')
    }
});

export const onTweetDeleted = onDocumentDeleted("rooms/{roomId}/tweets/{tweetId}", async (event) => {
    let path = `${Tweet.fromJSON(event.data?.data()).user}/${constToJSON(Const.rooms)}/${event.params.roomId}/${constToJSON(Const.tweets)}/${event.params.tweetId}`;

    await admin.storage().bucket().deleteFiles({
        prefix: path
    });
});

export const getTweetById = async (tweetId: string, roomId: string) => {
    const tweetQuery = admin.firestore()
        .collection(`${constToJSON(Const.rooms)}/${roomId}/${constToJSON(Const.tweets)}`).doc(tweetId)

    const tweetMap = (await tweetQuery.get()).data();

    return !tweetMap ? null : Tweet.fromJSON(tweetMap);
}
