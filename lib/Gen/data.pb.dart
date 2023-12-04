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

import 'data.pbenum.dart';
import 'google/protobuf/timestamp.pb.dart' as $0;

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
    $core.Iterable<$core.String>? friends,
    $0.Timestamp? created,
    Visible? open,
  }) {
    final $result = create();
    if (uid != null) {
      $result.uid = uid;
    }
    if (displayName != null) {
      $result.displayName = displayName;
    }
    if (nick != null) {
      $result.nick = nick;
    }
    if (email != null) {
      $result.email = email;
    }
    if (phoneNumber != null) {
      $result.phoneNumber = phoneNumber;
    }
    if (photoURL != null) {
      $result.photoURL = photoURL;
    }
    if (status != null) {
      $result.status = status;
    }
    if (friends != null) {
      $result.friends.addAll(friends);
    }
    if (created != null) {
      $result.created = created;
    }
    if (open != null) {
      $result.open = open;
    }
    return $result;
  }
  User._() : super();
  factory User.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'User', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..aOS(100, _omitFieldNames ? '' : 'uid')
    ..aOS(200, _omitFieldNames ? '' : 'displayName', protoName: 'displayName')
    ..aOS(250, _omitFieldNames ? '' : 'nick')
    ..aOS(300, _omitFieldNames ? '' : 'email')
    ..aOS(400, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..aOS(500, _omitFieldNames ? '' : 'photoURL', protoName: 'photoURL')
    ..e<Active>(600, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: Active.INVALIDACTIVE, valueOf: Active.valueOf, enumValues: Active.values)
    ..pPS(700, _omitFieldNames ? '' : 'friends')
    ..aOM<$0.Timestamp>(800, _omitFieldNames ? '' : 'created', subBuilder: $0.Timestamp.create)
    ..e<Visible>(900, _omitFieldNames ? '' : 'open', $pb.PbFieldType.OE, defaultOrMaker: Visible.INVALIDVISIBLE, valueOf: Visible.valueOf, enumValues: Visible.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  User clone() => User()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  User copyWith(void Function(User) updates) => super.copyWith((message) => updates(message as User)) as User;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

  @$pb.TagNumber(100)
  $core.String get uid => $_getSZ(0);
  @$pb.TagNumber(100)
  set uid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(100)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(100)
  void clearUid() => clearField(100);

  @$pb.TagNumber(200)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(200)
  set displayName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(200)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(200)
  void clearDisplayName() => clearField(200);

  @$pb.TagNumber(250)
  $core.String get nick => $_getSZ(2);
  @$pb.TagNumber(250)
  set nick($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(250)
  $core.bool hasNick() => $_has(2);
  @$pb.TagNumber(250)
  void clearNick() => clearField(250);

  @$pb.TagNumber(300)
  $core.String get email => $_getSZ(3);
  @$pb.TagNumber(300)
  set email($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(300)
  $core.bool hasEmail() => $_has(3);
  @$pb.TagNumber(300)
  void clearEmail() => clearField(300);

  @$pb.TagNumber(400)
  $core.String get phoneNumber => $_getSZ(4);
  @$pb.TagNumber(400)
  set phoneNumber($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(400)
  $core.bool hasPhoneNumber() => $_has(4);
  @$pb.TagNumber(400)
  void clearPhoneNumber() => clearField(400);

  @$pb.TagNumber(500)
  $core.String get photoURL => $_getSZ(5);
  @$pb.TagNumber(500)
  set photoURL($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(500)
  $core.bool hasPhotoURL() => $_has(5);
  @$pb.TagNumber(500)
  void clearPhotoURL() => clearField(500);

  @$pb.TagNumber(600)
  Active get status => $_getN(6);
  @$pb.TagNumber(600)
  set status(Active v) { setField(600, v); }
  @$pb.TagNumber(600)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(600)
  void clearStatus() => clearField(600);

  @$pb.TagNumber(700)
  $core.List<$core.String> get friends => $_getList(7);

  @$pb.TagNumber(800)
  $0.Timestamp get created => $_getN(8);
  @$pb.TagNumber(800)
  set created($0.Timestamp v) { setField(800, v); }
  @$pb.TagNumber(800)
  $core.bool hasCreated() => $_has(8);
  @$pb.TagNumber(800)
  void clearCreated() => clearField(800);
  @$pb.TagNumber(800)
  $0.Timestamp ensureCreated() => $_ensure(8);

  @$pb.TagNumber(900)
  Visible get open => $_getN(9);
  @$pb.TagNumber(900)
  set open(Visible v) { setField(900, v); }
  @$pb.TagNumber(900)
  $core.bool hasOpen() => $_has(9);
  @$pb.TagNumber(900)
  void clearOpen() => clearField(900);
}

class UserClaims extends $pb.GeneratedMessage {
  factory UserClaims({
    $core.String? fcmToken,
  }) {
    final $result = create();
    if (fcmToken != null) {
      $result.fcmToken = fcmToken;
    }
    return $result;
  }
  UserClaims._() : super();
  factory UserClaims.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserClaims.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserClaims', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..aOS(100, _omitFieldNames ? '' : 'fcmToken', protoName: 'fcmToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserClaims clone() => UserClaims()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserClaims copyWith(void Function(UserClaims) updates) => super.copyWith((message) => updates(message as UserClaims)) as UserClaims;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserClaims create() => UserClaims._();
  UserClaims createEmptyInstance() => create();
  static $pb.PbList<UserClaims> createRepeated() => $pb.PbList<UserClaims>();
  @$core.pragma('dart2js:noInline')
  static UserClaims getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserClaims>(create);
  static UserClaims? _defaultInstance;

  @$pb.TagNumber(100)
  $core.String get fcmToken => $_getSZ(0);
  @$pb.TagNumber(100)
  set fcmToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(100)
  $core.bool hasFcmToken() => $_has(0);
  @$pb.TagNumber(100)
  void clearFcmToken() => clearField(100);
}

class RoomUser extends $pb.GeneratedMessage {
  factory RoomUser({
    $core.String? uid,
    $core.String? user,
    $core.String? room,
    Role? role,
    $0.Timestamp? created,
    $0.Timestamp? updated,
  }) {
    final $result = create();
    if (uid != null) {
      $result.uid = uid;
    }
    if (user != null) {
      $result.user = user;
    }
    if (room != null) {
      $result.room = room;
    }
    if (role != null) {
      $result.role = role;
    }
    if (created != null) {
      $result.created = created;
    }
    if (updated != null) {
      $result.updated = updated;
    }
    return $result;
  }
  RoomUser._() : super();
  factory RoomUser.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoomUser.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoomUser', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uid')
    ..aOS(2, _omitFieldNames ? '' : 'user')
    ..aOS(3, _omitFieldNames ? '' : 'room')
    ..e<Role>(10, _omitFieldNames ? '' : 'role', $pb.PbFieldType.OE, defaultOrMaker: Role.INVALIDROLE, valueOf: Role.valueOf, enumValues: Role.values)
    ..aOM<$0.Timestamp>(20, _omitFieldNames ? '' : 'created', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(30, _omitFieldNames ? '' : 'updated', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoomUser clone() => RoomUser()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoomUser copyWith(void Function(RoomUser) updates) => super.copyWith((message) => updates(message as RoomUser)) as RoomUser;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomUser create() => RoomUser._();
  RoomUser createEmptyInstance() => create();
  static $pb.PbList<RoomUser> createRepeated() => $pb.PbList<RoomUser>();
  @$core.pragma('dart2js:noInline')
  static RoomUser getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomUser>(create);
  static RoomUser? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get user => $_getSZ(1);
  @$pb.TagNumber(2)
  set user($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get room => $_getSZ(2);
  @$pb.TagNumber(3)
  set room($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRoom() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoom() => clearField(3);

  @$pb.TagNumber(10)
  Role get role => $_getN(3);
  @$pb.TagNumber(10)
  set role(Role v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(10)
  void clearRole() => clearField(10);

  @$pb.TagNumber(20)
  $0.Timestamp get created => $_getN(4);
  @$pb.TagNumber(20)
  set created($0.Timestamp v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasCreated() => $_has(4);
  @$pb.TagNumber(20)
  void clearCreated() => clearField(20);
  @$pb.TagNumber(20)
  $0.Timestamp ensureCreated() => $_ensure(4);

  @$pb.TagNumber(30)
  $0.Timestamp get updated => $_getN(5);
  @$pb.TagNumber(30)
  set updated($0.Timestamp v) { setField(30, v); }
  @$pb.TagNumber(30)
  $core.bool hasUpdated() => $_has(5);
  @$pb.TagNumber(30)
  void clearUpdated() => clearField(30);
  @$pb.TagNumber(30)
  $0.Timestamp ensureUpdated() => $_ensure(5);
}

class Room extends $pb.GeneratedMessage {
  factory Room({
    $core.String? uid,
    $core.String? nick,
    $core.String? displayName,
    $core.String? photoURL,
    $core.String? description,
    $0.Timestamp? created,
    $0.Timestamp? updated,
    Visible? open,
  }) {
    final $result = create();
    if (uid != null) {
      $result.uid = uid;
    }
    if (nick != null) {
      $result.nick = nick;
    }
    if (displayName != null) {
      $result.displayName = displayName;
    }
    if (photoURL != null) {
      $result.photoURL = photoURL;
    }
    if (description != null) {
      $result.description = description;
    }
    if (created != null) {
      $result.created = created;
    }
    if (updated != null) {
      $result.updated = updated;
    }
    if (open != null) {
      $result.open = open;
    }
    return $result;
  }
  Room._() : super();
  factory Room.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Room.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Room', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uid')
    ..aOS(2, _omitFieldNames ? '' : 'nick')
    ..aOS(10, _omitFieldNames ? '' : 'displayName', protoName: 'displayName')
    ..aOS(20, _omitFieldNames ? '' : 'photoURL', protoName: 'photoURL')
    ..aOS(30, _omitFieldNames ? '' : 'description')
    ..aOM<$0.Timestamp>(40, _omitFieldNames ? '' : 'created', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(50, _omitFieldNames ? '' : 'updated', subBuilder: $0.Timestamp.create)
    ..e<Visible>(60, _omitFieldNames ? '' : 'open', $pb.PbFieldType.OE, defaultOrMaker: Visible.INVALIDVISIBLE, valueOf: Visible.valueOf, enumValues: Visible.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Room clone() => Room()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Room copyWith(void Function(Room) updates) => super.copyWith((message) => updates(message as Room)) as Room;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Room create() => Room._();
  Room createEmptyInstance() => create();
  static $pb.PbList<Room> createRepeated() => $pb.PbList<Room>();
  @$core.pragma('dart2js:noInline')
  static Room getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Room>(create);
  static Room? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get nick => $_getSZ(1);
  @$pb.TagNumber(2)
  set nick($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNick() => $_has(1);
  @$pb.TagNumber(2)
  void clearNick() => clearField(2);

  @$pb.TagNumber(10)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(10)
  set displayName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(10)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(10)
  void clearDisplayName() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get photoURL => $_getSZ(3);
  @$pb.TagNumber(20)
  set photoURL($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(20)
  $core.bool hasPhotoURL() => $_has(3);
  @$pb.TagNumber(20)
  void clearPhotoURL() => clearField(20);

  @$pb.TagNumber(30)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(30)
  set description($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(30)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(30)
  void clearDescription() => clearField(30);

  @$pb.TagNumber(40)
  $0.Timestamp get created => $_getN(5);
  @$pb.TagNumber(40)
  set created($0.Timestamp v) { setField(40, v); }
  @$pb.TagNumber(40)
  $core.bool hasCreated() => $_has(5);
  @$pb.TagNumber(40)
  void clearCreated() => clearField(40);
  @$pb.TagNumber(40)
  $0.Timestamp ensureCreated() => $_ensure(5);

  @$pb.TagNumber(50)
  $0.Timestamp get updated => $_getN(6);
  @$pb.TagNumber(50)
  set updated($0.Timestamp v) { setField(50, v); }
  @$pb.TagNumber(50)
  $core.bool hasUpdated() => $_has(6);
  @$pb.TagNumber(50)
  void clearUpdated() => clearField(50);
  @$pb.TagNumber(50)
  $0.Timestamp ensureUpdated() => $_ensure(6);

  @$pb.TagNumber(60)
  Visible get open => $_getN(7);
  @$pb.TagNumber(60)
  set open(Visible v) { setField(60, v); }
  @$pb.TagNumber(60)
  $core.bool hasOpen() => $_has(7);
  @$pb.TagNumber(60)
  void clearOpen() => clearField(60);
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
    final $result = create();
    if (uid != null) {
      $result.uid = uid;
    }
    if (user != null) {
      $result.user = user;
    }
    if (room != null) {
      $result.room = room;
    }
    if (path != null) {
      $result.path = path;
    }
    if (created != null) {
      $result.created = created;
    }
    if (mediaType != null) {
      $result.mediaType = mediaType;
    }
    if (text != null) {
      $result.text = text;
    }
    if (link != null) {
      $result.link = link;
    }
    if (gallery != null) {
      $result.gallery.addAll(gallery);
    }
    return $result;
  }
  Tweet._() : super();
  factory Tweet.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Tweet.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Tweet', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uid')
    ..aOS(10, _omitFieldNames ? '' : 'user')
    ..aOS(20, _omitFieldNames ? '' : 'room')
    ..aOS(30, _omitFieldNames ? '' : 'path')
    ..aOM<$0.Timestamp>(40, _omitFieldNames ? '' : 'created', subBuilder: $0.Timestamp.create)
    ..e<MediaType>(50, _omitFieldNames ? '' : 'mediaType', $pb.PbFieldType.OE, defaultOrMaker: MediaType.INVALIDMEDIATYPE, valueOf: MediaType.valueOf, enumValues: MediaType.values)
    ..aOS(60, _omitFieldNames ? '' : 'text')
    ..aOS(70, _omitFieldNames ? '' : 'link')
    ..pc<ImageMetadata>(80, _omitFieldNames ? '' : 'gallery', $pb.PbFieldType.PM, subBuilder: ImageMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Tweet clone() => Tweet()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Tweet copyWith(void Function(Tweet) updates) => super.copyWith((message) => updates(message as Tweet)) as Tweet;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Tweet create() => Tweet._();
  Tweet createEmptyInstance() => create();
  static $pb.PbList<Tweet> createRepeated() => $pb.PbList<Tweet>();
  @$core.pragma('dart2js:noInline')
  static Tweet getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tweet>(create);
  static Tweet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uid => $_getSZ(0);
  @$pb.TagNumber(1)
  set uid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => clearField(1);

  @$pb.TagNumber(10)
  $core.String get user => $_getSZ(1);
  @$pb.TagNumber(10)
  set user($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(10)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(10)
  void clearUser() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get room => $_getSZ(2);
  @$pb.TagNumber(20)
  set room($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(20)
  $core.bool hasRoom() => $_has(2);
  @$pb.TagNumber(20)
  void clearRoom() => clearField(20);

  @$pb.TagNumber(30)
  $core.String get path => $_getSZ(3);
  @$pb.TagNumber(30)
  set path($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(30)
  $core.bool hasPath() => $_has(3);
  @$pb.TagNumber(30)
  void clearPath() => clearField(30);

  @$pb.TagNumber(40)
  $0.Timestamp get created => $_getN(4);
  @$pb.TagNumber(40)
  set created($0.Timestamp v) { setField(40, v); }
  @$pb.TagNumber(40)
  $core.bool hasCreated() => $_has(4);
  @$pb.TagNumber(40)
  void clearCreated() => clearField(40);
  @$pb.TagNumber(40)
  $0.Timestamp ensureCreated() => $_ensure(4);

  @$pb.TagNumber(50)
  MediaType get mediaType => $_getN(5);
  @$pb.TagNumber(50)
  set mediaType(MediaType v) { setField(50, v); }
  @$pb.TagNumber(50)
  $core.bool hasMediaType() => $_has(5);
  @$pb.TagNumber(50)
  void clearMediaType() => clearField(50);

  @$pb.TagNumber(60)
  $core.String get text => $_getSZ(6);
  @$pb.TagNumber(60)
  set text($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(60)
  $core.bool hasText() => $_has(6);
  @$pb.TagNumber(60)
  void clearText() => clearField(60);

  @$pb.TagNumber(70)
  $core.String get link => $_getSZ(7);
  @$pb.TagNumber(70)
  set link($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(70)
  $core.bool hasLink() => $_has(7);
  @$pb.TagNumber(70)
  void clearLink() => clearField(70);

  @$pb.TagNumber(80)
  $core.List<ImageMetadata> get gallery => $_getList(8);
}

class ImageMetadata extends $pb.GeneratedMessage {
  factory ImageMetadata({
    $core.String? url,
    $core.String? path,
    $core.String? localUrl,
    $core.int? width,
    $core.int? height,
    $core.String? caption,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    if (path != null) {
      $result.path = path;
    }
    if (localUrl != null) {
      $result.localUrl = localUrl;
    }
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (caption != null) {
      $result.caption = caption;
    }
    return $result;
  }
  ImageMetadata._() : super();
  factory ImageMetadata.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ImageMetadata.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ImageMetadata', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(10, _omitFieldNames ? '' : 'path')
    ..aOS(20, _omitFieldNames ? '' : 'localUrl', protoName: 'localUrl')
    ..a<$core.int>(30, _omitFieldNames ? '' : 'width', $pb.PbFieldType.O3)
    ..a<$core.int>(40, _omitFieldNames ? '' : 'height', $pb.PbFieldType.O3)
    ..aOS(50, _omitFieldNames ? '' : 'caption')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ImageMetadata clone() => ImageMetadata()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ImageMetadata copyWith(void Function(ImageMetadata) updates) => super.copyWith((message) => updates(message as ImageMetadata)) as ImageMetadata;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImageMetadata create() => ImageMetadata._();
  ImageMetadata createEmptyInstance() => create();
  static $pb.PbList<ImageMetadata> createRepeated() => $pb.PbList<ImageMetadata>();
  @$core.pragma('dart2js:noInline')
  static ImageMetadata getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImageMetadata>(create);
  static ImageMetadata? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);

  @$pb.TagNumber(10)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(10)
  set path($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(10)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(10)
  void clearPath() => clearField(10);

  @$pb.TagNumber(20)
  $core.String get localUrl => $_getSZ(2);
  @$pb.TagNumber(20)
  set localUrl($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(20)
  $core.bool hasLocalUrl() => $_has(2);
  @$pb.TagNumber(20)
  void clearLocalUrl() => clearField(20);

  @$pb.TagNumber(30)
  $core.int get width => $_getIZ(3);
  @$pb.TagNumber(30)
  set width($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(30)
  $core.bool hasWidth() => $_has(3);
  @$pb.TagNumber(30)
  void clearWidth() => clearField(30);

  @$pb.TagNumber(40)
  $core.int get height => $_getIZ(4);
  @$pb.TagNumber(40)
  set height($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(40)
  $core.bool hasHeight() => $_has(4);
  @$pb.TagNumber(40)
  void clearHeight() => clearField(40);

  @$pb.TagNumber(50)
  $core.String get caption => $_getSZ(5);
  @$pb.TagNumber(50)
  set caption($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(50)
  $core.bool hasCaption() => $_has(5);
  @$pb.TagNumber(50)
  void clearCaption() => clearField(50);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
