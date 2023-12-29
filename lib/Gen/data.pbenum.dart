//
//  Generated code. Do not modify.
//  source: data.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Role extends $pb.ProtobufEnum {
  static const Role REQUEST = Role._(0, _omitEnumNames ? '' : 'REQUEST');
  static const Role USER = Role._(10, _omitEnumNames ? '' : 'USER');
  static const Role INVITE = Role._(20, _omitEnumNames ? '' : 'INVITE');
  static const Role MODERATOR = Role._(30, _omitEnumNames ? '' : 'MODERATOR');
  static const Role ADMIN = Role._(40, _omitEnumNames ? '' : 'ADMIN');

  static const $core.List<Role> values = <Role> [
    REQUEST,
    USER,
    INVITE,
    MODERATOR,
    ADMIN,
  ];

  static final $core.Map<$core.int, Role> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Role? valueOf($core.int value) => _byValue[value];

  const Role._($core.int v, $core.String n) : super(v, n);
}

class MediaType extends $pb.ProtobufEnum {
  static const MediaType TEXT = MediaType._(0, _omitEnumNames ? '' : 'TEXT');
  static const MediaType FILE = MediaType._(10, _omitEnumNames ? '' : 'FILE');
  static const MediaType QR = MediaType._(20, _omitEnumNames ? '' : 'QR');
  static const MediaType POST = MediaType._(30, _omitEnumNames ? '' : 'POST');
  static const MediaType GALLERY = MediaType._(40, _omitEnumNames ? '' : 'GALLERY');

  static const $core.List<MediaType> values = <MediaType> [
    TEXT,
    FILE,
    QR,
    POST,
    GALLERY,
  ];

  static final $core.Map<$core.int, MediaType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MediaType? valueOf($core.int value) => _byValue[value];

  const MediaType._($core.int v, $core.String n) : super(v, n);
}

class Active extends $pb.ProtobufEnum {
  static const Active OFFLINE = Active._(0, _omitEnumNames ? '' : 'OFFLINE');
  static const Active ONLINE = Active._(10, _omitEnumNames ? '' : 'ONLINE');
  static const Active TYPING = Active._(20, _omitEnumNames ? '' : 'TYPING');

  static const $core.List<Active> values = <Active> [
    OFFLINE,
    ONLINE,
    TYPING,
  ];

  static final $core.Map<$core.int, Active> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Active? valueOf($core.int value) => _byValue[value];

  const Active._($core.int v, $core.String n) : super(v, n);
}

class Visible extends $pb.ProtobufEnum {
  static const Visible CLOSE = Visible._(0, _omitEnumNames ? '' : 'CLOSE');
  static const Visible MODERATED = Visible._(10, _omitEnumNames ? '' : 'MODERATED');
  static const Visible OPEN = Visible._(20, _omitEnumNames ? '' : 'OPEN');

  static const $core.List<Visible> values = <Visible> [
    CLOSE,
    MODERATED,
    OPEN,
  ];

  static final $core.Map<$core.int, Visible> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Visible? valueOf($core.int value) => _byValue[value];

  const Visible._($core.int v, $core.String n) : super(v, n);
}

class Const extends $pb.ProtobufEnum {
  static const Const users = Const._(0, _omitEnumNames ? '' : 'users');
  static const Const rooms = Const._(10, _omitEnumNames ? '' : 'rooms');
  static const Const tweets = Const._(20, _omitEnumNames ? '' : 'tweets');
  static const Const roomusers = Const._(30, _omitEnumNames ? '' : 'roomusers');
  static const Const uid = Const._(40, _omitEnumNames ? '' : 'uid');
  static const Const nick = Const._(45, _omitEnumNames ? '' : 'nick');
  static const Const role = Const._(50, _omitEnumNames ? '' : 'role');
  static const Const user = Const._(55, _omitEnumNames ? '' : 'user');
  static const Const room = Const._(60, _omitEnumNames ? '' : 'room');
  static const Const displayName = Const._(65, _omitEnumNames ? '' : 'displayName');
  static const Const email = Const._(70, _omitEnumNames ? '' : 'email');
  static const Const phoneNumber = Const._(80, _omitEnumNames ? '' : 'phoneNumber');
  static const Const photoURL = Const._(90, _omitEnumNames ? '' : 'photoURL');
  static const Const fcmToken = Const._(100, _omitEnumNames ? '' : 'fcmToken');
  static const Const status = Const._(110, _omitEnumNames ? '' : 'status');
  static const Const created = Const._(120, _omitEnumNames ? '' : 'created');
  static const Const updated = Const._(130, _omitEnumNames ? '' : 'updated');
  static const Const timestamp = Const._(140, _omitEnumNames ? '' : 'timestamp');
  static const Const open = Const._(150, _omitEnumNames ? '' : 'open');
  static const Const famous = Const._(155, _omitEnumNames ? '' : 'famous');
  static const Const members = Const._(160, _omitEnumNames ? '' : 'members');
  static const Const tweet_count = Const._(170, _omitEnumNames ? '' : 'tweet_count');
  static const Const description = Const._(180, _omitEnumNames ? '' : 'description');
  static const Const gallery = Const._(190, _omitEnumNames ? '' : 'gallery');

  static const $core.List<Const> values = <Const> [
    users,
    rooms,
    tweets,
    roomusers,
    uid,
    nick,
    role,
    user,
    room,
    displayName,
    email,
    phoneNumber,
    photoURL,
    fcmToken,
    status,
    created,
    updated,
    timestamp,
    open,
    famous,
    members,
    tweet_count,
    description,
    gallery,
  ];

  static final $core.Map<$core.int, Const> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Const? valueOf($core.int value) => _byValue[value];

  const Const._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
