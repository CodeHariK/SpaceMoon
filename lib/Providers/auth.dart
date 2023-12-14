import 'package:firebase_auth/firebase_auth.dart';
import 'package:moonspace/helper/stream/functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Init/messaging.dart';

part 'auth.g.dart';

final authDebounce = createDebounceFunc(15000, (v) {
  firebaseTokenUpdate();
});

@Riverpod(keepAlive: true)
Stream<User?> currentUser(CurrentUserRef ref) {
  return FirebaseAuth.instance.idTokenChanges().map((user) {
    authDebounce.add(0);
    return user;
  });
}
