/* eslint-disable */
import * as _m0 from "protobufjs/minimal";
import { Timestamp } from "./google/protobuf/timestamp";

export const protobufPackage = "user";

export enum Role {
  BLOCKED = 0,
  REQUEST = 10,
  USER = 20,
  MODERATOR = 30,
  ADMIN = 40,
  UNRECOGNIZED = -1,
}

export function roleFromJSON(object: any): Role {
  switch (object) {
    case 0:
    case "BLOCKED":
      return Role.BLOCKED;
    case 10:
    case "REQUEST":
      return Role.REQUEST;
    case 20:
    case "USER":
      return Role.USER;
    case 30:
    case "MODERATOR":
      return Role.MODERATOR;
    case 40:
    case "ADMIN":
      return Role.ADMIN;
    case -1:
    case "UNRECOGNIZED":
    default:
      return Role.UNRECOGNIZED;
  }
}

export function roleToJSON(object: Role): string {
  switch (object) {
    case Role.BLOCKED:
      return "BLOCKED";
    case Role.REQUEST:
      return "REQUEST";
    case Role.USER:
      return "USER";
    case Role.MODERATOR:
      return "MODERATOR";
    case Role.ADMIN:
      return "ADMIN";
    case Role.UNRECOGNIZED:
    default:
      return "UNRECOGNIZED";
  }
}

export enum MediaType {
  TEXT = 0,
  IMAGE = 5,
  VIDEO = 10,
  AUDIO = 15,
  PDF = 20,
  FILE = 30,
  QR = 35,
  POST = 50,
  GALLERY = 60,
  UNRECOGNIZED = -1,
}

export function mediaTypeFromJSON(object: any): MediaType {
  switch (object) {
    case 0:
    case "TEXT":
      return MediaType.TEXT;
    case 5:
    case "IMAGE":
      return MediaType.IMAGE;
    case 10:
    case "VIDEO":
      return MediaType.VIDEO;
    case 15:
    case "AUDIO":
      return MediaType.AUDIO;
    case 20:
    case "PDF":
      return MediaType.PDF;
    case 30:
    case "FILE":
      return MediaType.FILE;
    case 35:
    case "QR":
      return MediaType.QR;
    case 50:
    case "POST":
      return MediaType.POST;
    case 60:
    case "GALLERY":
      return MediaType.GALLERY;
    case -1:
    case "UNRECOGNIZED":
    default:
      return MediaType.UNRECOGNIZED;
  }
}

export function mediaTypeToJSON(object: MediaType): string {
  switch (object) {
    case MediaType.TEXT:
      return "TEXT";
    case MediaType.IMAGE:
      return "IMAGE";
    case MediaType.VIDEO:
      return "VIDEO";
    case MediaType.AUDIO:
      return "AUDIO";
    case MediaType.PDF:
      return "PDF";
    case MediaType.FILE:
      return "FILE";
    case MediaType.QR:
      return "QR";
    case MediaType.POST:
      return "POST";
    case MediaType.GALLERY:
      return "GALLERY";
    case MediaType.UNRECOGNIZED:
    default:
      return "UNRECOGNIZED";
  }
}

export enum Active {
  OFFLINE = 0,
  ONLINE = 10,
  TYPING = 20,
  UNRECOGNIZED = -1,
}

export function activeFromJSON(object: any): Active {
  switch (object) {
    case 0:
    case "OFFLINE":
      return Active.OFFLINE;
    case 10:
    case "ONLINE":
      return Active.ONLINE;
    case 20:
    case "TYPING":
      return Active.TYPING;
    case -1:
    case "UNRECOGNIZED":
    default:
      return Active.UNRECOGNIZED;
  }
}

export function activeToJSON(object: Active): string {
  switch (object) {
    case Active.OFFLINE:
      return "OFFLINE";
    case Active.ONLINE:
      return "ONLINE";
    case Active.TYPING:
      return "TYPING";
    case Active.UNRECOGNIZED:
    default:
      return "UNRECOGNIZED";
  }
}

export enum Visible {
  CLOSE = 0,
  MODERATED = 10,
  OPEN = 20,
  UNRECOGNIZED = -1,
}

export function visibleFromJSON(object: any): Visible {
  switch (object) {
    case 0:
    case "CLOSE":
      return Visible.CLOSE;
    case 10:
    case "MODERATED":
      return Visible.MODERATED;
    case 20:
    case "OPEN":
      return Visible.OPEN;
    case -1:
    case "UNRECOGNIZED":
    default:
      return Visible.UNRECOGNIZED;
  }
}

export function visibleToJSON(object: Visible): string {
  switch (object) {
    case Visible.CLOSE:
      return "CLOSE";
    case Visible.MODERATED:
      return "MODERATED";
    case Visible.OPEN:
      return "OPEN";
    case Visible.UNRECOGNIZED:
    default:
      return "UNRECOGNIZED";
  }
}

export enum Const {
  users = 0,
  rooms = 10,
  tweets = 20,
  roomusers = 30,
  uid = 100,
  nick = 110,
  displayName = 150,
  email = 200,
  phoneNumber = 250,
  photoURL = 300,
  fcmToken = 350,
  status = 400,
  created = 600,
  open = 700,
  members = 800,
  tweet_count = 900,
  description = 1000,
  gallery = 1100,
  UNRECOGNIZED = -1,
}

export function constFromJSON(object: any): Const {
  switch (object) {
    case 0:
    case "users":
      return Const.users;
    case 10:
    case "rooms":
      return Const.rooms;
    case 20:
    case "tweets":
      return Const.tweets;
    case 30:
    case "roomusers":
      return Const.roomusers;
    case 100:
    case "uid":
      return Const.uid;
    case 110:
    case "nick":
      return Const.nick;
    case 150:
    case "displayName":
      return Const.displayName;
    case 200:
    case "email":
      return Const.email;
    case 250:
    case "phoneNumber":
      return Const.phoneNumber;
    case 300:
    case "photoURL":
      return Const.photoURL;
    case 350:
    case "fcmToken":
      return Const.fcmToken;
    case 400:
    case "status":
      return Const.status;
    case 600:
    case "created":
      return Const.created;
    case 700:
    case "open":
      return Const.open;
    case 800:
    case "members":
      return Const.members;
    case 900:
    case "tweet_count":
      return Const.tweet_count;
    case 1000:
    case "description":
      return Const.description;
    case 1100:
    case "gallery":
      return Const.gallery;
    case -1:
    case "UNRECOGNIZED":
    default:
      return Const.UNRECOGNIZED;
  }
}

export function constToJSON(object: Const): string {
  switch (object) {
    case Const.users:
      return "users";
    case Const.rooms:
      return "rooms";
    case Const.tweets:
      return "tweets";
    case Const.roomusers:
      return "roomusers";
    case Const.uid:
      return "uid";
    case Const.nick:
      return "nick";
    case Const.displayName:
      return "displayName";
    case Const.email:
      return "email";
    case Const.phoneNumber:
      return "phoneNumber";
    case Const.photoURL:
      return "photoURL";
    case Const.fcmToken:
      return "fcmToken";
    case Const.status:
      return "status";
    case Const.created:
      return "created";
    case Const.open:
      return "open";
    case Const.members:
      return "members";
    case Const.tweet_count:
      return "tweet_count";
    case Const.description:
      return "description";
    case Const.gallery:
      return "gallery";
    case Const.UNRECOGNIZED:
    default:
      return "UNRECOGNIZED";
  }
}

export interface User {
  uid: string;
  displayName: string;
  nick: string;
  email: string;
  phoneNumber: string;
  photoURL: string;
  status: Active;
  friends: string[];
  roomRequest: string[];
  created: Date | undefined;
  open: Visible;
}

export interface UserClaims {
  fcmToken: string;
}

export interface RoomUser {
  uid: string;
  user: string;
  room: string;
  role: Role;
  created: Date | undefined;
}

export interface Room {
  uid: string;
  nick: string;
  displayName: string;
  photoURL: string;
  description: string;
  created: Date | undefined;
  open: Visible;
}

export interface Tweet {
  uid: string;
  user: string;
  room: string;
  path: string;
  created: Date | undefined;
  mediaType: MediaType;
  text: string;
  link: string;
  gallery: ImageMetadata[];
}

export interface ImageMetadata {
  url: string;
  path: string;
  localUrl: string;
  width: number;
  height: number;
  /** string blurhash = 60; */
  caption: string;
}

function createBaseUser(): User {
  return {
    uid: "",
    displayName: "",
    nick: "",
    email: "",
    phoneNumber: "",
    photoURL: "",
    status: 0,
    friends: [],
    roomRequest: [],
    created: undefined,
    open: 0,
  };
}

export const User = {
  encode(message: User, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.uid !== "") {
      writer.uint32(802).string(message.uid);
    }
    if (message.displayName !== "") {
      writer.uint32(1602).string(message.displayName);
    }
    if (message.nick !== "") {
      writer.uint32(2002).string(message.nick);
    }
    if (message.email !== "") {
      writer.uint32(2402).string(message.email);
    }
    if (message.phoneNumber !== "") {
      writer.uint32(3202).string(message.phoneNumber);
    }
    if (message.photoURL !== "") {
      writer.uint32(4002).string(message.photoURL);
    }
    if (message.status !== 0) {
      writer.uint32(4800).int32(message.status);
    }
    for (const v of message.friends) {
      writer.uint32(5602).string(v!);
    }
    for (const v of message.roomRequest) {
      writer.uint32(6402).string(v!);
    }
    if (message.created !== undefined) {
      Timestamp.encode(toTimestamp(message.created), writer.uint32(7202).fork()).ldelim();
    }
    if (message.open !== 0) {
      writer.uint32(8000).int32(message.open);
    }
    return writer;
  },

  decode(input: _m0.Reader | Uint8Array, length?: number): User {
    const reader = input instanceof _m0.Reader ? input : _m0.Reader.create(input);
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = createBaseUser();
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 100:
          if (tag !== 802) {
            break;
          }

          message.uid = reader.string();
          continue;
        case 200:
          if (tag !== 1602) {
            break;
          }

          message.displayName = reader.string();
          continue;
        case 250:
          if (tag !== 2002) {
            break;
          }

          message.nick = reader.string();
          continue;
        case 300:
          if (tag !== 2402) {
            break;
          }

          message.email = reader.string();
          continue;
        case 400:
          if (tag !== 3202) {
            break;
          }

          message.phoneNumber = reader.string();
          continue;
        case 500:
          if (tag !== 4002) {
            break;
          }

          message.photoURL = reader.string();
          continue;
        case 600:
          if (tag !== 4800) {
            break;
          }

          message.status = reader.int32() as any;
          continue;
        case 700:
          if (tag !== 5602) {
            break;
          }

          message.friends.push(reader.string());
          continue;
        case 800:
          if (tag !== 6402) {
            break;
          }

          message.roomRequest.push(reader.string());
          continue;
        case 900:
          if (tag !== 7202) {
            break;
          }

          message.created = fromTimestamp(Timestamp.decode(reader, reader.uint32()));
          continue;
        case 1000:
          if (tag !== 8000) {
            break;
          }

          message.open = reader.int32() as any;
          continue;
      }
      if ((tag & 7) === 4 || tag === 0) {
        break;
      }
      reader.skipType(tag & 7);
    }
    return message;
  },

  fromJSON(object: any): User {
    return {
      uid: isSet(object.uid) ? globalThis.String(object.uid) : "",
      displayName: isSet(object.displayName) ? globalThis.String(object.displayName) : "",
      nick: isSet(object.nick) ? globalThis.String(object.nick) : "",
      email: isSet(object.email) ? globalThis.String(object.email) : "",
      phoneNumber: isSet(object.phoneNumber) ? globalThis.String(object.phoneNumber) : "",
      photoURL: isSet(object.photoURL) ? globalThis.String(object.photoURL) : "",
      status: isSet(object.status) ? activeFromJSON(object.status) : 0,
      friends: globalThis.Array.isArray(object?.friends) ? object.friends.map((e: any) => globalThis.String(e)) : [],
      roomRequest: globalThis.Array.isArray(object?.roomRequest)
        ? object.roomRequest.map((e: any) => globalThis.String(e))
        : [],
      created: isSet(object.created) ? fromJsonTimestamp(object.created) : undefined,
      open: isSet(object.open) ? visibleFromJSON(object.open) : 0,
    };
  },

  toJSON(message: User): unknown {
    const obj: any = {};
    if (message.uid !== "") {
      obj.uid = message.uid;
    }
    if (message.displayName !== "") {
      obj.displayName = message.displayName;
    }
    if (message.nick !== "") {
      obj.nick = message.nick;
    }
    if (message.email !== "") {
      obj.email = message.email;
    }
    if (message.phoneNumber !== "") {
      obj.phoneNumber = message.phoneNumber;
    }
    if (message.photoURL !== "") {
      obj.photoURL = message.photoURL;
    }
    if (message.status !== 0) {
      obj.status = activeToJSON(message.status);
    }
    if (message.friends?.length) {
      obj.friends = message.friends;
    }
    if (message.roomRequest?.length) {
      obj.roomRequest = message.roomRequest;
    }
    if (message.created !== undefined) {
      obj.created = message.created.toISOString();
    }
    if (message.open !== 0) {
      obj.open = visibleToJSON(message.open);
    }
    return obj;
  },

  create<I extends Exact<DeepPartial<User>, I>>(base?: I): User {
    return User.fromPartial(base ?? ({} as any));
  },
  fromPartial<I extends Exact<DeepPartial<User>, I>>(object: I): User {
    const message = createBaseUser();
    message.uid = object.uid ?? "";
    message.displayName = object.displayName ?? "";
    message.nick = object.nick ?? "";
    message.email = object.email ?? "";
    message.phoneNumber = object.phoneNumber ?? "";
    message.photoURL = object.photoURL ?? "";
    message.status = object.status ?? 0;
    message.friends = object.friends?.map((e) => e) || [];
    message.roomRequest = object.roomRequest?.map((e) => e) || [];
    message.created = object.created ?? undefined;
    message.open = object.open ?? 0;
    return message;
  },
};

function createBaseUserClaims(): UserClaims {
  return { fcmToken: "" };
}

export const UserClaims = {
  encode(message: UserClaims, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.fcmToken !== "") {
      writer.uint32(802).string(message.fcmToken);
    }
    return writer;
  },

  decode(input: _m0.Reader | Uint8Array, length?: number): UserClaims {
    const reader = input instanceof _m0.Reader ? input : _m0.Reader.create(input);
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = createBaseUserClaims();
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 100:
          if (tag !== 802) {
            break;
          }

          message.fcmToken = reader.string();
          continue;
      }
      if ((tag & 7) === 4 || tag === 0) {
        break;
      }
      reader.skipType(tag & 7);
    }
    return message;
  },

  fromJSON(object: any): UserClaims {
    return { fcmToken: isSet(object.fcmToken) ? globalThis.String(object.fcmToken) : "" };
  },

  toJSON(message: UserClaims): unknown {
    const obj: any = {};
    if (message.fcmToken !== "") {
      obj.fcmToken = message.fcmToken;
    }
    return obj;
  },

  create<I extends Exact<DeepPartial<UserClaims>, I>>(base?: I): UserClaims {
    return UserClaims.fromPartial(base ?? ({} as any));
  },
  fromPartial<I extends Exact<DeepPartial<UserClaims>, I>>(object: I): UserClaims {
    const message = createBaseUserClaims();
    message.fcmToken = object.fcmToken ?? "";
    return message;
  },
};

function createBaseRoomUser(): RoomUser {
  return { uid: "", user: "", room: "", role: 0, created: undefined };
}

export const RoomUser = {
  encode(message: RoomUser, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.uid !== "") {
      writer.uint32(10).string(message.uid);
    }
    if (message.user !== "") {
      writer.uint32(18).string(message.user);
    }
    if (message.room !== "") {
      writer.uint32(26).string(message.room);
    }
    if (message.role !== 0) {
      writer.uint32(80).int32(message.role);
    }
    if (message.created !== undefined) {
      Timestamp.encode(toTimestamp(message.created), writer.uint32(162).fork()).ldelim();
    }
    return writer;
  },

  decode(input: _m0.Reader | Uint8Array, length?: number): RoomUser {
    const reader = input instanceof _m0.Reader ? input : _m0.Reader.create(input);
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = createBaseRoomUser();
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          if (tag !== 10) {
            break;
          }

          message.uid = reader.string();
          continue;
        case 2:
          if (tag !== 18) {
            break;
          }

          message.user = reader.string();
          continue;
        case 3:
          if (tag !== 26) {
            break;
          }

          message.room = reader.string();
          continue;
        case 10:
          if (tag !== 80) {
            break;
          }

          message.role = reader.int32() as any;
          continue;
        case 20:
          if (tag !== 162) {
            break;
          }

          message.created = fromTimestamp(Timestamp.decode(reader, reader.uint32()));
          continue;
      }
      if ((tag & 7) === 4 || tag === 0) {
        break;
      }
      reader.skipType(tag & 7);
    }
    return message;
  },

  fromJSON(object: any): RoomUser {
    return {
      uid: isSet(object.uid) ? globalThis.String(object.uid) : "",
      user: isSet(object.user) ? globalThis.String(object.user) : "",
      room: isSet(object.room) ? globalThis.String(object.room) : "",
      role: isSet(object.role) ? roleFromJSON(object.role) : 0,
      created: isSet(object.created) ? fromJsonTimestamp(object.created) : undefined,
    };
  },

  toJSON(message: RoomUser): unknown {
    const obj: any = {};
    if (message.uid !== "") {
      obj.uid = message.uid;
    }
    if (message.user !== "") {
      obj.user = message.user;
    }
    if (message.room !== "") {
      obj.room = message.room;
    }
    if (message.role !== 0) {
      obj.role = roleToJSON(message.role);
    }
    if (message.created !== undefined) {
      obj.created = message.created.toISOString();
    }
    return obj;
  },

  create<I extends Exact<DeepPartial<RoomUser>, I>>(base?: I): RoomUser {
    return RoomUser.fromPartial(base ?? ({} as any));
  },
  fromPartial<I extends Exact<DeepPartial<RoomUser>, I>>(object: I): RoomUser {
    const message = createBaseRoomUser();
    message.uid = object.uid ?? "";
    message.user = object.user ?? "";
    message.room = object.room ?? "";
    message.role = object.role ?? 0;
    message.created = object.created ?? undefined;
    return message;
  },
};

function createBaseRoom(): Room {
  return { uid: "", nick: "", displayName: "", photoURL: "", description: "", created: undefined, open: 0 };
}

export const Room = {
  encode(message: Room, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.uid !== "") {
      writer.uint32(10).string(message.uid);
    }
    if (message.nick !== "") {
      writer.uint32(18).string(message.nick);
    }
    if (message.displayName !== "") {
      writer.uint32(82).string(message.displayName);
    }
    if (message.photoURL !== "") {
      writer.uint32(162).string(message.photoURL);
    }
    if (message.description !== "") {
      writer.uint32(242).string(message.description);
    }
    if (message.created !== undefined) {
      Timestamp.encode(toTimestamp(message.created), writer.uint32(322).fork()).ldelim();
    }
    if (message.open !== 0) {
      writer.uint32(400).int32(message.open);
    }
    return writer;
  },

  decode(input: _m0.Reader | Uint8Array, length?: number): Room {
    const reader = input instanceof _m0.Reader ? input : _m0.Reader.create(input);
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = createBaseRoom();
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          if (tag !== 10) {
            break;
          }

          message.uid = reader.string();
          continue;
        case 2:
          if (tag !== 18) {
            break;
          }

          message.nick = reader.string();
          continue;
        case 10:
          if (tag !== 82) {
            break;
          }

          message.displayName = reader.string();
          continue;
        case 20:
          if (tag !== 162) {
            break;
          }

          message.photoURL = reader.string();
          continue;
        case 30:
          if (tag !== 242) {
            break;
          }

          message.description = reader.string();
          continue;
        case 40:
          if (tag !== 322) {
            break;
          }

          message.created = fromTimestamp(Timestamp.decode(reader, reader.uint32()));
          continue;
        case 50:
          if (tag !== 400) {
            break;
          }

          message.open = reader.int32() as any;
          continue;
      }
      if ((tag & 7) === 4 || tag === 0) {
        break;
      }
      reader.skipType(tag & 7);
    }
    return message;
  },

  fromJSON(object: any): Room {
    return {
      uid: isSet(object.uid) ? globalThis.String(object.uid) : "",
      nick: isSet(object.nick) ? globalThis.String(object.nick) : "",
      displayName: isSet(object.displayName) ? globalThis.String(object.displayName) : "",
      photoURL: isSet(object.photoURL) ? globalThis.String(object.photoURL) : "",
      description: isSet(object.description) ? globalThis.String(object.description) : "",
      created: isSet(object.created) ? fromJsonTimestamp(object.created) : undefined,
      open: isSet(object.open) ? visibleFromJSON(object.open) : 0,
    };
  },

  toJSON(message: Room): unknown {
    const obj: any = {};
    if (message.uid !== "") {
      obj.uid = message.uid;
    }
    if (message.nick !== "") {
      obj.nick = message.nick;
    }
    if (message.displayName !== "") {
      obj.displayName = message.displayName;
    }
    if (message.photoURL !== "") {
      obj.photoURL = message.photoURL;
    }
    if (message.description !== "") {
      obj.description = message.description;
    }
    if (message.created !== undefined) {
      obj.created = message.created.toISOString();
    }
    if (message.open !== 0) {
      obj.open = visibleToJSON(message.open);
    }
    return obj;
  },

  create<I extends Exact<DeepPartial<Room>, I>>(base?: I): Room {
    return Room.fromPartial(base ?? ({} as any));
  },
  fromPartial<I extends Exact<DeepPartial<Room>, I>>(object: I): Room {
    const message = createBaseRoom();
    message.uid = object.uid ?? "";
    message.nick = object.nick ?? "";
    message.displayName = object.displayName ?? "";
    message.photoURL = object.photoURL ?? "";
    message.description = object.description ?? "";
    message.created = object.created ?? undefined;
    message.open = object.open ?? 0;
    return message;
  },
};

function createBaseTweet(): Tweet {
  return { uid: "", user: "", room: "", path: "", created: undefined, mediaType: 0, text: "", link: "", gallery: [] };
}

export const Tweet = {
  encode(message: Tweet, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.uid !== "") {
      writer.uint32(10).string(message.uid);
    }
    if (message.user !== "") {
      writer.uint32(82).string(message.user);
    }
    if (message.room !== "") {
      writer.uint32(162).string(message.room);
    }
    if (message.path !== "") {
      writer.uint32(242).string(message.path);
    }
    if (message.created !== undefined) {
      Timestamp.encode(toTimestamp(message.created), writer.uint32(322).fork()).ldelim();
    }
    if (message.mediaType !== 0) {
      writer.uint32(400).int32(message.mediaType);
    }
    if (message.text !== "") {
      writer.uint32(482).string(message.text);
    }
    if (message.link !== "") {
      writer.uint32(562).string(message.link);
    }
    for (const v of message.gallery) {
      ImageMetadata.encode(v!, writer.uint32(642).fork()).ldelim();
    }
    return writer;
  },

  decode(input: _m0.Reader | Uint8Array, length?: number): Tweet {
    const reader = input instanceof _m0.Reader ? input : _m0.Reader.create(input);
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = createBaseTweet();
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          if (tag !== 10) {
            break;
          }

          message.uid = reader.string();
          continue;
        case 10:
          if (tag !== 82) {
            break;
          }

          message.user = reader.string();
          continue;
        case 20:
          if (tag !== 162) {
            break;
          }

          message.room = reader.string();
          continue;
        case 30:
          if (tag !== 242) {
            break;
          }

          message.path = reader.string();
          continue;
        case 40:
          if (tag !== 322) {
            break;
          }

          message.created = fromTimestamp(Timestamp.decode(reader, reader.uint32()));
          continue;
        case 50:
          if (tag !== 400) {
            break;
          }

          message.mediaType = reader.int32() as any;
          continue;
        case 60:
          if (tag !== 482) {
            break;
          }

          message.text = reader.string();
          continue;
        case 70:
          if (tag !== 562) {
            break;
          }

          message.link = reader.string();
          continue;
        case 80:
          if (tag !== 642) {
            break;
          }

          message.gallery.push(ImageMetadata.decode(reader, reader.uint32()));
          continue;
      }
      if ((tag & 7) === 4 || tag === 0) {
        break;
      }
      reader.skipType(tag & 7);
    }
    return message;
  },

  fromJSON(object: any): Tweet {
    return {
      uid: isSet(object.uid) ? globalThis.String(object.uid) : "",
      user: isSet(object.user) ? globalThis.String(object.user) : "",
      room: isSet(object.room) ? globalThis.String(object.room) : "",
      path: isSet(object.path) ? globalThis.String(object.path) : "",
      created: isSet(object.created) ? fromJsonTimestamp(object.created) : undefined,
      mediaType: isSet(object.mediaType) ? mediaTypeFromJSON(object.mediaType) : 0,
      text: isSet(object.text) ? globalThis.String(object.text) : "",
      link: isSet(object.link) ? globalThis.String(object.link) : "",
      gallery: globalThis.Array.isArray(object?.gallery)
        ? object.gallery.map((e: any) => ImageMetadata.fromJSON(e))
        : [],
    };
  },

  toJSON(message: Tweet): unknown {
    const obj: any = {};
    if (message.uid !== "") {
      obj.uid = message.uid;
    }
    if (message.user !== "") {
      obj.user = message.user;
    }
    if (message.room !== "") {
      obj.room = message.room;
    }
    if (message.path !== "") {
      obj.path = message.path;
    }
    if (message.created !== undefined) {
      obj.created = message.created.toISOString();
    }
    if (message.mediaType !== 0) {
      obj.mediaType = mediaTypeToJSON(message.mediaType);
    }
    if (message.text !== "") {
      obj.text = message.text;
    }
    if (message.link !== "") {
      obj.link = message.link;
    }
    if (message.gallery?.length) {
      obj.gallery = message.gallery.map((e) => ImageMetadata.toJSON(e));
    }
    return obj;
  },

  create<I extends Exact<DeepPartial<Tweet>, I>>(base?: I): Tweet {
    return Tweet.fromPartial(base ?? ({} as any));
  },
  fromPartial<I extends Exact<DeepPartial<Tweet>, I>>(object: I): Tweet {
    const message = createBaseTweet();
    message.uid = object.uid ?? "";
    message.user = object.user ?? "";
    message.room = object.room ?? "";
    message.path = object.path ?? "";
    message.created = object.created ?? undefined;
    message.mediaType = object.mediaType ?? 0;
    message.text = object.text ?? "";
    message.link = object.link ?? "";
    message.gallery = object.gallery?.map((e) => ImageMetadata.fromPartial(e)) || [];
    return message;
  },
};

function createBaseImageMetadata(): ImageMetadata {
  return { url: "", path: "", localUrl: "", width: 0, height: 0, caption: "" };
}

export const ImageMetadata = {
  encode(message: ImageMetadata, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.url !== "") {
      writer.uint32(10).string(message.url);
    }
    if (message.path !== "") {
      writer.uint32(82).string(message.path);
    }
    if (message.localUrl !== "") {
      writer.uint32(162).string(message.localUrl);
    }
    if (message.width !== 0) {
      writer.uint32(240).int32(message.width);
    }
    if (message.height !== 0) {
      writer.uint32(320).int32(message.height);
    }
    if (message.caption !== "") {
      writer.uint32(402).string(message.caption);
    }
    return writer;
  },

  decode(input: _m0.Reader | Uint8Array, length?: number): ImageMetadata {
    const reader = input instanceof _m0.Reader ? input : _m0.Reader.create(input);
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = createBaseImageMetadata();
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          if (tag !== 10) {
            break;
          }

          message.url = reader.string();
          continue;
        case 10:
          if (tag !== 82) {
            break;
          }

          message.path = reader.string();
          continue;
        case 20:
          if (tag !== 162) {
            break;
          }

          message.localUrl = reader.string();
          continue;
        case 30:
          if (tag !== 240) {
            break;
          }

          message.width = reader.int32();
          continue;
        case 40:
          if (tag !== 320) {
            break;
          }

          message.height = reader.int32();
          continue;
        case 50:
          if (tag !== 402) {
            break;
          }

          message.caption = reader.string();
          continue;
      }
      if ((tag & 7) === 4 || tag === 0) {
        break;
      }
      reader.skipType(tag & 7);
    }
    return message;
  },

  fromJSON(object: any): ImageMetadata {
    return {
      url: isSet(object.url) ? globalThis.String(object.url) : "",
      path: isSet(object.path) ? globalThis.String(object.path) : "",
      localUrl: isSet(object.localUrl) ? globalThis.String(object.localUrl) : "",
      width: isSet(object.width) ? globalThis.Number(object.width) : 0,
      height: isSet(object.height) ? globalThis.Number(object.height) : 0,
      caption: isSet(object.caption) ? globalThis.String(object.caption) : "",
    };
  },

  toJSON(message: ImageMetadata): unknown {
    const obj: any = {};
    if (message.url !== "") {
      obj.url = message.url;
    }
    if (message.path !== "") {
      obj.path = message.path;
    }
    if (message.localUrl !== "") {
      obj.localUrl = message.localUrl;
    }
    if (message.width !== 0) {
      obj.width = Math.round(message.width);
    }
    if (message.height !== 0) {
      obj.height = Math.round(message.height);
    }
    if (message.caption !== "") {
      obj.caption = message.caption;
    }
    return obj;
  },

  create<I extends Exact<DeepPartial<ImageMetadata>, I>>(base?: I): ImageMetadata {
    return ImageMetadata.fromPartial(base ?? ({} as any));
  },
  fromPartial<I extends Exact<DeepPartial<ImageMetadata>, I>>(object: I): ImageMetadata {
    const message = createBaseImageMetadata();
    message.url = object.url ?? "";
    message.path = object.path ?? "";
    message.localUrl = object.localUrl ?? "";
    message.width = object.width ?? 0;
    message.height = object.height ?? 0;
    message.caption = object.caption ?? "";
    return message;
  },
};

type Builtin = Date | Function | Uint8Array | string | number | boolean | undefined;

export type DeepPartial<T> = T extends Builtin ? T
  : T extends globalThis.Array<infer U> ? globalThis.Array<DeepPartial<U>>
  : T extends ReadonlyArray<infer U> ? ReadonlyArray<DeepPartial<U>>
  : T extends {} ? { [K in keyof T]?: DeepPartial<T[K]> }
  : Partial<T>;

type KeysOfUnion<T> = T extends T ? keyof T : never;
export type Exact<P, I extends P> = P extends Builtin ? P
  : P & { [K in keyof P]: Exact<P[K], I[K]> } & { [K in Exclude<keyof I, KeysOfUnion<P>>]: never };

function toTimestamp(date: Date): Timestamp {
  const seconds = date.getTime() / 1_000;
  const nanos = (date.getTime() % 1_000) * 1_000_000;
  return { seconds, nanos };
}

function fromTimestamp(t: Timestamp): Date {
  let millis = (t.seconds || 0) * 1_000;
  millis += (t.nanos || 0) / 1_000_000;
  return new globalThis.Date(millis);
}

function fromJsonTimestamp(o: any): Date {
  if (o instanceof globalThis.Date) {
    return o;
  } else if (typeof o === "string") {
    return new globalThis.Date(o);
  } else {
    return fromTimestamp(Timestamp.fromJSON(o));
  }
}

function isSet(value: any): boolean {
  return value !== null && value !== undefined;
}
