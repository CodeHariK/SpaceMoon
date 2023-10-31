import { AuthBlockingEvent, beforeUserCreated } from "firebase-functions/v2/identity";
import { onCall, onRequest } from "firebase-functions/v1/https";
import * as admin from "firebase-admin";
// import { Timestamp } from "./gen/google/protobuf/timestamp";
import { Const, User } from "./gen/data";

export const onUserCreate = beforeUserCreated((event: AuthBlockingEvent) => {
    const { uid, email, displayName, phoneNumber, photoURL } = event.data;

    const obj = {
        // uid: uid,
        email: email,
        displayName: displayName,
        phoneNumber: phoneNumber,
        photoURL: photoURL,
        created: (new Date()).toISOString(),
    };


    admin.firestore().collection(name(Const.users)).doc(uid).set(User.toJSON(User.create(obj))!, { merge: true });
});

export const callUserUpdate = onCall((data, context): void => {
    let uid = context.auth?.uid;

    const { displayName, photoURL } = data;

    const obj = {
        displayName: displayName,
        photoURL: photoURL,
    };

    if (uid != null) {

        admin.auth().updateUser(uid, User.toJSON(User.create(obj))!)

        admin.firestore().collection(name(Const.users)).doc(uid).set(User.toJSON(User.create(obj))!, { merge: true });
    }
});


export const userHi = onRequest((request, resp): void => {
    resp.send('Hello')
    return;
});

export function name(name: number) {
    return (Object.entries(Const)[name][1] as String).toUpperCase();
}

export const addAdmin = onCall(async (request) => {
    if (request.auth.token.moderator !== true) {
        return {
            error: "Request not authorized. User is not moderator  to fulfill request.",
        };
    }
    const email = request.data.email;
    return grantModerateRole(email).then(() => {
        return {
            result: `Request fulfilled! ${email} is now a moderator.`,
        };
    });
});

async function grantModerateRole(email: string) {
    const user = await admin.auth().getUserByEmail(email);
    if (user.customClaims && (user.customClaims as any).moderator === true) {
        return;
    }
    return admin.auth().setCustomUserClaims(user.uid, {
        moderator: true,
        manager: true,
    });
}
