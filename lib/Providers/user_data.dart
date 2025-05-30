import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/auth.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/main.dart';

part 'user_data.g.dart';

@Riverpod(keepAlive: true)
Stream<User?> currentUserData(Ref ref) {
  final user = ref.watch(currentUserProvider).value;

  if (user?.uid == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection(Const.users.name)
      .doc(user?.uid)
      .snapshots()
      .map((snapshot) {
    final userData = fromDocSnap(User(), snapshot);

    // if (userData == null || userData.uid != user?.uid) {
    //   print('');
    //   print('Sign Out');
    //   print(userData);
    //   print(user);
    //   print('');
    //   f.FirebaseAuth.instance.signOut();
    // }
    return userData;
  });
}

@riverpod
Future<List<User?>> searchUserByNick(Ref ref) async {
  final nick = ref.watch(searchTextProvider);

  if (nick == null || nick.isEmpty) return [];

  final users = await FirebaseFirestore.instance
      .collection(Const.users.name)
      .where(Const.nick.name, isEqualTo: nick)
      .get()
      .then(
          (value) => value.docs.map((e) => fromQuerySnap(User(), e)!).toList());

  return users;
}

Future<int?> countUserByNick(String nick) async {
  final count = await FirebaseFirestore.instance
      .collection(Const.users.name)
      .where(Const.nick.name, isEqualTo: nick)
      .count()
      .get()
      .then((value) => value.count);

  return count;
}

@Riverpod(keepAlive: true)
Stream<User?> getUserById(Ref ref, String userId) {
  return FirebaseFirestore.instance
      .collection(Const.users.name)
      .doc(userId)
      .snapshots()
      .map((value) => fromDocSnap(User(), value));
}

Future<void> callUserUpdate(User user) async {
  try {
    await SpaceMoon.httpCallable('user-callUserUpdate').call(user.toMap());
  } catch (e) {
    debugPrint('callUserUpdate Failed');
  }
}

Future<void> reportUser(User user, Set<String> reason) async {
  try {
    await SpaceMoon.httpCallable('user-reportUser')
        .call(user.toMap()?..addEntries([MapEntry('reason', reason.toList())]));
  } catch (e) {
    debugPrint('reportRoom Failed $e');
  }
}
