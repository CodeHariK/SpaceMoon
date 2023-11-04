//
//  Generated code. Do not modify.
//  source: data.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use roleDescriptor instead')
const Role$json = {
  '1': 'Role',
  '2': [
    {'1': 'BLOCKED', '2': 0},
    {'1': 'REQUEST', '2': 10},
    {'1': 'USER', '2': 20},
    {'1': 'MODERATOR', '2': 30},
    {'1': 'ADMIN', '2': 40},
  ],
};

/// Descriptor for `Role`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roleDescriptor = $convert.base64Decode(
    'CgRSb2xlEgsKB0JMT0NLRUQQABILCgdSRVFVRVNUEAoSCAoEVVNFUhAUEg0KCU1PREVSQVRPUh'
    'AeEgkKBUFETUlOECg=');

@$core.Deprecated('Use mediaTypeDescriptor instead')
const MediaType$json = {
  '1': 'MediaType',
  '2': [
    {'1': 'TEXT', '2': 0},
    {'1': 'IMAGE', '2': 5},
    {'1': 'VIDEO', '2': 10},
    {'1': 'AUDIO', '2': 15},
    {'1': 'PDF', '2': 20},
    {'1': 'FILE', '2': 30},
    {'1': 'QR', '2': 35},
  ],
};

/// Descriptor for `MediaType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mediaTypeDescriptor = $convert.base64Decode(
    'CglNZWRpYVR5cGUSCAoEVEVYVBAAEgkKBUlNQUdFEAUSCQoFVklERU8QChIJCgVBVURJTxAPEg'
    'cKA1BERhAUEggKBEZJTEUQHhIGCgJRUhAj');

@$core.Deprecated('Use activeDescriptor instead')
const Active$json = {
  '1': 'Active',
  '2': [
    {'1': 'OFFLINE', '2': 0},
    {'1': 'ONLINE', '2': 10},
    {'1': 'TYPING', '2': 20},
  ],
};

/// Descriptor for `Active`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List activeDescriptor = $convert.base64Decode(
    'CgZBY3RpdmUSCwoHT0ZGTElORRAAEgoKBk9OTElORRAKEgoKBlRZUElORxAU');

@$core.Deprecated('Use visibleDescriptor instead')
const Visible$json = {
  '1': 'Visible',
  '2': [
    {'1': 'CLOSE', '2': 0},
    {'1': 'MODERATED', '2': 10},
    {'1': 'OPEN', '2': 20},
  ],
};

/// Descriptor for `Visible`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List visibleDescriptor = $convert.base64Decode(
    'CgdWaXNpYmxlEgkKBUNMT1NFEAASDQoJTU9ERVJBVEVEEAoSCAoET1BFThAU');

@$core.Deprecated('Use constDescriptor instead')
const Const$json = {
  '1': 'Const',
  '2': [
    {'1': 'users', '2': 0},
    {'1': 'rooms', '2': 10},
    {'1': 'tweets', '2': 20},
    {'1': 'roomusers', '2': 30},
    {'1': 'uid', '2': 100},
    {'1': 'nick', '2': 110},
    {'1': 'displayName', '2': 150},
    {'1': 'email', '2': 200},
    {'1': 'phoneNumber', '2': 250},
    {'1': 'photoURL', '2': 300},
    {'1': 'fcmToken', '2': 350},
    {'1': 'status', '2': 400},
    {'1': 'created', '2': 600},
    {'1': 'open', '2': 700},
    {'1': 'members', '2': 800},
    {'1': 'tweet_count', '2': 900},
    {'1': 'description', '2': 1000},
  ],
};

/// Descriptor for `Const`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List constDescriptor = $convert.base64Decode(
    'CgVDb25zdBIJCgV1c2VycxAAEgkKBXJvb21zEAoSCgoGdHdlZXRzEBQSDQoJcm9vbXVzZXJzEB'
    '4SBwoDdWlkEGQSCAoEbmljaxBuEhAKC2Rpc3BsYXlOYW1lEJYBEgoKBWVtYWlsEMgBEhAKC3Bo'
    'b25lTnVtYmVyEPoBEg0KCHBob3RvVVJMEKwCEg0KCGZjbVRva2VuEN4CEgsKBnN0YXR1cxCQAx'
    'IMCgdjcmVhdGVkENgEEgkKBG9wZW4QvAUSDAoHbWVtYmVycxCgBhIQCgt0d2VldF9jb3VudBCE'
    'BxIQCgtkZXNjcmlwdGlvbhDoBw==');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'uid', '3': 100, '4': 1, '5': 9, '10': 'uid'},
    {'1': 'displayName', '3': 200, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'nick', '3': 210, '4': 1, '5': 9, '10': 'nick'},
    {'1': 'email', '3': 300, '4': 1, '5': 9, '10': 'email'},
    {'1': 'phoneNumber', '3': 400, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'photoURL', '3': 500, '4': 1, '5': 9, '10': 'photoURL'},
    {'1': 'status', '3': 600, '4': 1, '5': 14, '6': '.user.Active', '10': 'status'},
    {'1': 'rooms', '3': 700, '4': 3, '5': 9, '10': 'rooms'},
    {'1': 'friends', '3': 750, '4': 3, '5': 9, '10': 'friends'},
    {'1': 'roomRequest', '3': 800, '4': 3, '5': 9, '10': 'roomRequest'},
    {'1': 'created', '3': 900, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'created'},
    {'1': 'open', '3': 1000, '4': 1, '5': 14, '6': '.user.Visible', '10': 'open'},
    {'1': 'fcmToken', '3': 1100, '4': 1, '5': 9, '10': 'fcmToken'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEhAKA3VpZBhkIAEoCVIDdWlkEiEKC2Rpc3BsYXlOYW1lGMgBIAEoCVILZGlzcGxheU'
    '5hbWUSEwoEbmljaxjSASABKAlSBG5pY2sSFQoFZW1haWwYrAIgASgJUgVlbWFpbBIhCgtwaG9u'
    'ZU51bWJlchiQAyABKAlSC3Bob25lTnVtYmVyEhsKCHBob3RvVVJMGPQDIAEoCVIIcGhvdG9VUk'
    'wSJQoGc3RhdHVzGNgEIAEoDjIMLnVzZXIuQWN0aXZlUgZzdGF0dXMSFQoFcm9vbXMYvAUgAygJ'
    'UgVyb29tcxIZCgdmcmllbmRzGO4FIAMoCVIHZnJpZW5kcxIhCgtyb29tUmVxdWVzdBigBiADKA'
    'lSC3Jvb21SZXF1ZXN0EjUKB2NyZWF0ZWQYhAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVz'
    'dGFtcFIHY3JlYXRlZBIiCgRvcGVuGOgHIAEoDjINLnVzZXIuVmlzaWJsZVIEb3BlbhIbCghmY2'
    '1Ub2tlbhjMCCABKAlSCGZjbVRva2Vu');

@$core.Deprecated('Use roomUserDescriptor instead')
const RoomUser$json = {
  '1': 'RoomUser',
  '2': [
    {'1': 'uid', '3': 1, '4': 1, '5': 9, '10': 'uid'},
    {'1': 'user', '3': 2, '4': 1, '5': 9, '10': 'user'},
    {'1': 'room', '3': 3, '4': 1, '5': 9, '10': 'room'},
    {'1': 'role', '3': 10, '4': 1, '5': 14, '6': '.user.Role', '10': 'role'},
    {'1': 'created', '3': 20, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'created'},
  ],
};

/// Descriptor for `RoomUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomUserDescriptor = $convert.base64Decode(
    'CghSb29tVXNlchIQCgN1aWQYASABKAlSA3VpZBISCgR1c2VyGAIgASgJUgR1c2VyEhIKBHJvb2'
    '0YAyABKAlSBHJvb20SHgoEcm9sZRgKIAEoDjIKLnVzZXIuUm9sZVIEcm9sZRI0CgdjcmVhdGVk'
    'GBQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHY3JlYXRlZA==');

@$core.Deprecated('Use roomDescriptor instead')
const Room$json = {
  '1': 'Room',
  '2': [
    {'1': 'uid', '3': 1, '4': 1, '5': 9, '10': 'uid'},
    {'1': 'nick', '3': 2, '4': 1, '5': 9, '10': 'nick'},
    {'1': 'displayName', '3': 10, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'photoURL', '3': 20, '4': 1, '5': 9, '10': 'photoURL'},
    {'1': 'description', '3': 30, '4': 1, '5': 9, '10': 'description'},
    {'1': 'members', '3': 40, '4': 3, '5': 11, '6': '.user.RoomUser', '10': 'members'},
    {'1': 'created', '3': 50, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'created'},
    {'1': 'open', '3': 60, '4': 1, '5': 14, '6': '.user.Visible', '10': 'open'},
    {'1': 'tweet_count', '3': 70, '4': 1, '5': 5, '10': 'tweetCount'},
  ],
};

/// Descriptor for `Room`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomDescriptor = $convert.base64Decode(
    'CgRSb29tEhAKA3VpZBgBIAEoCVIDdWlkEhIKBG5pY2sYAiABKAlSBG5pY2sSIAoLZGlzcGxheU'
    '5hbWUYCiABKAlSC2Rpc3BsYXlOYW1lEhoKCHBob3RvVVJMGBQgASgJUghwaG90b1VSTBIgCgtk'
    'ZXNjcmlwdGlvbhgeIAEoCVILZGVzY3JpcHRpb24SKAoHbWVtYmVycxgoIAMoCzIOLnVzZXIuUm'
    '9vbVVzZXJSB21lbWJlcnMSNAoHY3JlYXRlZBgyIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1l'
    'c3RhbXBSB2NyZWF0ZWQSIQoEb3Blbhg8IAEoDjINLnVzZXIuVmlzaWJsZVIEb3BlbhIfCgt0d2'
    'VldF9jb3VudBhGIAEoBVIKdHdlZXRDb3VudA==');

@$core.Deprecated('Use tweetDescriptor instead')
const Tweet$json = {
  '1': 'Tweet',
  '2': [
    {'1': 'uid', '3': 1, '4': 1, '5': 9, '10': 'uid'},
    {'1': 'user', '3': 10, '4': 1, '5': 9, '10': 'user'},
    {'1': 'room', '3': 20, '4': 1, '5': 9, '10': 'room'},
    {'1': 'created', '3': 30, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'created'},
    {'1': 'media_type', '3': 40, '4': 1, '5': 14, '6': '.user.MediaType', '10': 'mediaType'},
    {'1': 'text', '3': 50, '4': 1, '5': 9, '10': 'text'},
    {'1': 'link', '3': 60, '4': 1, '5': 9, '10': 'link'},
  ],
};

/// Descriptor for `Tweet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tweetDescriptor = $convert.base64Decode(
    'CgVUd2VldBIQCgN1aWQYASABKAlSA3VpZBISCgR1c2VyGAogASgJUgR1c2VyEhIKBHJvb20YFC'
    'ABKAlSBHJvb20SNAoHY3JlYXRlZBgeIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'B2NyZWF0ZWQSLgoKbWVkaWFfdHlwZRgoIAEoDjIPLnVzZXIuTWVkaWFUeXBlUgltZWRpYVR5cG'
    'USEgoEdGV4dBgyIAEoCVIEdGV4dBISCgRsaW5rGDwgASgJUgRsaW5r');

