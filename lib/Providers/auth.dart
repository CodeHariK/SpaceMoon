import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Gen/data.pbserver.dart' as data;
import 'package:spacemoon/Gen/google/protobuf/timestamp.pb.dart';

part 'auth.g.dart';

@Riverpod(keepAlive: true)
Stream<data.User?> currentUser(CurrentUserRef ref) {
  return FirebaseAuth.instance.authStateChanges().map(
    (User? u) {
      return u != null
          ? data.User(
              uid: u.uid,
              displayName: u.displayName,
              email: u.email,
              photoURL: u.photoURL,
              phoneNumber: u.phoneNumber,
              created: Timestamp.fromDateTime(u.metadata.creationTime ?? DateTime.now()))
          : null;
    },
  );
}
