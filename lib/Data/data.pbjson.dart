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
    {'1': 'uid', '2': 100},
    {'1': 'nick', '2': 110},
    {'1': 'displayName', '2': 150},
    {'1': 'email', '2': 200},
    {'1': 'phoneNumber', '2': 250},
    {'1': 'photoURL', '2': 350},
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
    'CgVDb25zdBIJCgV1c2VycxAAEgkKBXJvb21zEAoSCgoGdHdlZXRzEBQSBwoDdWlkEGQSCAoEbm'
    'ljaxBuEhAKC2Rpc3BsYXlOYW1lEJYBEgoKBWVtYWlsEMgBEhAKC3Bob25lTnVtYmVyEPoBEg0K'
    'CHBob3RvVVJMEN4CEgsKBnN0YXR1cxCQAxIMCgdjcmVhdGVkENgEEgkKBG9wZW4QvAUSDAoHbW'
    'VtYmVycxCgBhIQCgt0d2VldF9jb3VudBCEBxIQCgtkZXNjcmlwdGlvbhDoBw==');

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
    {'1': 'roomRequest', '3': 800, '4': 3, '5': 9, '10': 'roomRequest'},
    {'1': 'created', '3': 900, '4': 1, '5': 9, '10': 'created'},
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
    'UgVyb29tcxIhCgtyb29tUmVxdWVzdBigBiADKAlSC3Jvb21SZXF1ZXN0EhkKB2NyZWF0ZWQYhA'
    'cgASgJUgdjcmVhdGVkEiIKBG9wZW4Y6AcgASgOMg0udXNlci5WaXNpYmxlUgRvcGVuEhsKCGZj'
    'bVRva2VuGMwIIAEoCVIIZmNtVG9rZW4=');

