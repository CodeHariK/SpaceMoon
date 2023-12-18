import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { Const, Role, Room, RoomUser, Visible, constToJSON } from "./Gen/data";
import { checkUserExists } from "./users";
import { deleteCollection } from "./Helpers/subcollection";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { generateRandomAnimal, generateRandomString } from "./name_gen";
import { isAlphanumeric } from "./Helpers/regex";
import { getRoomUserById } from "./roomuser";
import { toggleTopicSubsription } from "./messaging";

export const callCreateRoom = onCall({
    enforceAppCheck: true,
}, async (request): Promise<string | undefined> => {
    let currentUID: string = request.auth!.uid;

    const { room, users } = request.data;

    let _room = Room.fromJSON(room);

    _room.displayName = room.displayName ?? generateRandomAnimal();
    _room.nick = generateRandomString(8)
    _room.open = Visible.MODERATED

    if (await roomNickExist(_room.nick)) {
        throw new HttpsError('aborted', 'Nick name already present');
    }

    const f = await Promise.all(
        ((users ?? []) as string[])
            .filter(user => user !== currentUID)
            .map(async user => {
                let exists = await checkUserExists(user);
                return { user, exists };
            })
    );

    const m = f
        .filter(result => result.exists)
        .map(result => result.user);

    m.push(currentUID);

    let members = m.map((e) => {
        return RoomUser.create({
            user: e,
            role: (e === currentUID) ? Role.ADMIN : Role.INVITE,
            created: new Date(),
            updated: new Date(),
        });
    });

    _room.created = new Date()
    _room.updated = new Date()

    if (currentUID != null) {
        let roomDoc = await admin.firestore().collection(constToJSON(Const.rooms))
            .add(Room.toJSON(_room)!,);

        members.forEach(async (e) => {
            e.room = roomDoc.id;
            await admin.firestore().collection(constToJSON(Const.roomusers))
                .doc(e.user + '_' + e.room).create(
                    RoomUser.toJSON(e) as Map<string, any>
                ).then(() => {
                    toggleTopicSubsription(true, e.user!, e.room!, null);
                });
        });

        // admin.firestore().collection(constName(Const.rooms)).doc(roomDoc.id).set(
        //     {
        //         'totalCount': FieldValue.increment(members.length)
        //     },
        //     { merge: true });

        return roomDoc.id;
    }
    return;
});

export const deleteRoom = onCall({
    enforceAppCheck: true,
}, async (request) => {
    let adminId = request.auth!.uid;
    let roomUser = RoomUser.fromJSON(request.data)

    if (!roomUser.room) {
        throw new HttpsError('invalid-argument', 'You must provide a RoomUser to remove.');
    }

    const adminUser = await getRoomUserById(adminId, roomUser.room);

    if ((adminId === roomUser.user) || (adminUser && (adminUser.role === Role.ADMIN))) {

        await admin.firestore().collection(constToJSON(Const.rooms))
            .doc(roomUser.room).delete();

        return { message: 'Room Deleted.' };
    } else {
        throw new HttpsError('permission-denied', 'You do not have permission to delete room.');
    }
});

export const onRoomDeleted = onDocumentDeleted("rooms/{room}", async (event) => {

    let room = event.params.room

    const roomUserQuery = await admin.firestore().collection(constToJSON(Const.roomusers))
        .where('room', '==', room).get()

    const db = admin.firestore();
    const batch = db.batch();
    roomUserQuery.forEach((doc) => {
        let roomuser = RoomUser.fromJSON(doc.data());
        toggleTopicSubsription(false, roomuser.user!, roomuser.room!, null);
        batch.delete(doc.ref);
    });
    await batch.commit();

    admin.storage().bucket().deleteFiles({
        prefix: `tweet/${room}`
    });
    admin.storage().bucket().deleteFiles({
        prefix: `profile/rooms/${room}`
    });

    deleteCollection(`${constToJSON(Const.rooms)}/${room}/tweets`, 100);
});

export const updateRoomInfo = onCall({
    enforceAppCheck: true,
}, async (request): Promise<string> => {
    let userId: string = request.auth!.uid;

    let room = Room.fromJSON(request.data)
    let roomId = room.uid!

    if (room.nick && room.nick !== '') {
        if (!isAlphanumeric(room.nick) || room.nick?.length < 7 || (await roomNickExist(room.nick))) {
            throw new HttpsError('aborted', 'Nick name error');
        }
    }

    room.uid = undefined

    try {
        let roomUser = await getRoomUserById(userId, roomId)
        if (roomUser && roomUser.role === Role.ADMIN) {
            await admin.firestore().collection(constToJSON(Const.rooms))
                .doc(roomId).update(
                    Room.toJSON(room)!,
                );
        }
        return 'Done';
    }
    catch (e) {
        throw new HttpsError('aborted', e as string);
    }
});

async function roomNickExist(nick: string) {
    if (nick != null) {
        let nickCount = await admin.firestore().collection(constToJSON(Const.rooms))
            .where(constToJSON(Const.nick), '==', nick)
            .count().get()
            .then((v) => v.data().count);
        if (nickCount != 0) {
            return true;
        }
    }
    return false;
}

export const getRoomById = async (roomId: string) => {
    return await admin.firestore().collection(constToJSON(Const.rooms)).doc(roomId).get().then((room) => {
        let data = room.data()
        return !data ? null : Room.fromJSON(data);
    }).catch((error) => {
        console.log(error)
        return null;
    });
}

export async function updateRoomTime(roomId: string) {
    await admin.firestore().collection(constToJSON(Const.rooms)).doc(roomId).update(
        RoomUser.toJSON(Room.create({
            updated: new Date()
        }))!
    );
}

