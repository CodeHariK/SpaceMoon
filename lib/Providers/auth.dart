import 'package:firebase_auth/firebase_auth.dart';
import 'package:moonspace/helper/stream/functions.dart';
import 'package:moonspace/helper/extensions/string.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Init/messaging.dart';

part 'auth.g.dart';

final authDebounce = createDebounceFunc(15000, (v) {
  firebaseTokenUpdate();
});

@Riverpod(keepAlive: true)
Stream<User?> currentUser(Ref ref) {
  return FirebaseAuth.instance.idTokenChanges().map((user) {
    authDebounce.add(0);
    return user;
  });
}

@Riverpod(keepAlive: true)
FutureOr<Map<String, dynamic>> currentUserToken(Ref ref) async {
  final user = ref.watch(currentUserProvider).value;

  final refreshToken = await user?.getIdToken();

  return decodeJWT(refreshToken) ?? {};
}
