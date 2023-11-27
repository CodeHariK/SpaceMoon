import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Init/messaging.dart';

part 'auth.g.dart';

@Riverpod(keepAlive: true)
Stream<User?> currentUser(CurrentUserRef ref) {
  return FirebaseAuth.instance.idTokenChanges().map((user) {
    firebaseTokenUpdate();
    return user;
  });
}
