import { HttpsError, onCall } from "firebase-functions/v2/https";
import { Const, Role, Tweet } from "./Gen/data";
import { getRoomUserById } from "./room";
import { constName } from "./Helpers/const";
import * as admin from "firebase-admin";
import { FieldValue } from "firebase-admin/firestore";

export const sendTweet = onCall(async (request) => {
    let userId = request.auth!.uid;

    let tweet = Tweet.fromJSON(request.data)

    if (!tweet.room) {
        throw new HttpsError('invalid-argument', 'Invalid Room ID')
    }

    tweet.user = userId
    tweet.created = new Date()

    let u = await getRoomUserById(userId, tweet.room)

    if (u && u.role >= Role.USER) {
        await admin.firestore().collection(`${constName(Const.rooms)}/${tweet.room}/${constName(Const.tweets)}`).add(
            Tweet.toJSON(tweet) as Map<string, any>
        );

        admin.firestore().collection(constName(Const.rooms)).doc(tweet.room).set(
            {
                'tweetCount': FieldValue.increment(1)
            },
            { merge: true });
    } else {
        throw new HttpsError('invalid-argument', 'Invalid User')
    }
});

export const deleteTweet = onCall(async (request) => {
    let userId = request.auth!.uid;

    let tweet = Tweet.fromJSON(request.data)

    if (!tweet.room) {
        throw new HttpsError('invalid-argument', 'Invalid Room ID')
    }
    if (!tweet.uid) {
        throw new HttpsError('invalid-argument', 'Invalid Tweet ID')
    }

    let u = await getRoomUserById(userId, tweet.room)
    let tweetUser = await getRoomUserById(tweet.user, tweet.room)

    if (!u) {
        throw new HttpsError('invalid-argument', 'Not part of room')
    }

    if (tweet.user == userId || !tweetUser || u.role > tweetUser?.role) {
        await admin.firestore()
            .collection(`${constName(Const.rooms)}/${tweet.room}/${constName(Const.tweets)}`)
            .doc(tweet.uid).delete();

        admin.firestore().collection(constName(Const.rooms)).doc(tweet.room).set(
            {
                'tweetCount': FieldValue.increment(-1)
            },
            { merge: true });
    } else {
        throw new HttpsError('invalid-argument', 'Not enough privilege')
    }
});

export const getTweetById = async (tweetId: string, roomId: string) => {
    const tweetQuery = admin.firestore().collection(`${constName(Const.rooms)}/${roomId}/${constName(Const.tweets)}`).doc(tweetId)

    const tweetMap = (await tweetQuery.get()).data();

    if (!tweetMap) {
        return null;
    }

    return Tweet.fromJSON(tweetMap);
}
