import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { Const, Role, Room, RoomUser } from "./Gen/data";
import { constName } from "./Helpers/const";
import { checkUserExists } from "./users";

export const callCreateRoom = onCall(async (request): Promise<string | undefined> => {
    let currentUID: string = request.auth!.uid;

    const { room, users } = request.data;

    let _room = Room.fromJSON(room);

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
            role: (e == currentUID) ? Role.ADMIN : Role.USER,
            created: new Date(),
        });
    });

    _room.created = new Date()

    if (currentUID != null) {
        let v = await admin.firestore().collection(constName(Const.rooms)).add(toMap(_room),);


        members.forEach(async (e) => {
            e.room = v.id;
            await admin.firestore().collection(constName(Const.roomusers)).add(
                RoomUser.toJSON(e) as Map<string, any>
            );
        });

        return v.id;
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
            .set(RoomUser.toJSON(RoomUser.create({
                user: _roomuser.user,
                room: _roomuser.room,
                role: Role.USER,
                created: new Date(),
            })) as Map<string, any>,
                { merge: true }
            );

        return { message: 'The target user has been kicked from the room.' };
    } else {
        throw new HttpsError('permission-denied', 'You do not have permission to kick users from this room.');
    }
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
        return { message: 'The target user has been kicked from the room.' };
    } else {
        throw new HttpsError('permission-denied', 'You do not have permission to kick users from this room.');
    }
});

export const updateRoomInfo = onCall(async (request): Promise<string> => {
    let userId: string = request.auth!.uid;

    const { r } = request.data;

    let room = Room.fromJSON(r)

    try {
        let roomUser = await getRoomUserById(userId, room.uid)
        if (roomUser && roomUser.role == Role.ADMIN) {
            await admin.firestore().collection(constName(Const.rooms)).doc(room.uid).set(
                toMap(Room.create({
                    description: room.description,
                    displayName: room.displayName,
                    nick: room.nick,
                    photoURL: room.photoURL,
                    open: room.open,
                })));
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

export function roomToMap(obj: any) {
    return Room.toJSON(Room.create(obj)) as Map<string, any>;
}

export function roomUserToMap(obj: any) {
    return RoomUser.toJSON(RoomUser.create(obj)) as Map<string, any>;
}

export function toMap(room: Room) {
    return Room.toJSON(room) as Map<string, any>;
}
