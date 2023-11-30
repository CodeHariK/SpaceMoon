import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { Const, Role, Room, RoomUser } from "./Gen/data";
import { constName, visibleName } from "./Helpers/const";
import { checkUserExists } from "./users";
import { toMap } from "./Helpers/map";
import { deleteCollection } from "./Helpers/subcollection";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";

export const callCreateRoom = onCall(async (request): Promise<string | undefined> => {
    let currentUID: string = request.auth!.uid;

    const { room, users } = request.data;

    let _room = Room.fromJSON(room);

    if (await roomNickExist(_room.nick)) {
        console.log('nick exist');
        throw new HttpsError('aborted', 'Nick name already present');
    }
    console.log('continue');

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
            role: (e == currentUID) ? Role.ADMIN : Role.REQUEST,
            created: new Date(),
            updated: new Date(),
        });
    });

    _room.created = new Date()
    _room.updated = new Date()

    if (currentUID != null) {
        let roomDoc = await admin.firestore().collection(constName(Const.rooms)).add(roomToJson(_room),);

        members.forEach(async (e) => {
            e.room = roomDoc.id;
            await admin.firestore().collection(constName(Const.roomusers)).add(
                RoomUser.toJSON(e) as Map<string, any>
            );
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

export const requestAccessToRoom = onCall(async (request) => {
    let userId = request.auth!.uid;
    let _roomuser = RoomUser.fromJSON(request.data)

    if (!_roomuser.room) {
        throw new HttpsError('invalid-argument', 'Invalid Room ID')
    }

    let u = await getRoomUserById(userId, _roomuser.room)

    if (!u) {
        await admin.firestore().collection(constName(Const.roomusers)).add(
            RoomUser.toJSON(RoomUser.create({
                user: userId,
                room: _roomuser.room,
                created: new Date(),
                role: Role.REQUEST,
            })) as Map<string, any>
        );
    }

    return;
});

export const acceptAccessToRoom = onCall(async (request) => {
    let adminId = request.auth!.uid;
    let _roomuser = RoomUser.fromJSON(request.data)

    if (!_roomuser.room) {
        throw new HttpsError('invalid-argument', 'You must provide a RoomUser to accept.');
    }

    const adminUser = await getRoomUserById(adminId, _roomuser.room);

    if (adminUser && (adminUser.role == Role.ADMIN || adminUser.role == Role.MODERATOR)) {
        await admin.firestore().collection(constName(Const.roomusers)).doc(_roomuser.uid)
            .update(
                Object.fromEntries(roomUserToJson(RoomUser.create({
                    user: _roomuser.user,
                    room: _roomuser.room,
                    role: Role.USER,
                    created: new Date(),
                })))
            );

        // admin.firestore().collection(constName(Const.rooms)).doc(_roomuser.room).set(
        //     {
        //         'totalCount': FieldValue.increment(1)
        //     },
        //     { merge: true });

        return { message: 'The target user has been added to the room.' };
    } else {
        throw new HttpsError('permission-denied', 'You do not have permission to kick users from this room.');
    }
});

export const deleteRoom = onCall(async (request) => {
    let adminId = request.auth!.uid;
    let roomUser = RoomUser.fromJSON(request.data)

    if (!roomUser.room) {
        throw new HttpsError('invalid-argument', 'You must provide a RoomUser to remove.');
    }

    const adminUser = await getRoomUserById(adminId, roomUser.room);

    if ((adminId === roomUser.user) || (adminUser && (adminUser.role == Role.ADMIN))) {

        await admin.firestore().collection(constName(Const.rooms))
            .doc(roomUser.room).delete().then(() => {
                console.log('Room deleted');
            });

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

export const deleteRoomUser = onCall(async (request) => {
    let adminId = request.auth!.uid;
    let _roomuser = RoomUser.fromJSON(request.data)

    if (!_roomuser.room) {
        throw new HttpsError('invalid-argument', 'You must provide a RoomUser to remove.');
    }

    const adminUser = await getRoomUserById(adminId, _roomuser.room);

    if ((adminId === _roomuser.user) || (adminUser && (adminUser.role == Role.ADMIN || adminUser.role == Role.MODERATOR))) {
        await admin.firestore().collection(constName(Const.roomusers)).doc(_roomuser.uid).delete();

        return { message: 'The target user has been removed from the room.' };
    } else {
        throw new HttpsError('permission-denied', 'You do not have permission to kick users from this room.');
    }
});

export const onRoomUserDeleted = onDocumentDeleted("roomusers/{id}", async (event) => {

    const roomId = event.data?.data()['room'];

    const roomUsersQuery = (await admin.firestore().collection('roomusers')
        .where('room', '==', roomId).count().get()).data().count;

    if (roomUsersQuery == 0) {
        await admin.firestore().doc(`rooms/${roomId}`).delete();
        console.log(`Room ${roomId} deleted because it has no more room users.`);
    }

    return null;
});

export const updateRoomUserTime = onCall(async (request): Promise<string> => {

    let userId: string = request.auth!.uid;

    let roomUser = RoomUser.fromJSON(request.data)

    if (roomUser.user != userId) return 'Not enough permission';


    await admin.firestore().collection(constName(Const.roomusers)).doc(roomUser.uid)
        .update(
            Object.fromEntries(roomUserToMap(RoomUser.create({
                updated: new Date()
            })))
        ).catch((err) => {
            throw new HttpsError('aborted', 'updateRoomUserTime error');
        });
    return 'Updated';
});

async function roomNickExist(nick: string) {
    if (nick != null) {
        let nickCount = await admin.firestore().collection(constName(Const.rooms)).where(constName(Const.nick), '==', nick?.toLowerCase()).count().get().then((v) => v.data().count);
        console.log(nickCount);
        if (nickCount != 0) {
            return true;
        }
    }
    console.log('false');
    return false;
}

export const updateRoomInfo = onCall(async (request): Promise<string> => {
    let userId: string = request.auth!.uid;

    let room = Room.fromJSON(request.data)

    if (await roomNickExist(room.nick)) {
        throw new HttpsError('aborted', 'Nick name already present');
    }

    let r = roomToMap(Room.create({
        description: room.description,
        displayName: room.displayName,
        nick: room.nick?.toLowerCase(),
        photoURL: room.photoURL,
        open: room.open,
    }));

    let m = r.set(constName(Const.open), visibleName(room.open))

    try {
        let roomUser = await getRoomUserById(userId, room.uid)
        if (roomUser && roomUser.role == Role.ADMIN) {
            await admin.firestore().collection(constName(Const.rooms)).doc(room.uid).update(
                Object.fromEntries(m),
            );
        }
        return 'Done';
    }
    catch (e) {
        throw new HttpsError('aborted', e as string);
    }
});

export const getRoomUserById = async (userId: string, roomId: string) => {
    const roomUserQuery = admin.firestore().collection(constName(Const.roomusers))
        .where('user', '==', userId)
        .where('room', '==', roomId).limit(1);

    const roomUserDocs = await roomUserQuery.get();

    if (roomUserDocs.size === 0) {
        return null;
    }

    return RoomUser.fromJSON(roomUserDocs.docs.at(0)?.data());
}

// Helper Functions ___________________________________________

export function roomUserToMap(roomuser: RoomUser) {
    return toMap(RoomUser.toJSON(RoomUser.create(roomuser))!);
}

export function roomUserToJson(roomUser: RoomUser) {
    return RoomUser.toJSON(roomUser)! as Map<String, any>;
}


export function roomToMap(room: Room) {
    return toMap(Room.toJSON(room)!);
}

export function roomToJson(room: Room) {
    return Room.toJSON(room)! as Map<String, any>;
}
