// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';

@Riverpod(keepAlive: true)
Stream<User?> currentUser(CurrentUserRef ref) {
  return FirebaseAuth.instance.authStateChanges().map(
    (User? u) {
      return u;
      // return u != null
      //     ? User(
      //         id: u.uid,
      //         nam: u.displayName,
      //         email: u.email,
      //         avatar: u.photoURL,
      //         phone: u.phoneNumber,
      //       )
      //     : null;
    },
  );
}