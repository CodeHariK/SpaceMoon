import 'package:spacemoon/Gen/google/protobuf/timestamp.pbserver.dart';

extension TimestampeDateTime on DateTime {
  Timestamp get timestamp => Timestamp.fromDateTime(this);
}
