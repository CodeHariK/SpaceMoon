/* eslint-disable */
import * as _m0 from "protobufjs/minimal";
import { Timestamp } from "./google/protobuf/timestamp";

export const protobufPackage = "user";

export enum Role {
  REQUEST = 0,
  USER = 10,
  INVITE = 20,
  MODERATOR = 30,
  ADMIN = 40,
  UNRECOGNIZED = -1,
}

export function roleFromJSON(object: any): Role {
  switch (object) {
    case 0:
    case "REQUEST":
      return Role.REQUEST;
    case 10:
    case "USER":
      return Role.USER;
    case 20:
    case "INVITE":
      return Role.INVITE;
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
    case Role.REQUEST:
      return "REQUEST";
    case Role.USER:
      return "USER";
    case Role.INVITE:
      return "INVITE";
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
  FILE = 10,
  QR = 20,
  POST = 30,
  GALLERY = 40,
  UNRECOGNIZED = -1,
}

export function mediaTypeFromJSON(object: any): MediaType {
  switch (object) {
    case 0:
    case "TEXT":
      return MediaType.TEXT;
    case 10:
    case "FILE":
      return MediaType.FILE;
    case 20:
    case "QR":
      return MediaType.QR;
    case 30:
    case "POST":
      return MediaType.POST;
    case 40:
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
  uid = 40,
  nick = 45,
  role = 50,
  user = 55,
  room = 60,
  displayName = 65,
  email = 70,
  phoneNumber = 80,
  photoURL = 90,
  fcmToken = 100,
  status = 110,
  created = 120,
  updated = 130,
  timestamp = 140,
  open = 150,
  famous = 155,
  members = 160,
  tweet_count = 170,
  description = 180,
  gallery = 190,
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
    case 40:
    case "uid":
      return Const.uid;
    case 45:
    case "nick":
      return Const.nick;
    case 50:
    case "role":
      return Const.role;
    case 55:
    case "user":
      return Const.user;
    case 60:
    case "room":
      return Const.room;
    case 65:
    case "displayName":
      return Const.displayName;
    case 70:
    case "email":
      return Const.email;
    case 80:
    case "phoneNumber":
      return Const.phoneNumber;
    case 90:
    case "photoURL":
      return Const.photoURL;
    case 100:
    case "fcmToken":
      return Const.fcmToken;
    case 110:
    case "status":
      return Const.status;
    case 120:
    case "created":
      return Const.created;
    case 130:
    case "updated":
      return Const.updated;
    case 140:
    case "timestamp":
      return Const.timestamp;
    case 150:
    case "open":
      return Const.open;
    case 155:
    case "famous":
      return Const.famous;
    case 160:
    case "members":
      return Const.members;
    case 170:
    case "tweet_count":
      return Const.tweet_count;
    case 180:
    case "description":
      return Const.description;
    case 190:
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
    case Const.role:
      return "role";
    case Const.user:
      return "user";
    case Const.room:
      return "room";
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
    case Const.updated:
      return "updated";
    case Const.timestamp:
      return "timestamp";
    case Const.open:
      return "open";
    case Const.famous:
      return "famous";
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
  uid?: string | undefined;
  displayName?: string | undefined;
  nick?: string | undefined;
  email?: string | undefined;
  phoneNumber?: string | undefined;
  photoURL?: string | undefined;
  status?: Active | undefined;
  friends: string[];
  created?: Date | undefined;
  updated?: Date | undefined;
  open?: Visible | undefined;
  admin?: boolean | undefined;
}

export interface Messaging {
  fcmToken?: string | undefined;
  timestamp?: Date | undefined;
}

export interface RoomUser {
  uid?: string | undefined;
  user?: string | undefined;
  room?: string | undefined;
  role?: Role | undefined;
  created?: Date | undefined;
  updated?: Date | undefined;
  subscribed?: boolean | undefined;
}

export interface Room {
  uid?: string | undefined;
  nick?: string | undefined;
  displayName?: string | undefined;
  open?: Visible | undefined;
  photoURL?: string | undefined;
  description?: string | undefined;
  created?: Date | undefined;
  updated?: Date | undefined;
  famous?: boolean | undefined;
}

export interface Tweet {
  uid?: string | undefined;
  user?: string | undefined;
  room?: string | undefined;
  path?: string | undefined;
  created?: Date | undefined;
  mediaType?: MediaType | undefined;
  text?: string | undefined;
  link?: string | undefined;
  gallery: ImageMetadata[];
}

export interface ImageMetadata {
  unsplashurl?: string | undefined;
  path?: string | undefined;
  localUrl?: string | undefined;
  width?: number | undefined;
  height?: number | undefined;
  caption?: string | undefined;
  type?: string | undefined;
}

function createBaseUser(): User {
  return {
    uid: undefined,
    displayName: undefined,
    nick: undefined,
    email: undefined,
    phoneNumber: undefined,
    photoURL: undefined,
    status: undefined,
    friends: [],
    created: undefined,
    updated: undefined,
    open: undefined,
    admin: undefined,
  };
}

export const User = {
  encode(message: User, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.uid !== undefined) {
      writer.uint32(82).string(message.uid);
    }
    if (message.displayName !== undefined) {
      writer.uint32(162).string(message.displayName);
    }
    if (message.nick !== undefined) {
      writer.uint32(242).string(message.nick);
    }
    if (message.email !== undefined) {
      writer.uint32(322).string(message.email);
    }
    if (message.phoneNumber !== undefined) {
      writer.uint32(402).string(message.phoneNumber);
    }
    if (message.photoURL !== undefined) {
      writer.uint32(482).string(message.photoURL);
    }
    if (message.status !== undefined) {
      writer.uint32(560).int32(message.status);
    }
    for (const v of message.friends) {
      writer.uint32(642).string(v!);
    }
    if (message.created !== undefined) {
      Timestamp.encode(toTimestamp(message.created), writer.uint32(722).fork()).ldelim();
    }
    if (message.updated !== undefined) {
      Timestamp.encode(toTimestamp(message.updated), writer.uint32(802).fork()).ldelim();
    }
    if (message.open !== undefined) {
      writer.uint32(880).int32(message.open);
    }
    if (message.admin !== undefined) {
      writer.uint32(960).bool(message.admin);
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
        case 10:
          if (tag !== 82) {
            break;
          }

          message.uid = reader.string();
          continue;
        case 20:
          if (tag !== 162) {
            break;
          }

          message.displayName = reader.string();
          continue;
        case 30:
          if (tag !== 242) {
            break;
          }

          message.nick = reader.string();
          continue;
        case 40:
          if (tag !== 322) {
            break;
          }

          message.email = reader.string();
          continue;
        case 50:
          if (tag !== 402) {
            break;
          }

          message.phoneNumber = reader.string();
          continue;
        case 60:
          if (tag !== 482) {
            break;
          }

          message.photoURL = reader.string();
          continue;
        case 70:
          if (tag !== 560) {
            break;
          }

          message.status = reader.int32() as any;
          continue;
        case 80:
          if (tag !== 642) {
            break;
          }

          message.friends.push(reader.string());
          continue;
        case 90:
          if (tag !== 722) {
            break;
          }

          message.created = fromTimestamp(Timestamp.decode(reader, reader.uint32()));
          continue;
        case 100:
          if (tag !== 802) {
            break;
          }

          message.updated = fromTimestamp(Timestamp.decode(reader, reader.uint32()));
          continue;
        case 110:
          if (tag !== 880) {
            break;
          }

          message.open = reader.int32() as any;
          continue;
        case 120:
          if (tag !== 960) {
            break;
          }

          message.admin = reader.bool();
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
      uid: isSet(object.uid) ? globalThis.String(object.uid) : undefined,
      displayName: isSet(object.displayName) ? globalThis.String(object.displayName) : undefined,
      nick: isSet(object.nick) ? globalThis.String(object.nick) : undefined,
      email: isSet(object.email) ? globalThis.String(object.email) : undefined,
      phoneNumber: isSet(object.phoneNumber) ? globalThis.String(object.phoneNumber) : undefined,
      photoURL: isSet(object.photoURL) ? globalThis.String(object.photoURL) : undefined,
      status: isSet(object.status) ? activeFromJSON(object.status) : undefined,
      friends: globalThis.Array.isArray(object?.friends) ? object.friends.map((e: any) => globalThis.String(e)) : [],
      created: isSet(object.created) ? fromJsonTimestamp(object.created) : undefined,
      updated: isSet(object.updated) ? fromJsonTimestamp(object.updated) : undefined,
      open: isSet(object.open) ? visibleFromJSON(object.open) : undefined,
      admin: isSet(object.admin) ? globalThis.Boolean(object.admin) : undefined,
    };
  },

  toJSON(message: User): unknown {
    const obj: any = {};
    if (message.uid !== undefined) {
      obj.uid = message.uid;
    }
    if (message.displayName !== undefined) {
      obj.displayName = message.displayName;
    }
    if (message.nick !== undefined) {
      obj.nick = message.nick;
    }
    if (message.email !== undefined) {
      obj.email = message.email;
    }
    if (message.phoneNumber !== undefined) {
      obj.phoneNumber = message.phoneNumber;
    }
    if (message.photoURL !== undefined) {
      obj.photoURL = message.photoURL;
    }
    if (message.status !== undefined) {
      obj.status = activeToJSON(message.status);
    }
    if (message.friends?.length) {
      obj.friends = message.friends;
    }
    if (message.created !== undefined) {
      obj.created = message.created.toISOString();
    }
    if (message.updated !== undefined) {
      obj.updated = message.updated.toISOString();
    }
    if (message.open !== undefined) {
      obj.open = visibleToJSON(message.open);
    }
    if (message.admin !== undefined) {
      obj.admin = message.admin;
    }
    return obj;
  },

  create<I extends Exact<DeepPartial<User>, I>>(base?: I): User {
    return User.fromPartial(base ?? ({} as any));
  },
  fromPartial<I extends Exact<DeepPartial<User>, I>>(object: I): User {
    const message = createBaseUser();
    message.uid = object.uid ?? undefined;
    message.displayName = object.displayName ?? undefined;
    message.nick = object.nick ?? undefined;
    message.email = object.email ?? undefined;
    message.phoneNumber = object.phoneNumber ?? undefined;
    message.photoURL = object.photoURL ?? undefined;
    message.status = object.status ?? undefined;
    message.friends = object.friends?.map((e) => e) || [];
    message.created = object.created ?? undefined;
    message.updated = object.updated ?? undefined;
    message.open = object.open ?? undefined;
    message.admin = object.admin ?? undefined;
    return message;
  },
};

function createBaseMessaging(): Messaging {
  return { fcmToken: undefined, timestamp: undefined };
}

export const Messaging = {
  encode(message: Messaging, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.fcmToken !== undefined) {
      writer.uint32(82).string(message.fcmToken);
    }
    if (message.timestamp !== undefined) {
      Timestamp.encode(toTimestamp(message.timestamp), writer.uint32(162).fork()).ldelim();
    }
    return writer;
  },

  decode(input: _m0.Reader | Uint8Array, length?: number): Messaging {
    const reader = input instanceof _m0.Reader ? input : _m0.Reader.create(input);
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = createBaseMessaging();
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 10:
          if (tag !== 82) {
            break;
          }

          message.fcmToken = reader.string();
          continue;
        case 20:
          if (tag !== 162) {
            break;
          }

          message.timestamp = fromTimestamp(Timestamp.decode(reader, reader.uint32()));
          continue;
      }
      if ((tag & 7) === 4 || tag === 0) {
        break;
      }
      reader.skipType(tag & 7);
    }
    return message;
  },

  fromJSON(object: any): Messaging {
    return {
      fcmToken: isSet(object.fcmToken) ? globalThis.String(object.fcmToken) : undefined,
      timestamp: isSet(object.timestamp) ? fromJsonTimestamp(object.timestamp) : undefined,
    };
  },

  toJSON(message: Messaging): unknown {
    const obj: any = {};
    if (message.fcmToken !== undefined) {
      obj.fcmToken = message.fcmToken;
    }
    if (message.timestamp !== undefined) {
      obj.timestamp = message.timestamp.toISOString();
    }
    return obj;
  },

  create<I extends Exact<DeepPartial<Messaging>, I>>(base?: I): Messaging {
    return Messaging.fromPartial(base ?? ({} as any));
  },
  fromPartial<I extends Exact<DeepPartial<Messaging>, I>>(object: I): Messaging {
    const message = createBaseMessaging();
    message.fcmToken = object.fcmToken ?? undefined;
    message.timestamp = object.timestamp ?? undefined;
    return message;
  },
};

function createBaseRoomUser(): RoomUser {
  return {
    uid: undefined,
    user: undefined,
    room: undefined,
    role: undefined,
    created: undefined,
    updated: undefined,
    subscribed: undefined,
  };
}

export const RoomUser = {
  encode(message: RoomUser, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.uid !== undefined) {
      writer.uint32(82).string(message.uid);
    }
    if (message.user !== undefined) {
      writer.uint32(162).string(message.user);
    }
    if (message.room !== undefined) {
      writer.uint32(242).string(message.room);
    }
    if (message.role !== undefined) {
      writer.uint32(320).int32(message.role);
    }
    if (message.created !== undefined) {
      Timestamp.encode(toTimestamp(message.created), writer.uint32(402).fork()).ldelim();
    }
    if (message.updated !== undefined) {
      Timestamp.encode(toTimestamp(message.updated), writer.uint32(482).fork()).ldelim();
    }
    if (message.subscribed !== undefined) {
      writer.uint32(560).bool(message.subscribed);
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
        case 10:
          if (tag !== 82) {
            break;
          }

          message.uid = reader.string();
          continue;
        case 20:
          if (tag !== 162) {
            break;
          }

          message.user = reader.string();
          continue;
        case 30:
          if (tag !== 242) {
            break;
          }

          message.room = reader.string();
          continue;
        case 40:
          if (tag !== 320) {
            break;
          }

          message.role = reader.int32() as any;
          continue;
        case 50:
          if (tag !== 402) {
            break;
          }

          message.created = fromTimestamp(Timestamp.decode(reader, reader.uint32()));
          continue;
        case 60:
          if (tag !== 482) {
            break;
          }

          message.updated = fromTimestamp(Timestamp.decode(reader, reader.uint32()));
          continue;
        case 70:
          if (tag !== 560) {
            break;
          }

          message.subscribed = reader.bool();
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
      uid: isSet(object.uid) ? globalThis.String(object.uid) : undefined,
      user: isSet(object.user) ? globalThis.String(object.user) : undefined,
      room: isSet(object.room) ? globalThis.String(object.room) : undefined,
      role: isSet(object.role) ? roleFromJSON(object.role) : undefined,
      created: isSet(object.created) ? fromJsonTimestamp(object.created) : undefined,
      updated: isSet(object.updated) ? fromJsonTimestamp(object.updated) : undefined,
      subscribed: isSet(object.subscribed) ? globalThis.Boolean(object.subscribed) : undefined,
    };
  },

  toJSON(message: RoomUser): unknown {
    const obj: any = {};
    if (message.uid !== undefined) {
      obj.uid = message.uid;
    }
    if (message.user !== undefined) {
      obj.user = message.user;
    }
    if (message.room !== undefined) {
      obj.room = message.room;
    }
    if (message.role !== undefined) {
      obj.role = roleToJSON(message.role);
    }
    if (message.created !== undefined) {
      obj.created = message.created.toISOString();
    }
    if (message.updated !== undefined) {
      obj.updated = message.updated.toISOString();
    }
    if (message.subscribed !== undefined) {
      obj.subscribed = message.subscribed;
    }
    return obj;
  },

  create<I extends Exact<DeepPartial<RoomUser>, I>>(base?: I): RoomUser {
    return RoomUser.fromPartial(base ?? ({} as any));
  },
  fromPartial<I extends Exact<DeepPartial<RoomUser>, I>>(object: I): RoomUser {
    const message = createBaseRoomUser();
    message.uid = object.uid ?? undefined;
    message.user = object.user ?? undefined;
    message.room = object.room ?? undefined;
    message.role = object.role ?? undefined;
    message.created = object.created ?? undefined;
    message.updated = object.updated ?? undefined;
    message.subscribed = object.subscribed ?? undefined;
    return message;
  },
};

function createBaseRoom(): Room {
  return {
    uid: undefined,
    nick: undefined,
    displayName: undefined,
    open: undefined,
    photoURL: undefined,
    description: undefined,
    created: undefined,
    updated: undefined,
    famous: undefined,
  };
}

export const Room = {
  encode(message: Room, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.uid !== undefined) {
      writer.uint32(82).string(message.uid);
    }
    if (message.nick !== undefined) {
      writer.uint32(162).string(message.nick);
    }
    if (message.displayName !== undefined) {
      writer.uint32(242).string(message.displayName);
    }
    if (message.open !== undefined) {
      writer.uint32(320).int32(message.open);
    }
    if (message.photoURL !== undefined) {
      writer.uint32(402).string(message.photoURL);
    }
    if (message.description !== undefined) {
      writer.uint32(482).string(message.description);
    }
    if (message.created !== undefined) {
      Timestamp.encode(toTimestamp(message.created), writer.uint32(562).fork()).ldelim();
    }
    if (message.updated !== undefined) {
      Timestamp.encode(toTimestamp(message.updated), writer.uint32(642).fork()).ldelim();
    }
    if (message.famous !== undefined) {
      writer.uint32(720).bool(message.famous);
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
        case 10:
          if (tag !== 82) {
            break;
          }

          message.uid = reader.string();
          continue;
        case 20:
          if (tag !== 162) {
            break;
          }

          message.nick = reader.string();
          continue;
        case 30:
          if (tag !== 242) {
            break;
          }

          message.displayName = reader.string();
          continue;
        case 40:
          if (tag !== 320) {
            break;
          }

          message.open = reader.int32() as any;
          continue;
        case 50:
          if (tag !== 402) {
            break;
          }

          message.photoURL = reader.string();
          continue;
        case 60:
          if (tag !== 482) {
            break;
          }

          message.description = reader.string();
          continue;
        case 70:
          if (tag !== 562) {
            break;
          }

          message.created = fromTimestamp(Timestamp.decode(reader, reader.uint32()));
          continue;
        case 80:
          if (tag !== 642) {
            break;
          }

          message.updated = fromTimestamp(Timestamp.decode(reader, reader.uint32()));
          continue;
        case 90:
          if (tag !== 720) {
            break;
          }

          message.famous = reader.bool();
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
      uid: isSet(object.uid) ? globalThis.String(object.uid) : undefined,
      nick: isSet(object.nick) ? globalThis.String(object.nick) : undefined,
      displayName: isSet(object.displayName) ? globalThis.String(object.displayName) : undefined,
      open: isSet(object.open) ? visibleFromJSON(object.open) : undefined,
      photoURL: isSet(object.photoURL) ? globalThis.String(object.photoURL) : undefined,
      description: isSet(object.description) ? globalThis.String(object.description) : undefined,
      created: isSet(object.created) ? fromJsonTimestamp(object.created) : undefined,
      updated: isSet(object.updated) ? fromJsonTimestamp(object.updated) : undefined,
      famous: isSet(object.famous) ? globalThis.Boolean(object.famous) : undefined,
    };
  },

  toJSON(message: Room): unknown {
    const obj: any = {};
    if (message.uid !== undefined) {
      obj.uid = message.uid;
    }
    if (message.nick !== undefined) {
      obj.nick = message.nick;
    }
    if (message.displayName !== undefined) {
      obj.displayName = message.displayName;
    }
    if (message.open !== undefined) {
      obj.open = visibleToJSON(message.open);
    }
    if (message.photoURL !== undefined) {
      obj.photoURL = message.photoURL;
    }
    if (message.description !== undefined) {
      obj.description = message.description;
    }
    if (message.created !== undefined) {
      obj.created = message.created.toISOString();
    }
    if (message.updated !== undefined) {
      obj.updated = message.updated.toISOString();
    }
    if (message.famous !== undefined) {
      obj.famous = message.famous;
    }
    return obj;
  },

  create<I extends Exact<DeepPartial<Room>, I>>(base?: I): Room {
    return Room.fromPartial(base ?? ({} as any));
  },
  fromPartial<I extends Exact<DeepPartial<Room>, I>>(object: I): Room {
    const message = createBaseRoom();
    message.uid = object.uid ?? undefined;
    message.nick = object.nick ?? undefined;
    message.displayName = object.displayName ?? undefined;
    message.open = object.open ?? undefined;
    message.photoURL = object.photoURL ?? undefined;
    message.description = object.description ?? undefined;
    message.created = object.created ?? undefined;
    message.updated = object.updated ?? undefined;
    message.famous = object.famous ?? undefined;
    return message;
  },
};

function createBaseTweet(): Tweet {
  return {
    uid: undefined,
    user: undefined,
    room: undefined,
    path: undefined,
    created: undefined,
    mediaType: undefined,
    text: undefined,
    link: undefined,
    gallery: [],
  };
}

export const Tweet = {
  encode(message: Tweet, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.uid !== undefined) {
      writer.uint32(82).string(message.uid);
    }
    if (message.user !== undefined) {
      writer.uint32(162).string(message.user);
    }
    if (message.room !== undefined) {
      writer.uint32(242).string(message.room);
    }
    if (message.path !== undefined) {
      writer.uint32(322).string(message.path);
    }
    if (message.created !== undefined) {
      Timestamp.encode(toTimestamp(message.created), writer.uint32(402).fork()).ldelim();
    }
    if (message.mediaType !== undefined) {
      writer.uint32(480).int32(message.mediaType);
    }
    if (message.text !== undefined) {
      writer.uint32(562).string(message.text);
    }
    if (message.link !== undefined) {
      writer.uint32(642).string(message.link);
    }
    for (const v of message.gallery) {
      ImageMetadata.encode(v!, writer.uint32(722).fork()).ldelim();
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
        case 10:
          if (tag !== 82) {
            break;
          }

          message.uid = reader.string();
          continue;
        case 20:
          if (tag !== 162) {
            break;
          }

          message.user = reader.string();
          continue;
        case 30:
          if (tag !== 242) {
            break;
          }

          message.room = reader.string();
          continue;
        case 40:
          if (tag !== 322) {
            break;
          }

          message.path = reader.string();
          continue;
        case 50:
          if (tag !== 402) {
            break;
          }

          message.created = fromTimestamp(Timestamp.decode(reader, reader.uint32()));
          continue;
        case 60:
          if (tag !== 480) {
            break;
          }

          message.mediaType = reader.int32() as any;
          continue;
        case 70:
          if (tag !== 562) {
            break;
          }

          message.text = reader.string();
          continue;
        case 80:
          if (tag !== 642) {
            break;
          }

          message.link = reader.string();
          continue;
        case 90:
          if (tag !== 722) {
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
      uid: isSet(object.uid) ? globalThis.String(object.uid) : undefined,
      user: isSet(object.user) ? globalThis.String(object.user) : undefined,
      room: isSet(object.room) ? globalThis.String(object.room) : undefined,
      path: isSet(object.path) ? globalThis.String(object.path) : undefined,
      created: isSet(object.created) ? fromJsonTimestamp(object.created) : undefined,
      mediaType: isSet(object.mediaType) ? mediaTypeFromJSON(object.mediaType) : undefined,
      text: isSet(object.text) ? globalThis.String(object.text) : undefined,
      link: isSet(object.link) ? globalThis.String(object.link) : undefined,
      gallery: globalThis.Array.isArray(object?.gallery)
        ? object.gallery.map((e: any) => ImageMetadata.fromJSON(e))
        : [],
    };
  },

  toJSON(message: Tweet): unknown {
    const obj: any = {};
    if (message.uid !== undefined) {
      obj.uid = message.uid;
    }
    if (message.user !== undefined) {
      obj.user = message.user;
    }
    if (message.room !== undefined) {
      obj.room = message.room;
    }
    if (message.path !== undefined) {
      obj.path = message.path;
    }
    if (message.created !== undefined) {
      obj.created = message.created.toISOString();
    }
    if (message.mediaType !== undefined) {
      obj.mediaType = mediaTypeToJSON(message.mediaType);
    }
    if (message.text !== undefined) {
      obj.text = message.text;
    }
    if (message.link !== undefined) {
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
    message.uid = object.uid ?? undefined;
    message.user = object.user ?? undefined;
    message.room = object.room ?? undefined;
    message.path = object.path ?? undefined;
    message.created = object.created ?? undefined;
    message.mediaType = object.mediaType ?? undefined;
    message.text = object.text ?? undefined;
    message.link = object.link ?? undefined;
    message.gallery = object.gallery?.map((e) => ImageMetadata.fromPartial(e)) || [];
    return message;
  },
};

function createBaseImageMetadata(): ImageMetadata {
  return {
    unsplashurl: undefined,
    path: undefined,
    localUrl: undefined,
    width: undefined,
    height: undefined,
    caption: undefined,
    type: undefined,
  };
}

export const ImageMetadata = {
  encode(message: ImageMetadata, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.unsplashurl !== undefined) {
      writer.uint32(82).string(message.unsplashurl);
    }
    if (message.path !== undefined) {
      writer.uint32(162).string(message.path);
    }
    if (message.localUrl !== undefined) {
      writer.uint32(242).string(message.localUrl);
    }
    if (message.width !== undefined) {
      writer.uint32(320).int32(message.width);
    }
    if (message.height !== undefined) {
      writer.uint32(400).int32(message.height);
    }
    if (message.caption !== undefined) {
      writer.uint32(482).string(message.caption);
    }
    if (message.type !== undefined) {
      writer.uint32(562).string(message.type);
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
        case 10:
          if (tag !== 82) {
            break;
          }

          message.unsplashurl = reader.string();
          continue;
        case 20:
          if (tag !== 162) {
            break;
          }

          message.path = reader.string();
          continue;
        case 30:
          if (tag !== 242) {
            break;
          }

          message.localUrl = reader.string();
          continue;
        case 40:
          if (tag !== 320) {
            break;
          }

          message.width = reader.int32();
          continue;
        case 50:
          if (tag !== 400) {
            break;
          }

          message.height = reader.int32();
          continue;
        case 60:
          if (tag !== 482) {
            break;
          }

          message.caption = reader.string();
          continue;
        case 70:
          if (tag !== 562) {
            break;
          }

          message.type = reader.string();
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
      unsplashurl: isSet(object.unsplashurl) ? globalThis.String(object.unsplashurl) : undefined,
      path: isSet(object.path) ? globalThis.String(object.path) : undefined,
      localUrl: isSet(object.localUrl) ? globalThis.String(object.localUrl) : undefined,
      width: isSet(object.width) ? globalThis.Number(object.width) : undefined,
      height: isSet(object.height) ? globalThis.Number(object.height) : undefined,
      caption: isSet(object.caption) ? globalThis.String(object.caption) : undefined,
      type: isSet(object.type) ? globalThis.String(object.type) : undefined,
    };
  },

  toJSON(message: ImageMetadata): unknown {
    const obj: any = {};
    if (message.unsplashurl !== undefined) {
      obj.unsplashurl = message.unsplashurl;
    }
    if (message.path !== undefined) {
      obj.path = message.path;
    }
    if (message.localUrl !== undefined) {
      obj.localUrl = message.localUrl;
    }
    if (message.width !== undefined) {
      obj.width = Math.round(message.width);
    }
    if (message.height !== undefined) {
      obj.height = Math.round(message.height);
    }
    if (message.caption !== undefined) {
      obj.caption = message.caption;
    }
    if (message.type !== undefined) {
      obj.type = message.type;
    }
    return obj;
  },

  create<I extends Exact<DeepPartial<ImageMetadata>, I>>(base?: I): ImageMetadata {
    return ImageMetadata.fromPartial(base ?? ({} as any));
  },
  fromPartial<I extends Exact<DeepPartial<ImageMetadata>, I>>(object: I): ImageMetadata {
    const message = createBaseImageMetadata();
    message.unsplashurl = object.unsplashurl ?? undefined;
    message.path = object.path ?? undefined;
    message.localUrl = object.localUrl ?? undefined;
    message.width = object.width ?? undefined;
    message.height = object.height ?? undefined;
    message.caption = object.caption ?? undefined;
    message.type = object.type ?? undefined;
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
