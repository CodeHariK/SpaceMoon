import { AuthBlockingEvent, beforeUserCreated } from "firebase-functions/v2/identity";
import { onCall, onRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { Const, User } from "./Gen/data";

export const onUserCreate = beforeUserCreated((event: AuthBlockingEvent) => {
    const { uid, email, displayName, phoneNumber, photoURL } = event.data;

    const obj = {
        email: email,
        displayName: displayName,
        phoneNumber: phoneNumber,
        photoURL: photoURL,
        created: new Date(),
    };

    admin.firestore().collection(constName(Const.users)).doc(uid).set(User.toJSON(User.create(obj))!, { merge: true });
});

export const callUserUpdate = onCall((request): void => {
    let uid = request.auth?.uid;


    const { displayName, photoURL, fcmToken } = request.data;

    const obj = {
        displayName: displayName,
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

// Helper Functions ___________________________________________

export function constName(name: number) {
    return (Object.entries(Const)[name][1] as string);
}

function userToMap(obj: any) {
    return User.toJSON(User.create(obj)) as Map<string, any>;
}