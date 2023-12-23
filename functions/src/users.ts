import * as functions from "firebase-functions/v1";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { Active, Const, RoomUser, User, constToJSON } from "./Gen/data";
import { generateRandomAnimal, generateRandomString } from "./name_gen";
import { isAlphanumeric } from "./Helpers/regex";
import { deleteFCMToken } from "./messaging";

export const onUserCreate = functions
    .region('asia-south1')
    .auth.user().onCreate((user) => {
        const { uid, email, displayName, phoneNumber, photoURL } = user;

        admin.firestore().collection(constToJSON(Const.users)).doc(uid)
            .set(
                User.toJSON(User.create({
                    email: email,
                    nick: generateRandomString(8),
                    displayName: displayName ?? generateRandomAnimal(),
                    phoneNumber: phoneNumber,
                    photoURL: photoURL,
                    created: new Date(),
                    updated: new Date(),
                    status: Active.ONLINE,
                    friends: [],
                    admin: false,
                })) as Map<string, any>
                , { merge: true });

        return 'Created';
    });

export const callUserUpdate = onCall({
    enforceAppCheck: true,
    region: 'asia-south1',
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
        let nickCount = await admin.firestore().collection(constToJSON(Const.users))
            .where(constToJSON(Const.nick), '==', user.nick)
            .count().get().then((v) => v.data().count);
        if (nickCount != 0) {
            throw new HttpsError('aborted', 'Nick name already present');
        }
    }

    if (uid != null) {
        admin.auth().updateUser(uid, User.toJSON(user)!)
        admin.firestore().collection(constToJSON(Const.users)).doc(uid)
            .update(User.toJSON(user)!).catch((error) => {
                console.error('Error callUserUpdate'/*, error*/);
            });
    }
});

export const deleteAuthUser = functions
    .region('asia-south1')
    .auth.user().onDelete(async (user) => {
        const roomUserQuery = await admin.firestore().collection(constToJSON(Const.roomusers))
            .where('user', '==', user.uid).get()

        const db = admin.firestore();
        const batch = db.batch();
        roomUserQuery.forEach((doc) => {
            let ru = RoomUser.fromJSON(doc.data());

            //
            admin.storage().bucket().deleteFiles({
                prefix: `tweet/${ru.room}/${ru.user}`
            });

            //
            batch.delete(doc.ref);
        });
        await batch.commit();

        //
        admin.storage().bucket().deleteFiles({
            prefix: `profile/users/${user.uid}`
        });

        //
        admin.firestore().collection(constToJSON(Const.users))
            .doc(user.uid).delete()
            .catch((error) => {
                console.error('Error deleteAuthUser'/*, error*/);
            });

        //
        deleteFCMToken(user.uid);

        return { message: `Deleted all ${user.uid} documents.` };
    });

export const deleteUser = onDocumentDeleted({
    document: "users/{userId}",
    region: 'asia-south1',
}, async (event) => {
    admin.auth().deleteUser(event.params.userId)
        .catch((error) => {
            console.error('Error deleteUser'/*, error*/);
        });
});

export const checkUserExists = async (userId: string) => {
    return (await admin.firestore().collection(constToJSON(Const.users)).doc(userId).get()).exists;
}

export const getUserById = async (userId: string) => {
    let user = (await admin.firestore().collection(constToJSON(Const.users)).doc(userId).get().catch((e) => {
        console.error('No User');
        throw new HttpsError('aborted', 'No user found');
    })).data();
    return user != null ? User.fromJSON(user) : null;
}
