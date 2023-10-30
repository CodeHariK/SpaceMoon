//
//  Generated code. Do not modify.
//  source: user.proto
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

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'id', '3': 100, '4': 1, '5': 9, '10': 'id'},
    {'1': 'nam', '3': 200, '4': 1, '5': 9, '10': 'nam'},
    {'1': 'nick', '3': 210, '4': 1, '5': 9, '10': 'nick'},
    {'1': 'email', '3': 300, '4': 1, '5': 9, '10': 'email'},
    {'1': 'phone', '3': 400, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'avatar', '3': 500, '4': 1, '5': 9, '10': 'avatar'},
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
    'CgRVc2VyEg4KAmlkGGQgASgJUgJpZBIRCgNuYW0YyAEgASgJUgNuYW0SEwoEbmljaxjSASABKA'
    'lSBG5pY2sSFQoFZW1haWwYrAIgASgJUgVlbWFpbBIVCgVwaG9uZRiQAyABKAlSBXBob25lEhcK'
    'BmF2YXRhchj0AyABKAlSBmF2YXRhchIlCgZzdGF0dXMY2AQgASgOMgwudXNlci5BY3RpdmVSBn'
    'N0YXR1cxIVCgVyb29tcxi8BSADKAlSBXJvb21zEiEKC3Jvb21SZXF1ZXN0GKAGIAMoCVILcm9v'
    'bVJlcXVlc3QSGQoHY3JlYXRlZBiEByABKAlSB2NyZWF0ZWQSIgoEb3BlbhjoByABKA4yDS51c2'
    'VyLlZpc2libGVSBG9wZW4SGwoIZmNtVG9rZW4YzAggASgJUghmY21Ub2tlbg==');

