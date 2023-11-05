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
    $core.Iterable<$core.String>? rooms,
    $core.Iterable<$core.String>? friends,
    $core.Iterable<$core.String>? roomRequest,
    $0.Timestamp? created,
    Visible? open,
    $core.String? fcmToken,
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
    if (rooms != null) {
      $result.rooms.addAll(rooms);
    }
    if (friends != null) {
      $result.friends.addAll(friends);
    }
    if (roomRequest != null) {
      $result.roomRequest.addAll(roomRequest);
    }
    if (created != null) {
      $result.created = created;
    }
    if (open != null) {
      $result.open = open;
    }
    if (fcmToken != null) {
      $result.fcmToken = fcmToken;
    }
    return $result;
  }
  User._() : super();
  factory User.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'User', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..aOS(100, _omitFieldNames ? '' : 'uid')
    ..aOS(200, _omitFieldNames ? '' : 'displayName', protoName: 'displayName')
    ..aOS(210, _omitFieldNames ? '' : 'nick')
    ..aOS(300, _omitFieldNames ? '' : 'email')
    ..aOS(400, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..aOS(500, _omitFieldNames ? '' : 'photoURL', protoName: 'photoURL')
    ..e<Active>(600, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: Active.OFFLINE, valueOf: Active.valueOf, enumValues: Active.values)
    ..pPS(700, _omitFieldNames ? '' : 'rooms')
    ..pPS(750, _omitFieldNames ? '' : 'friends')
    ..pPS(800, _omitFieldNames ? '' : 'roomRequest', protoName: 'roomRequest')
    ..aOM<$0.Timestamp>(900, _omitFieldNames ? '' : 'created', subBuilder: $0.Timestamp.create)
    ..e<Visible>(1000, _omitFieldNames ? '' : 'open', $pb.PbFieldType.OE, defaultOrMaker: Visible.CLOSE, valueOf: Visible.valueOf, enumValues: Visible.values)
    ..aOS(1100, _omitFieldNames ? '' : 'fcmToken', protoName: 'fcmToken')
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

  @$pb.TagNumber(210)
  $core.String get nick => $_getSZ(2);
  @$pb.TagNumber(210)
  set nick($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(210)
  $core.bool hasNick() => $_has(2);
  @$pb.TagNumber(210)
  void clearNick() => clearField(210);

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
  $core.List<$core.String> get rooms => $_getList(7);

  @$pb.TagNumber(750)
  $core.List<$core.String> get friends => $_getList(8);

  @$pb.TagNumber(800)
  $core.List<$core.String> get roomRequest => $_getList(9);

  /// repeated string rooms = 8 [json_name = "dinosaur"];
  /// int32 level = 9;
  @$pb.TagNumber(900)
  $0.Timestamp get created => $_getN(10);
  @$pb.TagNumber(900)
  set created($0.Timestamp v) { setField(900, v); }
  @$pb.TagNumber(900)
  $core.bool hasCreated() => $_has(10);
  @$pb.TagNumber(900)
  void clearCreated() => clearField(900);
  @$pb.TagNumber(900)
  $0.Timestamp ensureCreated() => $_ensure(10);

  @$pb.TagNumber(1000)
  Visible get open => $_getN(11);
  @$pb.TagNumber(1000)
  set open(Visible v) { setField(1000, v); }
  @$pb.TagNumber(1000)
  $core.bool hasOpen() => $_has(11);
  @$pb.TagNumber(1000)
  void clearOpen() => clearField(1000);

  /// -------------------
  @$pb.TagNumber(1100)
  $core.String get fcmToken => $_getSZ(12);
  @$pb.TagNumber(1100)
  set fcmToken($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(1100)
  $core.bool hasFcmToken() => $_has(12);
  @$pb.TagNumber(1100)
  void clearFcmToken() => clearField(1100);
}

class RoomUser extends $pb.GeneratedMessage {
  factory RoomUser({
    $core.String? uid,
    $core.String? user,
    $core.String? room,
    Role? role,
    $0.Timestamp? created,
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
    return $result;
  }
  RoomUser._() : super();
  factory RoomUser.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoomUser.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoomUser', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uid')
    ..aOS(2, _omitFieldNames ? '' : 'user')
    ..aOS(3, _omitFieldNames ? '' : 'room')
    ..e<Role>(10, _omitFieldNames ? '' : 'role', $pb.PbFieldType.OE, defaultOrMaker: Role.BLOCKED, valueOf: Role.valueOf, enumValues: Role.values)
    ..aOM<$0.Timestamp>(20, _omitFieldNames ? '' : 'created', subBuilder: $0.Timestamp.create)
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
}

class Room extends $pb.GeneratedMessage {
  factory Room({
    $core.String? uid,
    $core.String? nick,
    $core.String? displayName,
    $core.String? photoURL,
    $core.String? description,
    $0.Timestamp? created,
    Visible? open,
    $core.int? activeCount,
    $core.int? totalCount,
    $core.int? tweetCount,
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
    if (open != null) {
      $result.open = open;
    }
    if (activeCount != null) {
      $result.activeCount = activeCount;
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    if (tweetCount != null) {
      $result.tweetCount = tweetCount;
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
    ..e<Visible>(50, _omitFieldNames ? '' : 'open', $pb.PbFieldType.OE, defaultOrMaker: Visible.CLOSE, valueOf: Visible.valueOf, enumValues: Visible.values)
    ..a<$core.int>(60, _omitFieldNames ? '' : 'activeCount', $pb.PbFieldType.O3, protoName: 'activeCount')
    ..a<$core.int>(70, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3, protoName: 'totalCount')
    ..a<$core.int>(80, _omitFieldNames ? '' : 'tweetCount', $pb.PbFieldType.O3, protoName: 'tweetCount')
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
  Visible get open => $_getN(6);
  @$pb.TagNumber(50)
  set open(Visible v) { setField(50, v); }
  @$pb.TagNumber(50)
  $core.bool hasOpen() => $_has(6);
  @$pb.TagNumber(50)
  void clearOpen() => clearField(50);

  @$pb.TagNumber(60)
  $core.int get activeCount => $_getIZ(7);
  @$pb.TagNumber(60)
  set activeCount($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(60)
  $core.bool hasActiveCount() => $_has(7);
  @$pb.TagNumber(60)
  void clearActiveCount() => clearField(60);

  @$pb.TagNumber(70)
  $core.int get totalCount => $_getIZ(8);
  @$pb.TagNumber(70)
  set totalCount($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(70)
  $core.bool hasTotalCount() => $_has(8);
  @$pb.TagNumber(70)
  void clearTotalCount() => clearField(70);

  @$pb.TagNumber(80)
  $core.int get tweetCount => $_getIZ(9);
  @$pb.TagNumber(80)
  set tweetCount($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(80)
  $core.bool hasTweetCount() => $_has(9);
  @$pb.TagNumber(80)
  void clearTweetCount() => clearField(80);
}

class Tweet extends $pb.GeneratedMessage {
  factory Tweet({
    $core.String? uid,
    $core.String? user,
    $core.String? room,
    $0.Timestamp? created,
    MediaType? mediaType,
    $core.String? text,
    $core.String? link,
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
    return $result;
  }
  Tweet._() : super();
  factory Tweet.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Tweet.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Tweet', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uid')
    ..aOS(10, _omitFieldNames ? '' : 'user')
    ..aOS(20, _omitFieldNames ? '' : 'room')
    ..aOM<$0.Timestamp>(30, _omitFieldNames ? '' : 'created', subBuilder: $0.Timestamp.create)
    ..e<MediaType>(40, _omitFieldNames ? '' : 'mediaType', $pb.PbFieldType.OE, defaultOrMaker: MediaType.TEXT, valueOf: MediaType.valueOf, enumValues: MediaType.values)
    ..aOS(50, _omitFieldNames ? '' : 'text')
    ..aOS(60, _omitFieldNames ? '' : 'link')
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
  $0.Timestamp get created => $_getN(3);
  @$pb.TagNumber(30)
  set created($0.Timestamp v) { setField(30, v); }
  @$pb.TagNumber(30)
  $core.bool hasCreated() => $_has(3);
  @$pb.TagNumber(30)
  void clearCreated() => clearField(30);
  @$pb.TagNumber(30)
  $0.Timestamp ensureCreated() => $_ensure(3);

  @$pb.TagNumber(40)
  MediaType get mediaType => $_getN(4);
  @$pb.TagNumber(40)
  set mediaType(MediaType v) { setField(40, v); }
  @$pb.TagNumber(40)
  $core.bool hasMediaType() => $_has(4);
  @$pb.TagNumber(40)
  void clearMediaType() => clearField(40);

  @$pb.TagNumber(50)
  $core.String get text => $_getSZ(5);
  @$pb.TagNumber(50)
  set text($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(50)
  $core.bool hasText() => $_has(5);
  @$pb.TagNumber(50)
  void clearText() => clearField(50);

  @$pb.TagNumber(60)
  $core.String get link => $_getSZ(6);
  @$pb.TagNumber(60)
  set link($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(60)
  $core.bool hasLink() => $_has(6);
  @$pb.TagNumber(60)
  void clearLink() => clearField(60);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
