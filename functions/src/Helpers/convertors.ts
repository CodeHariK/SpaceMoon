import { Room, RoomUser, User } from "../Gen/data";
import { toMap } from "./map";

export function roomUserToMap(roomuser: RoomUser) {
    return toMap(RoomUser.toJSON(RoomUser.create(roomuser))!);
}

export function roomUserToJson(roomUser: RoomUser) {
    return RoomUser.toJSON(roomUser)! as Map<String, any>;
}

//-----------
export function roomToMap(room: Room) {
    return toMap(Room.toJSON(room)!);
}

export function roomToJson(room: Room) {
    return Room.toJSON(room)! as Map<String, any>;
}

//-----------
export function userToMap(user: User) {
    return toMap(userToJson(user)!);
}

export function userToJson(user: User) {
    return User.toJSON(user)! as Map<String, any>;
}

export function userObj(user: User) {
    return Object.fromEntries(userToMap(user));
}
