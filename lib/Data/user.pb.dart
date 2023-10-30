//
//  Generated code. Do not modify.
//  source: user.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'user.pbenum.dart';

export 'user.pbenum.dart';

class User extends $pb.GeneratedMessage {
  factory User({
    $core.String? id,
    $core.String? nam,
    $core.String? nick,
    $core.String? email,
    $core.String? phone,
    $core.String? avatar,
    Active? status,
    $core.Iterable<$core.String>? rooms,
    $core.Iterable<$core.String>? roomRequest,
    $core.String? created,
    Visible? open,
    $core.String? fcmToken,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (nam != null) {
      $result.nam = nam;
    }
    if (nick != null) {
      $result.nick = nick;
    }
    if (email != null) {
      $result.email = email;
    }
    if (phone != null) {
      $result.phone = phone;
    }
    if (avatar != null) {
      $result.avatar = avatar;
    }
    if (status != null) {
      $result.status = status;
    }
    if (rooms != null) {
      $result.rooms.addAll(rooms);
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
    ..aOS(100, _omitFieldNames ? '' : 'id')
    ..aOS(200, _omitFieldNames ? '' : 'nam')
    ..aOS(210, _omitFieldNames ? '' : 'nick')
    ..aOS(300, _omitFieldNames ? '' : 'email')
    ..aOS(400, _omitFieldNames ? '' : 'phone')
    ..aOS(500, _omitFieldNames ? '' : 'avatar')
    ..e<Active>(600, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: Active.OFFLINE, valueOf: Active.valueOf, enumValues: Active.values)
    ..pPS(700, _omitFieldNames ? '' : 'rooms')
    ..pPS(800, _omitFieldNames ? '' : 'roomRequest', protoName: 'roomRequest')
    ..aOS(900, _omitFieldNames ? '' : 'created')
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
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(100)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(100)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(100)
  void clearId() => clearField(100);

  @$pb.TagNumber(200)
  $core.String get nam => $_getSZ(1);
  @$pb.TagNumber(200)
  set nam($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(200)
  $core.bool hasNam() => $_has(1);
  @$pb.TagNumber(200)
  void clearNam() => clearField(200);

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
  $core.String get phone => $_getSZ(4);
  @$pb.TagNumber(400)
  set phone($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(400)
  $core.bool hasPhone() => $_has(4);
  @$pb.TagNumber(400)
  void clearPhone() => clearField(400);

  @$pb.TagNumber(500)
  $core.String get avatar => $_getSZ(5);
  @$pb.TagNumber(500)
  set avatar($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(500)
  $core.bool hasAvatar() => $_has(5);
  @$pb.TagNumber(500)
  void clearAvatar() => clearField(500);

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

  @$pb.TagNumber(800)
  $core.List<$core.String> get roomRequest => $_getList(8);

  /// repeated string rooms = 8 [json_name = "dinosaur"];
  /// int32 level = 9;
  @$pb.TagNumber(900)
  $core.String get created => $_getSZ(9);
  @$pb.TagNumber(900)
  set created($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(900)
  $core.bool hasCreated() => $_has(9);
  @$pb.TagNumber(900)
  void clearCreated() => clearField(900);

  /// google.protobuf.Timestamp updatedAt = 11;
  @$pb.TagNumber(1000)
  Visible get open => $_getN(10);
  @$pb.TagNumber(1000)
  set open(Visible v) { setField(1000, v); }
  @$pb.TagNumber(1000)
  $core.bool hasOpen() => $_has(10);
  @$pb.TagNumber(1000)
  void clearOpen() => clearField(1000);

  /// -------------------
  @$pb.TagNumber(1100)
  $core.String get fcmToken => $_getSZ(11);
  @$pb.TagNumber(1100)
  set fcmToken($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(1100)
  $core.bool hasFcmToken() => $_has(11);
  @$pb.TagNumber(1100)
  void clearFcmToken() => clearField(1100);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
