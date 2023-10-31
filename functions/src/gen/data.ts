/* eslint-disable */
import * as _m0 from "protobufjs/minimal";

export const protobufPackage = "user";

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
  uid = 100,
  nick = 110,
  displayName = 150,
  email = 200,
  phoneNumber = 250,
  photoURL = 350,
  status = 400,
  created = 600,
  open = 700,
  members = 800,
  tweet_count = 900,
  description = 1000,
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
    case 350:
    case "photoURL":
      return Const.photoURL;
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
  rooms: string[];
  roomRequest: string[];
  /**
   * repeated string rooms = 8 [json_name = "dinosaur"];
   * int32 level = 9;
   */
  created: string;
  /** google.protobuf.Timestamp updatedAt = 11; */
  open: Visible;
  /** ------------------- */
  fcmToken: string;
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
    rooms: [],
    roomRequest: [],
    created: "",
    open: 0,
    fcmToken: "",
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
      writer.uint32(1682).string(message.nick);
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
    for (const v of message.rooms) {
      writer.uint32(5602).string(v!);
    }
    for (const v of message.roomRequest) {
      writer.uint32(6402).string(v!);
    }
    if (message.created !== "") {
      writer.uint32(7202).string(message.created);
    }
    if (message.open !== 0) {
      writer.uint32(8000).int32(message.open);
    }
    if (message.fcmToken !== "") {
      writer.uint32(8802).string(message.fcmToken);
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
        case 210:
          if (tag !== 1682) {
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

          message.rooms.push(reader.string());
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

          message.created = reader.string();
          continue;
        case 1000:
          if (tag !== 8000) {
            break;
          }

          message.open = reader.int32() as any;
          continue;
        case 1100:
          if (tag !== 8802) {
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

  fromJSON(object: any): User {
    return {
      uid: isSet(object.uid) ? globalThis.String(object.uid) : "",
      displayName: isSet(object.displayName) ? globalThis.String(object.displayName) : "",
      nick: isSet(object.nick) ? globalThis.String(object.nick) : "",
      email: isSet(object.email) ? globalThis.String(object.email) : "",
      phoneNumber: isSet(object.phoneNumber) ? globalThis.String(object.phoneNumber) : "",
      photoURL: isSet(object.photoURL) ? globalThis.String(object.photoURL) : "",
      status: isSet(object.status) ? activeFromJSON(object.status) : 0,
      rooms: globalThis.Array.isArray(object?.rooms) ? object.rooms.map((e: any) => globalThis.String(e)) : [],
      roomRequest: globalThis.Array.isArray(object?.roomRequest)
        ? object.roomRequest.map((e: any) => globalThis.String(e))
        : [],
      created: isSet(object.created) ? globalThis.String(object.created) : "",
      open: isSet(object.open) ? visibleFromJSON(object.open) : 0,
      fcmToken: isSet(object.fcmToken) ? globalThis.String(object.fcmToken) : "",
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
    if (message.rooms?.length) {
      obj.rooms = message.rooms;
    }
    if (message.roomRequest?.length) {
      obj.roomRequest = message.roomRequest;
    }
    if (message.created !== "") {
      obj.created = message.created;
    }
    if (message.open !== 0) {
      obj.open = visibleToJSON(message.open);
    }
    if (message.fcmToken !== "") {
      obj.fcmToken = message.fcmToken;
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
    message.rooms = object.rooms?.map((e) => e) || [];
    message.roomRequest = object.roomRequest?.map((e) => e) || [];
    message.created = object.created ?? "";
    message.open = object.open ?? 0;
    message.fcmToken = object.fcmToken ?? "";
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

function isSet(value: any): boolean {
  return value !== null && value !== undefined;
}
