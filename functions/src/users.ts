import * as functions from "firebase-functions/v1";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { Const, RoomUser, User } from "./Gen/data";
import { constName } from "./Helpers/const";
import { generateRandomAnimal, generateRandomString } from "./name_gen";
import { isAlphanumeric } from "./Helpers/regex";
import { userObj } from "./Helpers/convertors";

export const onUserCreate = functions.auth.user().onCreate((user) => {
    const { uid, email, displayName, phoneNumber, photoURL } = user;

    admin.firestore().collection(constName(Const.users)).doc(uid)
        .set(
            User.toJSON(User.create({
                email: email,
                nick: generateRandomString(8),
                displayName: displayName ?? generateRandomAnimal(),
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

export const callUserUpdate = onCall({
    enforceAppCheck: true,
}, async (request): Promise<void> => {
    let uid = request.auth?.uid;

    const { displayName, nick, photoURL } = request.data;

    const user = User.create({
        displayName: displayName,
        nick: nick,
        photoURL: photoURL,
    });

    if (user.nick != null && user.nick != '') {
        if (!isAlphanumeric(user.nick) || user.nick.length < 7) {
            throw new HttpsError('aborted', 'Nick name error');
        }
        let nickCount = await admin.firestore().collection(constName(Const.users)).where(constName(Const.nick), '==', user.nick).count().get().then((v) => v.data().count);
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

export const callFCMtokenUpdate = onCall({
    enforceAppCheck: true,
}, (request): void => {
    let uid = request.auth?.uid;

    const { fcmToken } = request.data;

    if (uid != null) {
        admin.auth().getUser(uid)
            .then(async (userRecord) => {
                const currentCustomClaims = userRecord.customClaims || {};
                currentCustomClaims.fcmToken = fcmToken;

                await admin.auth().setCustomUserClaims(uid!, currentCustomClaims).then(() => {
                    console.log(`Custom claim set ${fcmToken}`);
                }).catch((err) => {
                    console.log(err)
                });
            }).catch((error) => {
                throw new HttpsError('aborted', 'Error adding new field to custom claims');
            });
    } else {
        throw new HttpsError('aborted', 'No user error');
    }
});

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

export const checkUserExists = async (userId: string) => {
    return (await admin.firestore().collection(constName(Const.users)).doc(userId).get()).exists;
}
