import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/auth.dart';

part 'user_data.g.dart';

@Riverpod(keepAlive: true)
Stream<User?> currentUserData(CurrentUserDataRef ref) {
  final user = ref.watch(currentUserProvider).value;
  return FirebaseFirestore.instance.collection(Const.users.name).doc(user?.uid).snapshots().map(
        (snapshot) => fromDocSnap(User(), snapshot),
      );
}
