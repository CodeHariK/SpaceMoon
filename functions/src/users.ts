import * as functions from "firebase-functions/v1";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { onCall, onRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { Const, User } from "./Gen/data";
import { constName } from "./Helpers/const";


export const onUserCreate = functions.auth.user().onCreate((user) => {
    const { uid, email, displayName, phoneNumber, photoURL } = user;

    admin.firestore().collection(constName(Const.users)).doc(uid)
        .set(
            User.toJSON(User.create({
                email: email,
                nick: '@' + uid,
                displayName: displayName ?? uid,
                phoneNumber: phoneNumber,
                photoURL: photoURL,
                created: new Date(),
            })) as Map<string, any>
            , { merge: true });

    admin.auth().setCustomUserClaims(uid, {
        manager: false,
    });

    return 'Created';
});

export const callUserUpdate = onCall((request): void => {
    let uid = request.auth?.uid;

    const { displayName, nick, photoURL, fcmToken } = request.data;

    const obj = {
        displayName: displayName,
        nick: nick,
        photoURL: photoURL,
        fcmToken: fcmToken,
    };

    if (uid != null) {
        admin.auth().updateUser(uid, User.toJSON(User.create(obj))!)
        admin.firestore().collection(constName(Const.users)).doc(uid).set(userToMap(obj), { merge: true });
    }
});

export const userHi = onRequest((request, resp): void => {
    resp.send('Hello');
    return;
});

export const checkUserExists = async (userId: string) => {
    return (await admin.firestore().collection(constName(Const.users)).doc(userId).get()).exists;
}

export const getUserById = async (userId: string) => {
    return (await admin.firestore().collection(constName(Const.users)).doc(userId).get()).data();
}

export const addAdmin = onCall(async (request) => {
    if (request.auth?.token.moderator !== true) {
        return {
            error: "Request not authorized. User is not moderator  to fulfill request.",
        };
    }
    const uid = request.data.uid;
    return grantModerateRole(uid).then(() => {
        return {
            result: `Request fulfilled! ${uid} is now a moderator.`,
        };
    });
});

async function grantModerateRole(uid: string) {
    const user = await admin.auth().getUser(uid);
    if (user.customClaims && (user.customClaims as any).moderator === true) {
        return;
    }
    return admin.auth().setCustomUserClaims(user.uid, {
        moderator: true,
        manager: true,
    });
}

export const deleteAuthUser = functions.auth.user().onDelete(async (user) => {

    admin.firestore().collection(constName(Const.users))
        .doc(user.uid).delete();

    const roomUserQuery = await admin.firestore().collection(constName(Const.roomusers))
        .where('user', '==', user.uid).get()

    const db = admin.firestore();
    const batch = db.batch();
    roomUserQuery.forEach((doc) => {
        batch.delete(doc.ref);
    });
    await batch.commit();

    admin.storage().bucket().deleteFiles({
        prefix: user.uid
    });

    return { message: `Deleted all ${user.uid} documents.` };
});

export const deleteUser = onDocumentDeleted("users/{userId}", async (event) => {
    // console.log(await admin.auth().getUser(event.params.userId))
    // admin.auth().deleteUser(event.params.userId);
});

// Helper Functions ___________________________________________

export function userToMap(obj: any) {
    return User.toJSON(User.create(obj)) as Map<string, any>;
}