import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { Const, Role, Room, RoomUser, Visible } from "./Gen/data";
import { constName } from "./Helpers/const";
import { checkUserExists } from "./users";
import { deleteCollection } from "./Helpers/subcollection";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { generateRandomAnimal, generateRandomString } from "./name_gen";
import { isAlphanumeric } from "./Helpers/regex";
import { roomToJson, roomToMap } from "./Helpers/convertors";
import { getRoomUserById } from "./roomuser";
import { subscribeToTopic } from "./messaging";

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
            role: (e == currentUID) ? Role.ADMIN : Role.INVITE,
            created: new Date(),
            updated: new Date(),
        });
    });

    _room.created = new Date()
    _room.updated = new Date()

    if (currentUID != null) {
        let roomDoc = await admin.firestore().collection(constName(Const.rooms))
            .add(roomToJson(_room),);

        members.forEach(async (e) => {
            e.room = roomDoc.id;
            await admin.firestore().collection(constName(Const.roomusers)).doc(e.user + '_' + e.room).create(
                RoomUser.toJSON(e) as Map<string, any>
            ).then(() => {
                subscribeToTopic(e.user, e.room);
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

    if ((adminId === roomUser.user) || (adminUser && (adminUser.role == Role.ADMIN))) {

        await admin.firestore().collection(constName(Const.rooms))
            .doc(roomUser.room).delete();

        return { message: 'Room Deleted.' };
    } else {
        throw new HttpsError('permission-denied', 'You do not have permission to delete room.');
    }
});

export const onRoomDeleted = onDocumentDeleted("rooms/{room}", async (event) => {

    let room = event.params.room

    const roomUserQuery = await admin.firestore().collection(constName(Const.roomusers))
        .where('room', '==', room).get()

    const db = admin.firestore();
    const batch = db.batch();
    roomUserQuery.forEach((doc) => {
        batch.delete(doc.ref);
    });
    await batch.commit();

    admin.storage().bucket().deleteFiles({
        prefix: `tweet/${room}`
    });
    admin.storage().bucket().deleteFiles({
        prefix: `profile/rooms/${room}`
    });

    deleteCollection(`${constName(Const.rooms)}/${room}/tweets`, 100);
});

export const updateRoomInfo = onCall({
    enforceAppCheck: true,
}, async (request): Promise<string> => {
    let userId: string = request.auth!.uid;

    let room = Room.fromJSON(request.data)

    if (room.nick != null && room.nick != '') {
        if (!isAlphanumeric(room.nick) || room.nick?.length < 7 || (await roomNickExist(room.nick))) {
            throw new HttpsError('aborted', 'Nick name error');
        }
    }

    let r = roomToMap(room);

    if (room.open == Visible.INVALIDVISIBLE)
        r.delete(constName(Const.open))
    r.delete(constName(Const.uid))

    try {
        let roomUser = await getRoomUserById(userId, room.uid)
        if (roomUser && roomUser.role == Role.ADMIN) {
            await admin.firestore().collection(constName(Const.rooms)).doc(room.uid).update(
                Object.fromEntries(r),
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
        let nickCount = await admin.firestore().collection(constName(Const.rooms))
            .where(constName(Const.nick), '==', nick)
            .count().get()
            .then((v) => v.data().count);
        if (nickCount != 0) {
            return true;
        }
    }
    return false;
}

export const getRoomById = async (roomId: string) => {
    return await admin.firestore().collection(constName(Const.rooms)).doc(roomId).get().then((room) => {
        let data = room.data()
        return !data ? null : Room.fromJSON(data);
    }).catch((error) => {
        console.log(error)
        return null;
    });
}

export async function updateRoomTime(roomId: string) {
    await admin.firestore().collection(constName(Const.rooms)).doc(roomId).set(
        roomToJson(Room.create({
            updated: new Date()
        })
        ),
        { merge: true }
    );
}

