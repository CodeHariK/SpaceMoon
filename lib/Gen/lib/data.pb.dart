// This is a generated file - do not edit.
//
// Generated from lib/data.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $0;

import 'data.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'data.pbenum.dart';

class User extends $pb.GeneratedMessage {
  factory User({
    $core.String? uid,
    $core.String? displayName,
    $core.String? nick,
    $core.String? email,
    $core.String? phoneNumber,
    $core.String? photoURL,
    Active? status,
    $0.Timestamp? created,
    $0.Timestamp? updated,
    Visible? open,
    $core.bool? admin,
  }) {
    final result = create();
    if (uid != null) result.uid = uid;
    if (displayName != null) result.displayName = displayName;
    if (nick != null) result.nick = nick;
    if (email != null) result.email = email;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (photoURL != null) result.photoURL = photoURL;
    if (status != null) result.status = status;
    if (created != null) result.created = created;
    if (updated != null) result.updated = updated;
    if (open != null) result.open = open;
    if (admin != null) result.admin = admin;
    return result;
  }

  User._();

  factory User.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory User.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'User',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'user'),
      createEmptyInstance: create)
    ..aOS(10, _omitFieldNames ? '' : 'uid')
    ..aOS(20, _omitFieldNames ? '' : 'displayName', protoName: 'displayName')
    ..aOS(30, _omitFieldNames ? '' : 'nick')
    ..aOS(40, _omitFieldNames ? '' : 'email')
    ..aOS(50, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..aOS(60, _omitFieldNames ? '' : 'photoURL', protoName: 'photoURL')
    ..aE<Active>(70, _omitFieldNames ? '' : 'status', enumValues: Active.values)
    ..aOM<$0.Timestamp>(80, _omitFieldNames ? '' : 'created',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(90, _omitFieldNames ? '' : 'updated',
        subBuilder: $0.Timestamp.create)
    ..aE<Visible>(100, _omitFieldNames ? '' : 'open',
        enumValues: Visible.values)
    ..aOB(110, _omitFieldNames ? '' : 'admin')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  User clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  User copyWith(void Function(User) updates) =>
      super.copyWith((message) => updates(message as User)) as User;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  @$core.override
  User createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static User getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get uid => $_getSZ(0);
  @$pb.TagNumber(10)
  set uid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(10)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(10)
  void clearUid() => $_clearField(10);

  @$pb.TagNumber(20)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(20)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(20)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(20)
  void clearDisplayName() => $_clearField(20);

  @$pb.TagNumber(30)
  $core.String get nick => $_getSZ(2);
  @$pb.TagNumber(30)
  set nick($core.String value) => $_setString(2, value);
  @$pb.TagNumber(30)
  $core.bool hasNick() => $_has(2);
  @$pb.TagNumber(30)
  void clearNick() => $_clearField(30);

  @$pb.TagNumber(40)
  $core.String get email => $_getSZ(3);
  @$pb.TagNumber(40)
  set email($core.String value) => $_setString(3, value);
  @$pb.TagNumber(40)
  $core.bool hasEmail() => $_has(3);
  @$pb.TagNumber(40)
  void clearEmail() => $_clearField(40);

  @$pb.TagNumber(50)
  $core.String get phoneNumber => $_getSZ(4);
  @$pb.TagNumber(50)
  set phoneNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(50)
  $core.bool hasPhoneNumber() => $_has(4);
  @$pb.TagNumber(50)
  void clearPhoneNumber() => $_clearField(50);

  @$pb.TagNumber(60)
  $core.String get photoURL => $_getSZ(5);
  @$pb.TagNumber(60)
  set photoURL($core.String value) => $_setString(5, value);
  @$pb.TagNumber(60)
  $core.bool hasPhotoURL() => $_has(5);
  @$pb.TagNumber(60)
  void clearPhotoURL() => $_clearField(60);

  @$pb.TagNumber(70)
  Active get status => $_getN(6);
  @$pb.TagNumber(70)
  set status(Active value) => $_setField(70, value);
  @$pb.TagNumber(70)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(70)
  void clearStatus() => $_clearField(70);

  @$pb.TagNumber(80)
  $0.Timestamp get created => $_getN(7);
  @$pb.TagNumber(80)
  set created($0.Timestamp value) => $_setField(80, value);
  @$pb.TagNumber(80)
  $core.bool hasCreated() => $_has(7);
  @$pb.TagNumber(80)
  void clearCreated() => $_clearField(80);
  @$pb.TagNumber(80)
  $0.Timestamp ensureCreated() => $_ensure(7);

  @$pb.TagNumber(90)
  $0.Timestamp get updated => $_getN(8);
  @$pb.TagNumber(90)
  set updated($0.Timestamp value) => $_setField(90, value);
  @$pb.TagNumber(90)
  $core.bool hasUpdated() => $_has(8);
  @$pb.TagNumber(90)
  void clearUpdated() => $_clearField(90);
  @$pb.TagNumber(90)
  $0.Timestamp ensureUpdated() => $_ensure(8);

  @$pb.TagNumber(100)
  Visible get open => $_getN(9);
  @$pb.TagNumber(100)
  set open(Visible value) => $_setField(100, value);
  @$pb.TagNumber(100)
  $core.bool hasOpen() => $_has(9);
  @$pb.TagNumber(100)
  void clearOpen() => $_clearField(100);

  @$pb.TagNumber(110)
  $core.bool get admin => $_getBF(10);
  @$pb.TagNumber(110)
  set admin($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(110)
  $core.bool hasAdmin() => $_has(10);
  @$pb.TagNumber(110)
  void clearAdmin() => $_clearField(110);
}

class UserUser extends $pb.GeneratedMessage {
  factory UserUser({
    $core.String? uid,
    UserRole? role,
  }) {
    final result = create();
    if (uid != null) result.uid = uid;
    if (role != null) result.role = role;
    return result;
  }

  UserUser._();

  factory UserUser.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserUser.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserUser',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'user'),
      createEmptyInstance: create)
    ..aOS(10, _omitFieldNames ? '' : 'uid')
    ..aE<UserRole>(20, _omitFieldNames ? '' : 'role',
        enumValues: UserRole.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserUser clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserUser copyWith(void Function(UserUser) updates) =>
      super.copyWith((message) => updates(message as UserUser)) as UserUser;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserUser create() => UserUser._();
  @$core.override
  UserUser createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserUser getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserUser>(create);
  static UserUser? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get uid => $_getSZ(0);
  @$pb.TagNumber(10)
  set uid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(10)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(10)
  void clearUid() => $_clearField(10);

  @$pb.TagNumber(20)
  UserRole get role => $_getN(1);
  @$pb.TagNumber(20)
  set role(UserRole value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(20)
  void clearRole() => $_clearField(20);
}

class Messaging extends $pb.GeneratedMessage {
  factory Messaging({
    $core.String? fcmToken,
    $0.Timestamp? timestamp,
  }) {
    final result = create();
    if (fcmToken != null) result.fcmToken = fcmToken;
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  Messaging._();

  factory Messaging.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messaging.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Messaging',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'user'),
      createEmptyInstance: create)
    ..aOS(10, _omitFieldNames ? '' : 'fcmToken', protoName: 'fcmToken')
    ..aOM<$0.Timestamp>(20, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messaging clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messaging copyWith(void Function(Messaging) updates) =>
      super.copyWith((message) => updates(message as Messaging)) as Messaging;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messaging create() => Messaging._();
  @$core.override
  Messaging createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messaging getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messaging>(create);
  static Messaging? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get fcmToken => $_getSZ(0);
  @$pb.TagNumber(10)
  set fcmToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(10)
  $core.bool hasFcmToken() => $_has(0);
  @$pb.TagNumber(10)
  void clearFcmToken() => $_clearField(10);

  @$pb.TagNumber(20)
  $0.Timestamp get timestamp => $_getN(1);
  @$pb.TagNumber(20)
  set timestamp($0.Timestamp value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(20)
  void clearTimestamp() => $_clearField(20);
  @$pb.TagNumber(20)
  $0.Timestamp ensureTimestamp() => $_ensure(1);
}

class RoomUser extends $pb.GeneratedMessage {
  factory RoomUser({
    $core.String? uid,
    $core.String? user,
    $core.String? room,
    Role? role,
    $0.Timestamp? created,
    $0.Timestamp? updated,
    $core.bool? subscribed,
  }) {
    final result = create();
    if (uid != null) result.uid = uid;
    if (user != null) result.user = user;
    if (room != null) result.room = room;
    if (role != null) result.role = role;
    if (created != null) result.created = created;
    if (updated != null) result.updated = updated;
    if (subscribed != null) result.subscribed = subscribed;
    return result;
  }

  RoomUser._();

  factory RoomUser.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoomUser.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoomUser',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'user'),
      createEmptyInstance: create)
    ..aOS(10, _omitFieldNames ? '' : 'uid')
    ..aOS(20, _omitFieldNames ? '' : 'user')
    ..aOS(30, _omitFieldNames ? '' : 'room')
    ..aE<Role>(40, _omitFieldNames ? '' : 'role', enumValues: Role.values)
    ..aOM<$0.Timestamp>(50, _omitFieldNames ? '' : 'created',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(60, _omitFieldNames ? '' : 'updated',
        subBuilder: $0.Timestamp.create)
    ..aOB(70, _omitFieldNames ? '' : 'subscribed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomUser clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoomUser copyWith(void Function(RoomUser) updates) =>
      super.copyWith((message) => updates(message as RoomUser)) as RoomUser;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomUser create() => RoomUser._();
  @$core.override
  RoomUser createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoomUser getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomUser>(create);
  static RoomUser? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get uid => $_getSZ(0);
  @$pb.TagNumber(10)
  set uid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(10)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(10)
  void clearUid() => $_clearField(10);

  @$pb.TagNumber(20)
  $core.String get user => $_getSZ(1);
  @$pb.TagNumber(20)
  set user($core.String value) => $_setString(1, value);
  @$pb.TagNumber(20)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(20)
  void clearUser() => $_clearField(20);

  @$pb.TagNumber(30)
  $core.String get room => $_getSZ(2);
  @$pb.TagNumber(30)
  set room($core.String value) => $_setString(2, value);
  @$pb.TagNumber(30)
  $core.bool hasRoom() => $_has(2);
  @$pb.TagNumber(30)
  void clearRoom() => $_clearField(30);

  @$pb.TagNumber(40)
  Role get role => $_getN(3);
  @$pb.TagNumber(40)
  set role(Role value) => $_setField(40, value);
  @$pb.TagNumber(40)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(40)
  void clearRole() => $_clearField(40);

  @$pb.TagNumber(50)
  $0.Timestamp get created => $_getN(4);
  @$pb.TagNumber(50)
  set created($0.Timestamp value) => $_setField(50, value);
  @$pb.TagNumber(50)
  $core.bool hasCreated() => $_has(4);
  @$pb.TagNumber(50)
  void clearCreated() => $_clearField(50);
  @$pb.TagNumber(50)
  $0.Timestamp ensureCreated() => $_ensure(4);

  @$pb.TagNumber(60)
  $0.Timestamp get updated => $_getN(5);
  @$pb.TagNumber(60)
  set updated($0.Timestamp value) => $_setField(60, value);
  @$pb.TagNumber(60)
  $core.bool hasUpdated() => $_has(5);
  @$pb.TagNumber(60)
  void clearUpdated() => $_clearField(60);
  @$pb.TagNumber(60)
  $0.Timestamp ensureUpdated() => $_ensure(5);

  @$pb.TagNumber(70)
  $core.bool get subscribed => $_getBF(6);
  @$pb.TagNumber(70)
  set subscribed($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(70)
  $core.bool hasSubscribed() => $_has(6);
  @$pb.TagNumber(70)
  void clearSubscribed() => $_clearField(70);
}

class Room extends $pb.GeneratedMessage {
  factory Room({
    $core.String? uid,
    $core.String? nick,
    $core.String? displayName,
    Visible? open,
    $core.String? photoURL,
    $core.String? description,
    $0.Timestamp? created,
    $0.Timestamp? updated,
    $core.bool? famous,
  }) {
    final result = create();
    if (uid != null) result.uid = uid;
    if (nick != null) result.nick = nick;
    if (displayName != null) result.displayName = displayName;
    if (open != null) result.open = open;
    if (photoURL != null) result.photoURL = photoURL;
    if (description != null) result.description = description;
    if (created != null) result.created = created;
    if (updated != null) result.updated = updated;
    if (famous != null) result.famous = famous;
    return result;
  }

  Room._();

  factory Room.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Room.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Room',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'user'),
      createEmptyInstance: create)
    ..aOS(10, _omitFieldNames ? '' : 'uid')
    ..aOS(20, _omitFieldNames ? '' : 'nick')
    ..aOS(30, _omitFieldNames ? '' : 'displayName', protoName: 'displayName')
    ..aE<Visible>(40, _omitFieldNames ? '' : 'open', enumValues: Visible.values)
    ..aOS(50, _omitFieldNames ? '' : 'photoURL', protoName: 'photoURL')
    ..aOS(60, _omitFieldNames ? '' : 'description')
    ..aOM<$0.Timestamp>(70, _omitFieldNames ? '' : 'created',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(80, _omitFieldNames ? '' : 'updated',
        subBuilder: $0.Timestamp.create)
    ..aOB(90, _omitFieldNames ? '' : 'famous')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Room clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Room copyWith(void Function(Room) updates) =>
      super.copyWith((message) => updates(message as Room)) as Room;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Room create() => Room._();
  @$core.override
  Room createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Room getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Room>(create);
  static Room? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get uid => $_getSZ(0);
  @$pb.TagNumber(10)
  set uid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(10)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(10)
  void clearUid() => $_clearField(10);

  @$pb.TagNumber(20)
  $core.String get nick => $_getSZ(1);
  @$pb.TagNumber(20)
  set nick($core.String value) => $_setString(1, value);
  @$pb.TagNumber(20)
  $core.bool hasNick() => $_has(1);
  @$pb.TagNumber(20)
  void clearNick() => $_clearField(20);

  @$pb.TagNumber(30)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(30)
  set displayName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(30)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(30)
  void clearDisplayName() => $_clearField(30);

  @$pb.TagNumber(40)
  Visible get open => $_getN(3);
  @$pb.TagNumber(40)
  set open(Visible value) => $_setField(40, value);
  @$pb.TagNumber(40)
  $core.bool hasOpen() => $_has(3);
  @$pb.TagNumber(40)
  void clearOpen() => $_clearField(40);

  @$pb.TagNumber(50)
  $core.String get photoURL => $_getSZ(4);
  @$pb.TagNumber(50)
  set photoURL($core.String value) => $_setString(4, value);
  @$pb.TagNumber(50)
  $core.bool hasPhotoURL() => $_has(4);
  @$pb.TagNumber(50)
  void clearPhotoURL() => $_clearField(50);

  @$pb.TagNumber(60)
  $core.String get description => $_getSZ(5);
  @$pb.TagNumber(60)
  set description($core.String value) => $_setString(5, value);
  @$pb.TagNumber(60)
  $core.bool hasDescription() => $_has(5);
  @$pb.TagNumber(60)
  void clearDescription() => $_clearField(60);

  @$pb.TagNumber(70)
  $0.Timestamp get created => $_getN(6);
  @$pb.TagNumber(70)
  set created($0.Timestamp value) => $_setField(70, value);
  @$pb.TagNumber(70)
  $core.bool hasCreated() => $_has(6);
  @$pb.TagNumber(70)
  void clearCreated() => $_clearField(70);
  @$pb.TagNumber(70)
  $0.Timestamp ensureCreated() => $_ensure(6);

  @$pb.TagNumber(80)
  $0.Timestamp get updated => $_getN(7);
  @$pb.TagNumber(80)
  set updated($0.Timestamp value) => $_setField(80, value);
  @$pb.TagNumber(80)
  $core.bool hasUpdated() => $_has(7);
  @$pb.TagNumber(80)
  void clearUpdated() => $_clearField(80);
  @$pb.TagNumber(80)
  $0.Timestamp ensureUpdated() => $_ensure(7);

  @$pb.TagNumber(90)
  $core.bool get famous => $_getBF(8);
  @$pb.TagNumber(90)
  set famous($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(90)
  $core.bool hasFamous() => $_has(8);
  @$pb.TagNumber(90)
  void clearFamous() => $_clearField(90);
}

class Tweet extends $pb.GeneratedMessage {
  factory Tweet({
    $core.String? uid,
    $core.String? user,
    $core.String? room,
    $core.String? path,
    $0.Timestamp? created,
    MediaType? mediaType,
    $core.String? text,
    $core.String? link,
    $core.Iterable<ImageMetadata>? gallery,
  }) {
    final result = create();
    if (uid != null) result.uid = uid;
    if (user != null) result.user = user;
    if (room != null) result.room = room;
    if (path != null) result.path = path;
    if (created != null) result.created = created;
    if (mediaType != null) result.mediaType = mediaType;
    if (text != null) result.text = text;
    if (link != null) result.link = link;
    if (gallery != null) result.gallery.addAll(gallery);
    return result;
  }

  Tweet._();

  factory Tweet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Tweet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Tweet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'user'),
      createEmptyInstance: create)
    ..aOS(10, _omitFieldNames ? '' : 'uid')
    ..aOS(20, _omitFieldNames ? '' : 'user')
    ..aOS(30, _omitFieldNames ? '' : 'room')
    ..aOS(40, _omitFieldNames ? '' : 'path')
    ..aOM<$0.Timestamp>(50, _omitFieldNames ? '' : 'created',
        subBuilder: $0.Timestamp.create)
    ..aE<MediaType>(60, _omitFieldNames ? '' : 'mediaType',
        enumValues: MediaType.values)
    ..aOS(70, _omitFieldNames ? '' : 'text')
    ..aOS(80, _omitFieldNames ? '' : 'link')
    ..pPM<ImageMetadata>(90, _omitFieldNames ? '' : 'gallery',
        subBuilder: ImageMetadata.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tweet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tweet copyWith(void Function(Tweet) updates) =>
      super.copyWith((message) => updates(message as Tweet)) as Tweet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Tweet create() => Tweet._();
  @$core.override
  Tweet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Tweet getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tweet>(create);
  static Tweet? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get uid => $_getSZ(0);
  @$pb.TagNumber(10)
  set uid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(10)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(10)
  void clearUid() => $_clearField(10);

  @$pb.TagNumber(20)
  $core.String get user => $_getSZ(1);
  @$pb.TagNumber(20)
  set user($core.String value) => $_setString(1, value);
  @$pb.TagNumber(20)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(20)
  void clearUser() => $_clearField(20);

  @$pb.TagNumber(30)
  $core.String get room => $_getSZ(2);
  @$pb.TagNumber(30)
  set room($core.String value) => $_setString(2, value);
  @$pb.TagNumber(30)
  $core.bool hasRoom() => $_has(2);
  @$pb.TagNumber(30)
  void clearRoom() => $_clearField(30);

  @$pb.TagNumber(40)
  $core.String get path => $_getSZ(3);
  @$pb.TagNumber(40)
  set path($core.String value) => $_setString(3, value);
  @$pb.TagNumber(40)
  $core.bool hasPath() => $_has(3);
  @$pb.TagNumber(40)
  void clearPath() => $_clearField(40);

  @$pb.TagNumber(50)
  $0.Timestamp get created => $_getN(4);
  @$pb.TagNumber(50)
  set created($0.Timestamp value) => $_setField(50, value);
  @$pb.TagNumber(50)
  $core.bool hasCreated() => $_has(4);
  @$pb.TagNumber(50)
  void clearCreated() => $_clearField(50);
  @$pb.TagNumber(50)
  $0.Timestamp ensureCreated() => $_ensure(4);

  @$pb.TagNumber(60)
  MediaType get mediaType => $_getN(5);
  @$pb.TagNumber(60)
  set mediaType(MediaType value) => $_setField(60, value);
  @$pb.TagNumber(60)
  $core.bool hasMediaType() => $_has(5);
  @$pb.TagNumber(60)
  void clearMediaType() => $_clearField(60);

  @$pb.TagNumber(70)
  $core.String get text => $_getSZ(6);
  @$pb.TagNumber(70)
  set text($core.String value) => $_setString(6, value);
  @$pb.TagNumber(70)
  $core.bool hasText() => $_has(6);
  @$pb.TagNumber(70)
  void clearText() => $_clearField(70);

  @$pb.TagNumber(80)
  $core.String get link => $_getSZ(7);
  @$pb.TagNumber(80)
  set link($core.String value) => $_setString(7, value);
  @$pb.TagNumber(80)
  $core.bool hasLink() => $_has(7);
  @$pb.TagNumber(80)
  void clearLink() => $_clearField(80);

  @$pb.TagNumber(90)
  $pb.PbList<ImageMetadata> get gallery => $_getList(8);
}

class ImageMetadata extends $pb.GeneratedMessage {
  factory ImageMetadata({
    $core.String? unsplashurl,
    $core.String? path,
    $core.String? localUrl,
    $core.int? width,
    $core.int? height,
    $core.String? caption,
    $core.String? type,
  }) {
    final result = create();
    if (unsplashurl != null) result.unsplashurl = unsplashurl;
    if (path != null) result.path = path;
    if (localUrl != null) result.localUrl = localUrl;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (caption != null) result.caption = caption;
    if (type != null) result.type = type;
    return result;
  }

  ImageMetadata._();

  factory ImageMetadata.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ImageMetadata.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImageMetadata',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'user'),
      createEmptyInstance: create)
    ..aOS(10, _omitFieldNames ? '' : 'unsplashurl')
    ..aOS(20, _omitFieldNames ? '' : 'path')
    ..aOS(30, _omitFieldNames ? '' : 'localUrl', protoName: 'localUrl')
    ..aI(40, _omitFieldNames ? '' : 'width')
    ..aI(50, _omitFieldNames ? '' : 'height')
    ..aOS(60, _omitFieldNames ? '' : 'caption')
    ..aOS(70, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImageMetadata clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImageMetadata copyWith(void Function(ImageMetadata) updates) =>
      super.copyWith((message) => updates(message as ImageMetadata))
          as ImageMetadata;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImageMetadata create() => ImageMetadata._();
  @$core.override
  ImageMetadata createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ImageMetadata getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImageMetadata>(create);
  static ImageMetadata? _defaultInstance;

  @$pb.TagNumber(10)
  $core.String get unsplashurl => $_getSZ(0);
  @$pb.TagNumber(10)
  set unsplashurl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(10)
  $core.bool hasUnsplashurl() => $_has(0);
  @$pb.TagNumber(10)
  void clearUnsplashurl() => $_clearField(10);

  @$pb.TagNumber(20)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(20)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(20)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(20)
  void clearPath() => $_clearField(20);

  @$pb.TagNumber(30)
  $core.String get localUrl => $_getSZ(2);
  @$pb.TagNumber(30)
  set localUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(30)
  $core.bool hasLocalUrl() => $_has(2);
  @$pb.TagNumber(30)
  void clearLocalUrl() => $_clearField(30);

  @$pb.TagNumber(40)
  $core.int get width => $_getIZ(3);
  @$pb.TagNumber(40)
  set width($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(40)
  $core.bool hasWidth() => $_has(3);
  @$pb.TagNumber(40)
  void clearWidth() => $_clearField(40);

  @$pb.TagNumber(50)
  $core.int get height => $_getIZ(4);
  @$pb.TagNumber(50)
  set height($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(50)
  $core.bool hasHeight() => $_has(4);
  @$pb.TagNumber(50)
  void clearHeight() => $_clearField(50);

  @$pb.TagNumber(60)
  $core.String get caption => $_getSZ(5);
  @$pb.TagNumber(60)
  set caption($core.String value) => $_setString(5, value);
  @$pb.TagNumber(60)
  $core.bool hasCaption() => $_has(5);
  @$pb.TagNumber(60)
  void clearCaption() => $_clearField(60);

  @$pb.TagNumber(70)
  $core.String get type => $_getSZ(6);
  @$pb.TagNumber(70)
  set type($core.String value) => $_setString(6, value);
  @$pb.TagNumber(70)
  $core.bool hasType() => $_has(6);
  @$pb.TagNumber(70)
  void clearType() => $_clearField(70);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
