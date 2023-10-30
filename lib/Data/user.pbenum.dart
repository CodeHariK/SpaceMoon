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


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
