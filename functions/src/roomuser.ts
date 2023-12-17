import { HttpsError, onCall } from "firebase-functions/v2/https";
import { Const, Role, RoomUser, Visible, constToJSON } from "./Gen/data";
import * as admin from "firebase-admin";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import { getRoomById, updateRoomTime } from "./room";
import { toggleTopicSubsription } from "./messaging";

export const getRoomUserById = async (userId: string, roomId: string) => {
    return await admin.firestore().collection(constToJSON(Const.roomusers))
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

    let roomUser = await getRoomUserById(userId, _roomuser.room!)

    if (roomUser?.user !== userId) return 'Not enough permission';

    await admin.firestore().collection(constToJSON(Const.roomusers)).doc(`${userId}_${_roomuser.room}`)
        .update(
            RoomUser.toJSON(RoomUser.create({
                updated: new Date()
            }))!)
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

    toggleTopicSubsription(true, userId, roomId, null);

    await updateRoomTime(roomId);

    return null;
});

export const deleteRoomUser = onCall({
    enforceAppCheck: true,
}, async (request) => {
    let adminId = request.auth!.uid;
    let roomUser = RoomUser.fromJSON(request.data)

    if (!roomUser.room) {
        throw new HttpsError('invalid-argument', 'You must provide a RoomUser to remove.');
    }

    const curUser = await getRoomUserById(roomUser.user!, roomUser.room);
    const adminUser = await getRoomUserById(adminId, roomUser.room);

    if (
        (adminId === roomUser.user) ||
        (adminUser
            && (adminUser.role == Role.ADMIN || adminUser.role == Role.MODERATOR)
            && adminUser.role > curUser!.role!)
    ) {
        await admin.firestore().collection(constToJSON(Const.roomusers)).doc(roomUser.uid!).delete();

        return { message: 'The target user has been removed from the room.' };
    } else {
        throw new HttpsError('permission-denied', 'You do not have permission to kick users from this room.');
    }
});

export const upgradeAccessToRoom = onCall({
    enforceAppCheck: true,
}, async (request) => {
    const adminId = request.auth!.uid;
    const roomUser = RoomUser.fromJSON(request.data)

    if (!roomUser.room || !roomUser.user) {
        throw new HttpsError('invalid-argument', 'Invalid RoomUser.');
    }

    const curUser = await getRoomUserById(roomUser.user, roomUser.room);
    if (curUser && adminId == curUser.user && (curUser.role !== Role.INVITE)) {
        //Self Upgrade
        //ADMIN == USER
        //DENY
        console.log('Self upgrade denied')
        throw new HttpsError('permission-denied', 'Self upgrade denied');
    }

    const adminUser = adminId == curUser?.user ? null : await getRoomUserById(adminId, roomUser.room);

    const room = await getRoomById(roomUser.room);

    // console.log(roomUser)
    // console.log(adminUser)
    // console.log(curUser)

    if (room) {
        const currole = curUser?.role ?? Role.UNRECOGNIZED
        const adminrole = adminUser?.role ?? Role.UNRECOGNIZED
        const defaultRole = (room.open == Visible.OPEN ? Role.USER : Role.REQUEST)
        const upgradedRole = ((currole ?? -1) < 0) ? Role.UNRECOGNIZED : (currole == Role.REQUEST ? Role.USER : (currole == Role.USER ? Role.MODERATOR : Role.ADMIN))

        let role = Role.UNRECOGNIZED

        if (!curUser && !adminUser) {
            //Req : No User
            //DEFAULTROLE
            console.log('Request')
            role = defaultRole
        }

        if (currole == Role.INVITE && adminId == curUser?.user) {
            console.log('Accept Invite')
            role = Role.USER
        }

        if (adminUser && !curUser) {
            //Invite
            //ADMIN != USER
            //Role.Request
            console.log('Invite')
            role = Role.INVITE
        }

        if (adminUser && curUser && (adminUser.role == Role.ADMIN || adminUser.role == Role.MODERATOR)) {
            //Upgrade
            //ADMIN != USER
            //UPGRADE
            console.log('Upgrade')
            role = upgradedRole!
        }

        // console.log(`role : ${role}  currole : ${currole}  adminrole : ${adminrole}  defaultRole : ${defaultRole}  upgradedRole : ${upgradedRole}`)
        // console.log(role == Role.UNRECOGNIZED);
        // console.log((role == currole));
        // console.log((adminrole == Role.INVITE));
        // console.log((currole == Role.INVITE && adminId !== curUser?.user));
        // console.log((role > defaultRole && adminrole == Role.UNRECOGNIZED && currole !== Role.INVITE));
        // console.log((room.open == Visible.CLOSE && adminrole == Role.UNRECOGNIZED && currole != Role.INVITE));
        // console.log((adminrole != Role.UNRECOGNIZED && role > adminrole));

        if ((role == Role.UNRECOGNIZED)
            || (role == currole)
            || (adminrole == Role.INVITE)
            || (currole == Role.INVITE && adminId !== curUser?.user)
            || (role > defaultRole && adminrole == Role.UNRECOGNIZED && currole !== Role.INVITE)
            || (room.open == Visible.CLOSE && adminrole == Role.UNRECOGNIZED && currole != Role.INVITE)
            || (adminrole != Role.UNRECOGNIZED && role > adminrole)) {
            console.log('Error upgradeAccessToRoom')
            throw new HttpsError('permission-denied', 'Error upgradeAccessToRoom');
        }

        await admin.firestore().collection(constToJSON(Const.roomusers))
            .doc(`${roomUser.user}_${roomUser.room}`)
            .set(
                RoomUser.toJSON(RoomUser.create({
                    user: roomUser.user,
                    room: roomUser.room,
                    role: role,
                    created: new Date(),
                    updated: new Date(),
                }))!
            );


        toggleTopicSubsription(true, roomUser.user, roomUser.room, null);

        await updateRoomTime(roomUser.room);

        return { message: 'The target user has been added to the room.' };
    } else {
        console.log('You do not have permission to upgradeAccessToRoom.')
        throw new HttpsError('permission-denied', 'You do not have permission to upgradeAccessToRoom.');
    }
});
