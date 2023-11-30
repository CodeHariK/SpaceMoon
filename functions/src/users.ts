import * as functions from "firebase-functions/v1";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { Const, RoomUser, User } from "./Gen/data";
import { constName } from "./Helpers/const";
import { toMap } from "./Helpers/map";

export const onUserCreate = functions.auth.user().onCreate((user) => {
    const { uid, email, displayName, phoneNumber, photoURL } = user;

    admin.firestore().collection(constName(Const.users)).doc(uid)
        .set(
            User.toJSON(User.create({
                email: email,
                nick: uid,
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

export const callUserUpdate = onCall(async (request): Promise<void> => {
    let uid = request.auth?.uid;

    const { displayName, nick, photoURL } = request.data;

    const user = User.create({
        displayName: displayName,
        nick: nick?.toLowerCase(),
        photoURL: photoURL,
    });

    if (user.nick != null) {
        let nickCount = await admin.firestore().collection(constName(Const.users)).where(constName(Const.nick), '==', user.nick?.toLowerCase()).count().get().then((v) => v.data().count);
        if (nickCount != 0) {
            throw new HttpsError('aborted', 'Nick name already present');
        }
    }

    if (uid != null) {
        admin.auth().updateUser(uid, User.toJSON(user)!)
        admin.firestore().collection(constName(Const.users)).doc(uid)
            .update(userObj(user)).catch((error) => {
                console.error('Error callUserUpdate'/*, error*/);
            });
    }
});

export const callFCMtokenUpdate = onCall((request): void => {
    let uid = request.auth?.uid;

    const { fcmToken } = request.data;

    if (uid != null) {
        admin.auth().getUser(uid)
            .then((userRecord) => {
                const currentCustomClaims = userRecord.customClaims || {};
                currentCustomClaims.fcmToken = fcmToken;

                return admin.auth().setCustomUserClaims(uid!, currentCustomClaims);
            }).catch((error) => {
                console.error('Error adding new field to custom claims'/*, error*/);
            });
    } else {
        throw new HttpsError('aborted', 'No user error');
    }
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
    const roomUserQuery = await admin.firestore().collection(constName(Const.roomusers))
        .where('user', '==', user.uid).get()

    const db = admin.firestore();
    const batch = db.batch();
    roomUserQuery.forEach((doc) => {
        let ru = RoomUser.fromJSON(doc.data());
        admin.storage().bucket().deleteFiles({
            prefix: `tweet/${ru.room}/${ru.user}`
        });
        batch.delete(doc.ref);
    });
    await batch.commit();

    admin.storage().bucket().deleteFiles({
        prefix: `profile/users/${user.uid}`
    });

    admin.firestore().collection(constName(Const.users))
        .doc(user.uid).delete()
        .catch((error) => {
            console.error('Error deleteAuthUser'/*, error*/);
        });
    return { message: `Deleted all ${user.uid} documents.` };
});

export const deleteUser = onDocumentDeleted("users/{userId}", async (event) => {
    admin.auth().deleteUser(event.params.userId)
        .catch((error) => {
            console.error('Error deleteUser'/*, error*/);
        });
});

// Helper Functions ___________________________________________

export function userToMap(user: User) {
    return toMap(userToJson(user)!);
}

export function userToJson(user: User) {
    return User.toJSON(user)! as Map<String, any>;
}

export function userObj(user: User) {
    return Object.fromEntries(userToMap(user));
}
