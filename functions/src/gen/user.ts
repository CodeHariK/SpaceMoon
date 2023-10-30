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

export interface User {
  id: string;
  nam: string;
  nick: string;
  email: string;
  phone: string;
  avatar: string;
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
    id: "",
    nam: "",
    nick: "",
    email: "",
    phone: "",
    avatar: "",
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
    if (message.id !== "") {
      writer.uint32(802).string(message.id);
    }
    if (message.nam !== "") {
      writer.uint32(1602).string(message.nam);
    }
    if (message.nick !== "") {
      writer.uint32(1682).string(message.nick);
    }
    if (message.email !== "") {
      writer.uint32(2402).string(message.email);
    }
    if (message.phone !== "") {
      writer.uint32(3202).string(message.phone);
    }
    if (message.avatar !== "") {
      writer.uint32(4002).string(message.avatar);
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

          message.id = reader.string();
          continue;
        case 200:
          if (tag !== 1602) {
            break;
          }

          message.nam = reader.string();
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

          message.phone = reader.string();
          continue;
        case 500:
          if (tag !== 4002) {
            break;
          }

          message.avatar = reader.string();
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
      id: isSet(object.id) ? globalThis.String(object.id) : "",
      nam: isSet(object.nam) ? globalThis.String(object.nam) : "",
      nick: isSet(object.nick) ? globalThis.String(object.nick) : "",
      email: isSet(object.email) ? globalThis.String(object.email) : "",
      phone: isSet(object.phone) ? globalThis.String(object.phone) : "",
      avatar: isSet(object.avatar) ? globalThis.String(object.avatar) : "",
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
    if (message.id !== "") {
      obj.id = message.id;
    }
    if (message.nam !== "") {
      obj.nam = message.nam;
    }
    if (message.nick !== "") {
      obj.nick = message.nick;
    }
    if (message.email !== "") {
      obj.email = message.email;
    }
    if (message.phone !== "") {
      obj.phone = message.phone;
    }
    if (message.avatar !== "") {
      obj.avatar = message.avatar;
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
    message.id = object.id ?? "";
    message.nam = object.nam ?? "";
    message.nick = object.nick ?? "";
    message.email = object.email ?? "";
    message.phone = object.phone ?? "";
    message.avatar = object.avatar ?? "";
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
