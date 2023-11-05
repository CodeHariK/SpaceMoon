import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:moonspace/Helper/debug_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/auth.dart';

part 'room.g.dart';

extension SuperRoom on Room {
  DocumentReference<Room?> get roomDoc {
    return FirebaseFirestore.instance.collection(Const.rooms.name).doc(uid).withConverter(
      fromFirestore: (snapshot, options) {
        return fromDocSnap(Room(), snapshot);
      },
      toFirestore: (value, options) {
        return value?.toMap() ?? {};
      },
    );
  }

  CollectionReference<Tweet?>? get tweetCol {
    return FirebaseFirestore.instance.collection('${Const.rooms.name}/$uid/${Const.tweets.name}').withConverter(
      fromFirestore: (snapshot, options) {
        return fromDocSnap(Tweet(), snapshot);
      },
      toFirestore: (value, options) {
        return value?.toMap() ?? {};
      },
    );
  }
}

@riverpod
class RoomText extends _$RoomText {
  @override
  Future<String?> build() async {
    return null;
  }

  Future<void> change(String roomId) async {
    state = await AsyncValue.guard(() async {
      return roomId;
    });
  }
}

@riverpod
Future<List<Room>?> getRoom(GetRoomRef ref) async {
  final roomId = ref.watch(roomTextProvider).value;

  if (roomId == null || roomId == '') return null;

  List<Room>? room = await FirebaseFirestore.instance
      .collection(Const.rooms.name)
      .where(Const.nick.name, isEqualTo: roomId)
      .get()
      .then(
    (value) {
      return value.docs.map((e) => fromQuerySnap(Room(), e)!).toList();
    },
  );
  return room;
}

@Riverpod(keepAlive: true)
Future<Room?> getRoomById(GetRoomByIdRef ref, String roomId) async {
  Room? room = await FirebaseFirestore.instance
      .collection(Const.rooms.name)
      .doc(roomId)
      .get()
      .then((value) => fromDocSnap(Room(), value));
  return room;
}

// @riverpod
// FutureOr<int> allRoomUserCount(AllRoomUserCountRef ref) async {
//   final room = ref.watch(currentRoomProvider).value;

//   if (room == null) return 0;

//   final uu = await FirebaseFirestore.instance
//       .collection(Const.roomusers.name)
//       .where('room', isEqualTo: room.uid)
//       .count()
//       .get();

//   return uu.count;
// }

@Riverpod(keepAlive: true)
Stream<List<RoomUser?>> getAllMyUsers(GetAllMyUsersRef ref) {
  final room = ref.watch(currentRoomProvider).value;

  if (room == null) return const Stream.empty();

  final t = FirebaseFirestore.instance
      .collection(Const.roomusers.name)
      .where('room', isEqualTo: room.uid)
      .snapshots()
      .map((value) => value.docs.map((e) => fromQuerySnap(RoomUser(), e)).toList());

  return t;
}

@Riverpod(keepAlive: true)
Stream<List<RoomUser?>> getAllMyRooms(GetAllMyRoomsRef ref) {
  final user = ref.watch(currentUserProvider).value;

  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection(Const.roomusers.name)
      .where('user', isEqualTo: user.uid)
      .snapshots()
      .map((value) => value.docs.map((e) => fromQuerySnap(RoomUser(), e)).toList());
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
Stream<Room?> roomStream(RoomStreamRef ref) {
  final room = ref.watch(currentRoomProvider).value;
  final roomDoc = room?.roomDoc;
  if (room != null && roomDoc != null) {
    return roomDoc.snapshots().map((event) {
      if (ref.read(currentRoomProvider).value != event.data()) {
        ref.read(currentRoomProvider.notifier).updateRoom(room: event.data());
      }
      return event.data();
    });
  } else {
    return const Stream.empty();
  }
}

@Riverpod(keepAlive: true)
class CurrentRoom extends _$CurrentRoom {
  @override
  Future<Room?> build() async {
    return null;
  }

  void updateRoom({Room? room, String? id}) async {
    //
    if (room != null && room != state.value) {
      state = AsyncValue.data(room);
    }
    //
    else if (id != null && id != state.value?.uid) {
      final room = await FirebaseFirestore.instance
          .collection(
            Const.rooms.name,
          )
          .doc(id)
          .get();
      state = AsyncValue.data(fromDocSnap(Room(), room));
    }
    //
    // else if (state.value != null) {
    //   final room = await FirebaseFirestore.instance
    //       .collection(
    //         Const.rooms.name,
    //       )
    //       .doc(state.value!.uid)
    //       .get();
    //   state = AsyncValue.data(fromDocSnap(Room(), room));
    // }
  }

  void exitRoom() {
    lava('Room Exited');
    state = const AsyncValue.data(null);
  }

  Future<Room?> createRoom({
    required Room room,
    required List<String> users,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final roomId = (await FirebaseFunctions.instance.httpsCallable('callCreateRoom').call(
        {
          'room': room.toMap(),
          'users': users,
        },
      ))
          .data as String;

      return Room(uid: roomId);
    });
    return state.value;
  }

  Future<void> requestAccessToRoom() async {
    final room = state.value;
    await FirebaseFunctions.instance.httpsCallable('requestAccessToRoom').call(RoomUser(room: room?.uid).toMap());
    ref.invalidate(currentRoomUserProvider);
  }

  void acceptAccessToRoom(RoomUser user) async {
    await FirebaseFunctions.instance.httpsCallable('acceptAccessToRoom').call(user.toMap());
    ref.invalidate(currentRoomUserProvider);
  }

  void deleteRoomUser(RoomUser user) async {
    await FirebaseFunctions.instance.httpsCallable('deleteRoomUser').call(user.toMap());
    ref.invalidate(currentRoomUserProvider);
  }
}

extension SuperRoomUser on RoomUser {
  bool get isUserOrAdmin => role == Role.ADMIN || role == Role.MODERATOR || role == Role.USER;
  bool get isAdminOrMod => role == Role.ADMIN || role == Role.MODERATOR;
  bool get isRequest => role == Role.REQUEST;
}
