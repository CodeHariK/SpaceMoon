import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/auth.dart';
import 'package:spacemoon/Routes/Home/all_chat.dart';

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

@riverpod
class SearchText extends _$SearchText {
  @override
  String? build() {
    return null;
  }

  void change(String search) async {
    state = search;
  }
}

@riverpod
Future<List<Room?>> searchRoomByNick(SearchRoomByNickRef ref) async {
  final nick = ref.watch(searchTextProvider);

  if (nick == null || nick == '') return [];

  final rooms = await FirebaseFirestore.instance
      .collection(Const.rooms.name)
      .where(Const.nick.name, isEqualTo: nick)
      .get()
      .then((value) => value.docs.map((e) => fromQuerySnap(Room(), e)!).toList());

  return rooms;
}

Future<int> countRoomByNick(String nick) async {
  final count = await FirebaseFirestore.instance
      .collection(Const.rooms.name)
      .where(Const.nick.name, isEqualTo: nick)
      .count()
      .get()
      .then((value) => value.count);

  return count;
}

@Riverpod(keepAlive: true)
Stream<Room?> getRoomById(GetRoomByIdRef ref, String roomId) {
  Stream<Room?>? room = FirebaseFirestore.instance
      .collection(Const.rooms.name)
      .doc(roomId)
      .snapshots()
      .map((event) => fromDocSnap(Room(), event));
  return room;
}

@riverpod
Future<int?> getNewTweetCount(GetNewTweetCountRef ref, RoomUser user) async {
  return await user.tweetCol
      ?.where(
        Const.created.name,
        isGreaterThan: user.updated.isoDate,
      )
      .count()
      .get()
      .then((value) {
    return value.count;
  }).catchError((e, s) {
    lava(e);
    lava(s);
    return 0;
  });
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
      await FirebaseFirestore.instance
          .collection(
            Const.rooms.name,
          )
          .doc(id)
          .get()
          .then((value) {
        state = AsyncValue.data(fromDocSnap(Room(), value));
      }).onError((error, stackTrace) => lava(error));
    }
  }

  void exitRoom(RoomUser? roomUser) {
    lava('Room Exited');

    if (roomUser != null) {
      try {
        FirebaseFunctions.instance.httpsCallable('updateRoomUserTime').call(roomUser.toMap());
      } catch (e) {
        debugPrint('updateRoomUserTime Failed');
      }
    }

    state = const AsyncValue.data(null);
  }

  Future<void> updateRoomInfo(Room room) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('updateRoomInfo').call(room.toMap());
    } catch (e) {
      debugPrint('updateRoomInfo Failed');
    }
    return;
  }

  Future<Room?> createRoom({
    required Room room,
    required List<String> users,
  }) async {
    try {
      final roomId = (await FirebaseFunctions.instance.httpsCallable('callCreateRoom').call(
        {
          'room': room.toMap(),
          'users': users,
        },
      ))
          .data as String;

      return Room(uid: roomId);
    } catch (e) {
      debugPrint('callCreateRoom Failed');
    }
    return null;
  }

  Future<void> requestAccessToRoom() async {
    final room = state.value;
    try {
      await FirebaseFunctions.instance.httpsCallable('requestAccessToRoom').call(RoomUser(room: room?.uid).toMap());
    } catch (e) {
      debugPrint('requestAccessToRoom Failed');
    }
    ref.invalidate(currentRoomUserProvider);
  }

  Future<void> acceptAccessToRoom(RoomUser user) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('acceptAccessToRoom').call(user.toMap());
    } catch (e) {
      debugPrint('acceptAccessToRoom Failed');
    }
    ref.invalidate(currentRoomUserProvider);
  }

  Future<void> deleteRoom(RoomUser user) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('deleteRoom').call(user.toMap());
    } catch (e) {
      debugPrint('deleteRoom Failed');
    }
    exitRoom(user);
    ref.invalidate(currentRoomUserProvider);
  }

  Future<void> deleteRoomUser(RoomUser user) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('deleteRoomUser').call(user.toMap());
    } catch (e) {
      debugPrint('deleteRoomUser Failed');
    }
  }
}
