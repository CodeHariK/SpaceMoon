import { onCall } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { Const, Role, Room, RoomUser } from "./Gen/data";
import { constName } from "./Helpers/const";
import { FieldValue } from "firebase-admin/firestore";
import { checkUserExists } from "./users";

export const callCreateRoom = onCall(async (request): Promise<string | undefined> => {
    let currentUID: string = request.auth!.uid;

    const { r, users } = request.data;

    let room = Room.fromJSON(r);

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
            uid: e,
            role: (e == currentUID) ? Role.ADMIN : Role.USER,
            created: new Date(),
        });
    });

    room.created = new Date()
    room.members = members

    if (currentUID != null) {
        let v = await admin.firestore().collection(constName(Const.rooms)).add(toMap(room),);

        members.forEach((e) => {
            addRoomIdToUser(e.uid, v.id, true);
        });

        members.forEach(async (e) => {
            await admin.firestore().collection(constName(Const.rooms))
                .doc(v.id)
                .collection('submembers')
                .doc(e.uid)
                .set(
                    RoomUser.toJSON(RoomUser.create({
                        created: e.created,
                        role: e.role,
                    })) as Map<string, any>
                );
        });

        return v.id;
    }
    return undefined;
});

export const updateRoomInfo = onCall(async (request): Promise<string> => {
    let currentUID: string = request.auth!.uid;

    const { r } = request.data;

    let room = Room.fromJSON(r)

    try {
        let roomUser = await getRoomUserById(currentUID, room.uid)
        if (roomUser !== undefined && roomUser.role == Role.ADMIN) {
            await admin.firestore().collection(constName(Const.rooms)).doc(room.uid).set(
                toMap(Room.create({
                    description: room.description,
                    displayName: room.displayName,
                    nick: room.nick,
                    photoURL: room.photoURL,
                    open: room.open,
                })));
        }
    }
    catch (e) {
        console.log(e)

        return (e as string);
    }
    return 'Error';
});

const addRoomIdToUser = async (userId: string, roomId: string, add: boolean) => {
    let roomConst = constName(Const.rooms)
    let h: any = {}
    h[roomConst] = (add) ? FieldValue.arrayUnion(...[roomId]) : FieldValue.arrayRemove(...[roomId])
    await admin.firestore().collection(constName(Const.users)).doc(userId).update(
        h
    );
}

export const getRoomUserById = async (userId: string, roomId: string) => {
    const r = (await admin.firestore().collection(constName(Const.rooms)).doc(roomId).get()).data();
    let room = Room.fromJSON(r);
    return room.members.find((v) => v.uid == userId);
}

// Helper Functions ___________________________________________

export function roomToMap(obj: any) {
    return Room.toJSON(Room.create(obj)) as Map<string, any>;
}

export function toMap(room: Room) {
    return Room.toJSON(room) as Map<string, any>;
}
