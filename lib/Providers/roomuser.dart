import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/auth.dart';
import 'package:spacemoon/Providers/room.dart';

part 'roomuser.g.dart';

extension SuperRoomUser on RoomUser {
  bool get isUserOrAdmin => role == Role.ADMIN || role == Role.MODERATOR || role == Role.USER;
  bool get isAdminOrMod => role == Role.ADMIN || role == Role.MODERATOR;
  bool get isRequest => role == Role.REQUEST;
  bool get isAdmin => role == Role.ADMIN;

  CollectionReference<Tweet?>? get tweetCol {
    return FirebaseFirestore.instance.collection('${Const.rooms.name}/$room/${Const.tweets.name}').withConverter(
      fromFirestore: (snapshot, options) {
        return fromDocSnap(Tweet(), snapshot);
      },
      toFirestore: (value, options) {
        return value?.toMap() ?? {};
      },
    );
  }
}

@Riverpod(keepAlive: true)
Future<RoomUser?> currentRoomUser(CurrentRoomUserRef ref) async {
  final user = ref.watch(currentUserProvider).value;
  final room = ref.watch(currentRoomProvider).value;

  if (room == null || user == null) return null;

  final s = await FirebaseFirestore.instance
      .collection(Const.roomusers.name)
      .where('user', isEqualTo: user.uid)
      .where('room', isEqualTo: room.uid)
      .limit(1)
      .get();
  if (s.docs.isNotEmpty) {
    return fromDocSnap(RoomUser(), s.docs.first);
  }
  return null;
}

@Riverpod(keepAlive: true)
Stream<List<RoomUser?>> getAllMyRooms(GetAllMyRoomsRef ref) {
  final user = ref.watch(currentUserProvider).value;

  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection(Const.roomusers.name)
      .where('user', isEqualTo: user.uid)
      .orderBy(Const.updated.name, descending: true)
      .snapshots()
      .map((value) => value.docs.map((e) => fromQuerySnap(RoomUser(), e)).toList());
}

@Riverpod(keepAlive: true)
Stream<List<RoomUser?>> getAllRoomUsers(GetAllRoomUsersRef ref) {
  final room = ref.watch(currentRoomProvider).value;

  if (room == null) return const Stream.empty();

  final t = FirebaseFirestore.instance
      .collection(Const.roomusers.name)
      .where('room', isEqualTo: room.uid)
      .snapshots()
      .map((value) => value.docs.map((e) => fromQuerySnap(RoomUser(), e)).toList());

  return t;
}
