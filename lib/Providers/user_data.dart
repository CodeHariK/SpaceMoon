import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as f;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/auth.dart';
import 'package:spacemoon/Providers/room.dart';

part 'user_data.g.dart';

@Riverpod(keepAlive: true)
Stream<User?> currentUserData(CurrentUserDataRef ref) {
  final user = ref.watch(currentUserProvider).value;

  return FirebaseFirestore.instance.collection(Const.users.name).doc(user?.uid).snapshots().map((snapshot) {
    final userData = fromDocSnap(User(), snapshot);

    if (userData == null || userData.uid != user?.uid) {
      f.FirebaseAuth.instance.signOut();
    }
    return userData;
  });
}

@riverpod
Future<User?> searchUserByNick(SearchUserByNickRef ref) async {
  final nick = ref.watch(searchTextProvider);

  if (nick == null || nick.isEmpty) return null;

  final users = await FirebaseFirestore.instance
      .collection(Const.users.name)
      .where(Const.nick.name, isEqualTo: nick)
      .get()
      .then((value) => value.docs.map((e) => fromQuerySnap(User(), e)!).toList());

  return users.firstOrNull;
}

@Riverpod(keepAlive: true)
Future<User?> getUserById(GetUserByIdRef ref, String userId) async {
  User? user = await FirebaseFirestore.instance
      .collection(Const.users.name)
      .doc(userId)
      .get()
      .then((value) => fromDocSnap(User(), value));
  return user;
}

Future<int> countUserByNick(String nick) async {
  final count = await FirebaseFirestore.instance
      .collection(Const.users.name)
      .where(Const.nick.name, isEqualTo: nick)
      .count()
      .get()
      .then((value) => value.count);

  return count;
}

void callUserUpdate(User user) {
  FirebaseFunctions.instance.httpsCallable('callUserUpdate').call(user.toMap());
}
