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
    {'1': 'REQUEST', '2': 0},
    {'1': 'USER', '2': 10},
    {'1': 'INVITE', '2': 20},
    {'1': 'MODERATOR', '2': 30},
    {'1': 'ADMIN', '2': 40},
  ],
};

/// Descriptor for `Role`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roleDescriptor = $convert.base64Decode(
    'CgRSb2xlEgsKB1JFUVVFU1QQABIICgRVU0VSEAoSCgoGSU5WSVRFEBQSDQoJTU9ERVJBVE9SEB'
    '4SCQoFQURNSU4QKA==');

@$core.Deprecated('Use mediaTypeDescriptor instead')
const MediaType$json = {
  '1': 'MediaType',
  '2': [
    {'1': 'TEXT', '2': 0},
    {'1': 'FILE', '2': 10},
    {'1': 'QR', '2': 20},
    {'1': 'POST', '2': 30},
    {'1': 'GALLERY', '2': 40},
  ],
};

/// Descriptor for `MediaType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mediaTypeDescriptor = $convert.base64Decode(
    'CglNZWRpYVR5cGUSCAoEVEVYVBAAEggKBEZJTEUQChIGCgJRUhAUEggKBFBPU1QQHhILCgdHQU'
    'xMRVJZECg=');

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
    {'1': 'uid', '2': 40},
    {'1': 'nick', '2': 45},
    {'1': 'role', '2': 50},
    {'1': 'user', '2': 55},
    {'1': 'room', '2': 60},
    {'1': 'displayName', '2': 65},
    {'1': 'email', '2': 70},
    {'1': 'phoneNumber', '2': 80},
    {'1': 'photoURL', '2': 90},
    {'1': 'fcmToken', '2': 100},
    {'1': 'status', '2': 110},
    {'1': 'created', '2': 120},
    {'1': 'updated', '2': 130},
    {'1': 'timestamp', '2': 140},
    {'1': 'open', '2': 150},
    {'1': 'famous', '2': 155},
    {'1': 'members', '2': 160},
    {'1': 'tweet_count', '2': 170},
    {'1': 'description', '2': 180},
    {'1': 'gallery', '2': 190},
  ],
};

/// Descriptor for `Const`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List constDescriptor = $convert.base64Decode(
    'CgVDb25zdBIJCgV1c2VycxAAEgkKBXJvb21zEAoSCgoGdHdlZXRzEBQSDQoJcm9vbXVzZXJzEB'
    '4SBwoDdWlkECgSCAoEbmljaxAtEggKBHJvbGUQMhIICgR1c2VyEDcSCAoEcm9vbRA8Eg8KC2Rp'
    'c3BsYXlOYW1lEEESCQoFZW1haWwQRhIPCgtwaG9uZU51bWJlchBQEgwKCHBob3RvVVJMEFoSDA'
    'oIZmNtVG9rZW4QZBIKCgZzdGF0dXMQbhILCgdjcmVhdGVkEHgSDAoHdXBkYXRlZBCCARIOCgl0'
    'aW1lc3RhbXAQjAESCQoEb3BlbhCWARILCgZmYW1vdXMQmwESDAoHbWVtYmVycxCgARIQCgt0d2'
    'VldF9jb3VudBCqARIQCgtkZXNjcmlwdGlvbhC0ARIMCgdnYWxsZXJ5EL4B');

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'uid', '3': 10, '4': 1, '5': 9, '9': 0, '10': 'uid', '17': true},
    {'1': 'displayName', '3': 20, '4': 1, '5': 9, '9': 1, '10': 'displayName', '17': true},
    {'1': 'nick', '3': 30, '4': 1, '5': 9, '9': 2, '10': 'nick', '17': true},
    {'1': 'email', '3': 40, '4': 1, '5': 9, '9': 3, '10': 'email', '17': true},
    {'1': 'phoneNumber', '3': 50, '4': 1, '5': 9, '9': 4, '10': 'phoneNumber', '17': true},
    {'1': 'photoURL', '3': 60, '4': 1, '5': 9, '9': 5, '10': 'photoURL', '17': true},
    {'1': 'status', '3': 70, '4': 1, '5': 14, '6': '.user.Active', '9': 6, '10': 'status', '17': true},
    {'1': 'friends', '3': 80, '4': 3, '5': 9, '10': 'friends'},
    {'1': 'created', '3': 90, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 7, '10': 'created', '17': true},
    {'1': 'updated', '3': 100, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 8, '10': 'updated', '17': true},
    {'1': 'open', '3': 110, '4': 1, '5': 14, '6': '.user.Visible', '9': 9, '10': 'open', '17': true},
    {'1': 'admin', '3': 120, '4': 1, '5': 8, '9': 10, '10': 'admin', '17': true},
  ],
  '8': [
    {'1': '_uid'},
    {'1': '_displayName'},
    {'1': '_nick'},
    {'1': '_email'},
    {'1': '_phoneNumber'},
    {'1': '_photoURL'},
    {'1': '_status'},
    {'1': '_created'},
    {'1': '_updated'},
    {'1': '_open'},
    {'1': '_admin'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEhUKA3VpZBgKIAEoCUgAUgN1aWSIAQESJQoLZGlzcGxheU5hbWUYFCABKAlIAVILZG'
    'lzcGxheU5hbWWIAQESFwoEbmljaxgeIAEoCUgCUgRuaWNriAEBEhkKBWVtYWlsGCggASgJSANS'
    'BWVtYWlsiAEBEiUKC3Bob25lTnVtYmVyGDIgASgJSARSC3Bob25lTnVtYmVyiAEBEh8KCHBob3'
    'RvVVJMGDwgASgJSAVSCHBob3RvVVJMiAEBEikKBnN0YXR1cxhGIAEoDjIMLnVzZXIuQWN0aXZl'
    'SAZSBnN0YXR1c4gBARIYCgdmcmllbmRzGFAgAygJUgdmcmllbmRzEjkKB2NyZWF0ZWQYWiABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wSAdSB2NyZWF0ZWSIAQESOQoHdXBkYXRlZBhk'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBICFIHdXBkYXRlZIgBARImCgRvcGVuGG'
    '4gASgOMg0udXNlci5WaXNpYmxlSAlSBG9wZW6IAQESGQoFYWRtaW4YeCABKAhIClIFYWRtaW6I'
    'AQFCBgoEX3VpZEIOCgxfZGlzcGxheU5hbWVCBwoFX25pY2tCCAoGX2VtYWlsQg4KDF9waG9uZU'
    '51bWJlckILCglfcGhvdG9VUkxCCQoHX3N0YXR1c0IKCghfY3JlYXRlZEIKCghfdXBkYXRlZEIH'
    'CgVfb3BlbkIICgZfYWRtaW4=');

@$core.Deprecated('Use messagingDescriptor instead')
const Messaging$json = {
  '1': 'Messaging',
  '2': [
    {'1': 'fcmToken', '3': 10, '4': 1, '5': 9, '9': 0, '10': 'fcmToken', '17': true},
    {'1': 'timestamp', '3': 20, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 1, '10': 'timestamp', '17': true},
  ],
  '8': [
    {'1': '_fcmToken'},
    {'1': '_timestamp'},
  ],
};

/// Descriptor for `Messaging`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messagingDescriptor = $convert.base64Decode(
    'CglNZXNzYWdpbmcSHwoIZmNtVG9rZW4YCiABKAlIAFIIZmNtVG9rZW6IAQESPQoJdGltZXN0YW'
    '1wGBQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcEgBUgl0aW1lc3RhbXCIAQFCCwoJ'
    'X2ZjbVRva2VuQgwKCl90aW1lc3RhbXA=');

@$core.Deprecated('Use roomUserDescriptor instead')
const RoomUser$json = {
  '1': 'RoomUser',
  '2': [
    {'1': 'uid', '3': 10, '4': 1, '5': 9, '9': 0, '10': 'uid', '17': true},
    {'1': 'user', '3': 20, '4': 1, '5': 9, '9': 1, '10': 'user', '17': true},
    {'1': 'room', '3': 30, '4': 1, '5': 9, '9': 2, '10': 'room', '17': true},
    {'1': 'role', '3': 40, '4': 1, '5': 14, '6': '.user.Role', '9': 3, '10': 'role', '17': true},
    {'1': 'created', '3': 50, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 4, '10': 'created', '17': true},
    {'1': 'updated', '3': 60, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 5, '10': 'updated', '17': true},
    {'1': 'subscribed', '3': 70, '4': 1, '5': 8, '9': 6, '10': 'subscribed', '17': true},
  ],
  '8': [
    {'1': '_uid'},
    {'1': '_user'},
    {'1': '_room'},
    {'1': '_role'},
    {'1': '_created'},
    {'1': '_updated'},
    {'1': '_subscribed'},
  ],
};

/// Descriptor for `RoomUser`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomUserDescriptor = $convert.base64Decode(
    'CghSb29tVXNlchIVCgN1aWQYCiABKAlIAFIDdWlkiAEBEhcKBHVzZXIYFCABKAlIAVIEdXNlco'
    'gBARIXCgRyb29tGB4gASgJSAJSBHJvb22IAQESIwoEcm9sZRgoIAEoDjIKLnVzZXIuUm9sZUgD'
    'UgRyb2xliAEBEjkKB2NyZWF0ZWQYMiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wSA'
    'RSB2NyZWF0ZWSIAQESOQoHdXBkYXRlZBg8IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3Rh'
    'bXBIBVIHdXBkYXRlZIgBARIjCgpzdWJzY3JpYmVkGEYgASgISAZSCnN1YnNjcmliZWSIAQFCBg'
    'oEX3VpZEIHCgVfdXNlckIHCgVfcm9vbUIHCgVfcm9sZUIKCghfY3JlYXRlZEIKCghfdXBkYXRl'
    'ZEINCgtfc3Vic2NyaWJlZA==');

@$core.Deprecated('Use roomDescriptor instead')
const Room$json = {
  '1': 'Room',
  '2': [
    {'1': 'uid', '3': 10, '4': 1, '5': 9, '9': 0, '10': 'uid', '17': true},
    {'1': 'nick', '3': 20, '4': 1, '5': 9, '9': 1, '10': 'nick', '17': true},
    {'1': 'displayName', '3': 30, '4': 1, '5': 9, '9': 2, '10': 'displayName', '17': true},
    {'1': 'open', '3': 40, '4': 1, '5': 14, '6': '.user.Visible', '9': 3, '10': 'open', '17': true},
    {'1': 'photoURL', '3': 50, '4': 1, '5': 9, '9': 4, '10': 'photoURL', '17': true},
    {'1': 'description', '3': 60, '4': 1, '5': 9, '9': 5, '10': 'description', '17': true},
    {'1': 'created', '3': 70, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 6, '10': 'created', '17': true},
    {'1': 'updated', '3': 80, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 7, '10': 'updated', '17': true},
    {'1': 'famous', '3': 90, '4': 1, '5': 8, '9': 8, '10': 'famous', '17': true},
  ],
  '8': [
    {'1': '_uid'},
    {'1': '_nick'},
    {'1': '_displayName'},
    {'1': '_open'},
    {'1': '_photoURL'},
    {'1': '_description'},
    {'1': '_created'},
    {'1': '_updated'},
    {'1': '_famous'},
  ],
};

/// Descriptor for `Room`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomDescriptor = $convert.base64Decode(
    'CgRSb29tEhUKA3VpZBgKIAEoCUgAUgN1aWSIAQESFwoEbmljaxgUIAEoCUgBUgRuaWNriAEBEi'
    'UKC2Rpc3BsYXlOYW1lGB4gASgJSAJSC2Rpc3BsYXlOYW1liAEBEiYKBG9wZW4YKCABKA4yDS51'
    'c2VyLlZpc2libGVIA1IEb3BlbogBARIfCghwaG90b1VSTBgyIAEoCUgEUghwaG90b1VSTIgBAR'
    'IlCgtkZXNjcmlwdGlvbhg8IAEoCUgFUgtkZXNjcmlwdGlvbogBARI5CgdjcmVhdGVkGEYgASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcEgGUgdjcmVhdGVkiAEBEjkKB3VwZGF0ZWQYUC'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wSAdSB3VwZGF0ZWSIAQESGwoGZmFtb3Vz'
    'GFogASgISAhSBmZhbW91c4gBAUIGCgRfdWlkQgcKBV9uaWNrQg4KDF9kaXNwbGF5TmFtZUIHCg'
    'Vfb3BlbkILCglfcGhvdG9VUkxCDgoMX2Rlc2NyaXB0aW9uQgoKCF9jcmVhdGVkQgoKCF91cGRh'
    'dGVkQgkKB19mYW1vdXM=');

@$core.Deprecated('Use tweetDescriptor instead')
const Tweet$json = {
  '1': 'Tweet',
  '2': [
    {'1': 'uid', '3': 10, '4': 1, '5': 9, '9': 0, '10': 'uid', '17': true},
    {'1': 'user', '3': 20, '4': 1, '5': 9, '9': 1, '10': 'user', '17': true},
    {'1': 'room', '3': 30, '4': 1, '5': 9, '9': 2, '10': 'room', '17': true},
    {'1': 'path', '3': 40, '4': 1, '5': 9, '9': 3, '10': 'path', '17': true},
    {'1': 'created', '3': 50, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 4, '10': 'created', '17': true},
    {'1': 'media_type', '3': 60, '4': 1, '5': 14, '6': '.user.MediaType', '9': 5, '10': 'mediaType', '17': true},
    {'1': 'text', '3': 70, '4': 1, '5': 9, '9': 6, '10': 'text', '17': true},
    {'1': 'link', '3': 80, '4': 1, '5': 9, '9': 7, '10': 'link', '17': true},
    {'1': 'gallery', '3': 90, '4': 3, '5': 11, '6': '.user.ImageMetadata', '10': 'gallery'},
  ],
  '8': [
    {'1': '_uid'},
    {'1': '_user'},
    {'1': '_room'},
    {'1': '_path'},
    {'1': '_created'},
    {'1': '_media_type'},
    {'1': '_text'},
    {'1': '_link'},
  ],
};

/// Descriptor for `Tweet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tweetDescriptor = $convert.base64Decode(
    'CgVUd2VldBIVCgN1aWQYCiABKAlIAFIDdWlkiAEBEhcKBHVzZXIYFCABKAlIAVIEdXNlcogBAR'
    'IXCgRyb29tGB4gASgJSAJSBHJvb22IAQESFwoEcGF0aBgoIAEoCUgDUgRwYXRoiAEBEjkKB2Ny'
    'ZWF0ZWQYMiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wSARSB2NyZWF0ZWSIAQESMw'
    'oKbWVkaWFfdHlwZRg8IAEoDjIPLnVzZXIuTWVkaWFUeXBlSAVSCW1lZGlhVHlwZYgBARIXCgR0'
    'ZXh0GEYgASgJSAZSBHRleHSIAQESFwoEbGluaxhQIAEoCUgHUgRsaW5riAEBEi0KB2dhbGxlcn'
    'kYWiADKAsyEy51c2VyLkltYWdlTWV0YWRhdGFSB2dhbGxlcnlCBgoEX3VpZEIHCgVfdXNlckIH'
    'CgVfcm9vbUIHCgVfcGF0aEIKCghfY3JlYXRlZEINCgtfbWVkaWFfdHlwZUIHCgVfdGV4dEIHCg'
    'VfbGluaw==');

@$core.Deprecated('Use imageMetadataDescriptor instead')
const ImageMetadata$json = {
  '1': 'ImageMetadata',
  '2': [
    {'1': 'unsplashurl', '3': 10, '4': 1, '5': 9, '9': 0, '10': 'unsplashurl', '17': true},
    {'1': 'path', '3': 20, '4': 1, '5': 9, '9': 1, '10': 'path', '17': true},
    {'1': 'localUrl', '3': 30, '4': 1, '5': 9, '9': 2, '10': 'localUrl', '17': true},
    {'1': 'width', '3': 40, '4': 1, '5': 5, '9': 3, '10': 'width', '17': true},
    {'1': 'height', '3': 50, '4': 1, '5': 5, '9': 4, '10': 'height', '17': true},
    {'1': 'caption', '3': 60, '4': 1, '5': 9, '9': 5, '10': 'caption', '17': true},
    {'1': 'type', '3': 70, '4': 1, '5': 9, '9': 6, '10': 'type', '17': true},
  ],
  '8': [
    {'1': '_unsplashurl'},
    {'1': '_path'},
    {'1': '_localUrl'},
    {'1': '_width'},
    {'1': '_height'},
    {'1': '_caption'},
    {'1': '_type'},
  ],
};

/// Descriptor for `ImageMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageMetadataDescriptor = $convert.base64Decode(
    'Cg1JbWFnZU1ldGFkYXRhEiUKC3Vuc3BsYXNodXJsGAogASgJSABSC3Vuc3BsYXNodXJsiAEBEh'
    'cKBHBhdGgYFCABKAlIAVIEcGF0aIgBARIfCghsb2NhbFVybBgeIAEoCUgCUghsb2NhbFVybIgB'
    'ARIZCgV3aWR0aBgoIAEoBUgDUgV3aWR0aIgBARIbCgZoZWlnaHQYMiABKAVIBFIGaGVpZ2h0iA'
    'EBEh0KB2NhcHRpb24YPCABKAlIBVIHY2FwdGlvbogBARIXCgR0eXBlGEYgASgJSAZSBHR5cGWI'
    'AQFCDgoMX3Vuc3BsYXNodXJsQgcKBV9wYXRoQgsKCV9sb2NhbFVybEIICgZfd2lkdGhCCQoHX2'
    'hlaWdodEIKCghfY2FwdGlvbkIHCgVfdHlwZQ==');

