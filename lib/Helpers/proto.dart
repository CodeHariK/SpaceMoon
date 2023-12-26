import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:protobuf/protobuf.dart';
import 'package:spacemoon/Gen/data.pbenum.dart';
import 'package:spacemoon/Gen/google/protobuf/timestamp.pbserver.dart' as time;

extension TimestampeDateTime on DateTime {
  time.Timestamp get timestamp => time.Timestamp.fromDateTime(this);
}

extension SupetTimeStamp on time.Timestamp {
  DateTime get date => toDateTime().toLocal();
  // String get isoDate => toDateTime().toLocal().toIso8601String();
  String get isoDate => toDateTime().toIso8601String();
  String get timeString => hasSeconds() ? DateFormat.jm().format(toDateTime().toLocal()) : '';
  String get dateString => hasSeconds() ? DateFormat.yMMMd().format(toDateTime().toLocal()) : '';
}

extension ProtoParse on GeneratedMessage {
  Map<String, dynamic>? toMap() {
    try {
      return toProto3Json() as Map<String, dynamic>;
      // return (json.decode(json.encode(toProto3Json())) as Map<String, dynamic>);
    } catch (e) {
      lava('Protobuf parsing error');
    }
    return null;
  }

  toJson() {
    return json.encode(toMap());
  }

  T merge<T extends GeneratedMessage>(T obj) {
    return (this as T)..mergeFromProto3Json(obj.toMap(), ignoreUnknownFields: true);
  }

  T mergeMap<T extends GeneratedMessage>(Map<String, dynamic>? map) {
    return (this as T)..mergeFromProto3Json(map, ignoreUnknownFields: true);
  }
}

T? fromQuerySnap<T extends GeneratedMessage>(T obj, QueryDocumentSnapshot<Map<String, dynamic>> q) {
  if (!q.exists) return null;
  // obj.log();
  obj.mergeFromProto3Json(q.data(), ignoreUnknownFields: true);
  obj.mergeFromProto3Json({Const.uid.name: q.id}, ignoreUnknownFields: true);
  // obj.log();

  return obj;
}

T? fromDocSnap<T extends GeneratedMessage>(T obj, DocumentSnapshot<Map<String, dynamic>> doc) {
  if (!doc.exists || doc.data() == null) return null;
  // obj.log();
  obj.mergeFromProto3Json(doc.data(), ignoreUnknownFields: true);
  obj.mergeFromProto3Json({Const.uid.name: doc.id}, ignoreUnknownFields: true);
  // obj.log();

  return obj;
}

T fromMap<T extends GeneratedMessage>(T obj, Map<String, dynamic> map) {
  // obj.log();
  obj.mergeFromProto3Json(map, ignoreUnknownFields: true);
  // obj.log();

  return obj;
}
