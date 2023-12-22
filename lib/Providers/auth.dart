import 'dart:convert';

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

@Riverpod(keepAlive: true)
FutureOr<Map<String, dynamic>> currentUserToken(CurrentUserTokenRef ref) async {
  final user = ref.watch(currentUserProvider).value;

  final refreshToken = await user?.getIdToken();

  return jwtParse(refreshToken) ?? {};
}

Map<String, dynamic>? jwtParse(String? refreshToken) {
  final jwt = refreshToken?.split('.');
  if (jwt != null && jwt.length > 1) {
    String token = jwt[1];
    int l = (token.length % 4);
    token += List.generate((4 - l) % 4, (index) => '=').join();
    final decoded = base64.decode(token);
    token = utf8.decode(decoded);
    return json.decode(token) as Map<String, dynamic>;
  }
  return null;
}
