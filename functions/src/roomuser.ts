import { HttpsError, onCall } from "firebase-functions/v2/https";
import { Const, Role, RoomUser, Visible } from "./Gen/data";
import { constName } from "./Helpers/const";
import * as admin from "firebase-admin";
import { roomUserToMap } from "./Helpers/convertors";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { getRoomById } from "./room";
import { toArray, toMap } from "./Helpers/map";

export const getRoomUserById = async (userId: string, roomId: string) => {
    return await admin.firestore().collection(constName(Const.roomusers))
        .doc(`${userId}_${roomId}`).get().then((roomUser) => {
            let data = roomUser.data()
            return data == undefined ? undefined : RoomUser.fromJSON(data);
        }).catch((error) => {
            console.log(error)
            return undefined;
        });
}

export const updateRoomUserTime = onCall({
    enforceAppCheck: true,
}, async (request): Promise<string> => {

    let userId: string = request.auth!.uid;

    let _roomuser = RoomUser.fromJSON(request.data)

    let roomUser = await getRoomUserById(userId, _roomuser.room)

    if (roomUser?.user != userId) return 'Not enough permission';

    await admin.firestore().collection(constName(Const.roomusers)).doc(`${userId}_${_roomuser.room}`)
        .update(Object.fromEntries(roomUserToMap(RoomUser.create({
            updated: new Date()
        }))))
        .catch((err) => {
            throw new HttpsError('aborted', 'updateRoomUserTime error');
        });
    return 'Updated';
});

export const onRoomUserDeleted = onDocumentDeleted("roomusers/{id}", async (event) => {

    const roomId = event.data?.data()['room'];
    const userId = event.data?.data()['user'];

    await admin.storage().bucket().deleteFiles({
        prefix: `tweet/${roomId}/${userId}`
    }).catch((error) => {
        console.log('Error deleting roomuser storage')
    });

    const roomUsersQuery = (await admin.firestore().collection('roomusers')
        .where('room', '==', roomId).count().get()).data().count;

    if (roomUsersQuery == 0) {
        await admin.firestore().doc(`rooms/${roomId}`).delete();
        return `Room ${roomId} deleted because it has no more room users.`;
    }

    return null;
});

export const deleteRoomUser = onCall({
    enforceAppCheck: true,
}, async (request) => {
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

export const requestAccessToRoom = onCall({
    enforceAppCheck: true,
}, async (request) => {

    let userId = request.auth!.uid;
    let _roomuser = RoomUser.fromJSON(request.data)

    if (!_roomuser.room) {
        throw new HttpsError('invalid-argument', 'Invalid Room ID')
    }

    let u = await getRoomUserById(userId, _roomuser.room)
    let room = await getRoomById(_roomuser.room);

    if (!u && room) {
        await admin.firestore().collection(constName(Const.roomusers)).doc(userId + '_' + _roomuser.room).create(
            RoomUser.toJSON(RoomUser.create({
                user: userId,
                room: _roomuser.room,
                created: new Date(),
                updated: new Date(),
                role: room.open == Visible.OPEN ? Role.USER : Role.REQUEST,
            })) as Map<string, any>
        ).then(() => {
            console.log(`Room User Created ${userId + '_' + _roomuser.room}`);
        }).catch((error) => {
            console.log(error);
        });
    }

    return `Room User Created ${userId + '_' + _roomuser.room}`;
});

export const upgradeAccessToRoom = onCall({
    enforceAppCheck: true,
}, async (request) => {
    let adminId = request.auth!.uid;
    let _roomuser = RoomUser.fromJSON(request.data)

    if (!_roomuser.room || !_roomuser.user) {
        throw new HttpsError('invalid-argument', 'Invalid RoomUser.');
    }

    const curUser = await getRoomUserById(_roomuser.user, _roomuser.room);
    const adminUser = adminId == _roomuser.user ? curUser : await getRoomUserById(adminId, _roomuser.room);

    let room = await getRoomById(_roomuser.room);

    console.log(adminUser)
    console.log(curUser)

    if (room && (adminId == _roomuser.user || adminUser)) {

        let currole = curUser?.role
        let adminrole = adminUser?.role

        let defaultRole = (room.open == Visible.OPEN ? Role.USER : Role.REQUEST)

        let role = curUser == null
            ? defaultRole
            : (currole == Role.REQUEST ? Role.USER : (currole == Role.USER ? Role.MODERATOR : Role.ADMIN))

        console.log(adminId)
        console.log(adminUser)
        console.log(curUser)
        console.log(adminrole)
        console.log(role)

        if ((role > defaultRole && !adminrole) || (adminrole && role > adminrole)) return 'Error upgradeAccessToRoom';

        await admin.firestore().collection(constName(Const.roomusers)).doc(`${_roomuser.user}_${_roomuser.room}`)
            .set(
                Object.fromEntries(roomUserToMap(RoomUser.create({
                    user: _roomuser.user,
                    room: _roomuser.room,
                    role: role,
                    created: new Date(),
                    updated: new Date(),
                })))
            );

        return { message: 'The target user has been added to the room.' };
    } else {
        throw new HttpsError('permission-denied', 'You do not have permission to kick users from this room.');
    }
});
