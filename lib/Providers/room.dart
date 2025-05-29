import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/main.dart';

part 'room.g.dart';

extension SuperRoom on Room {
  DocumentReference<Room?> get roomDoc {
    return FirebaseFirestore.instance
        .collection(Const.rooms.name)
        .doc(uid)
        .withConverter(
      fromFirestore: (snapshot, options) {
        return fromDocSnap(Room(), snapshot);
      },
      toFirestore: (value, options) {
        return value?.toMap() ?? {};
      },
    );
  }

  CollectionReference<Tweet?>? get tweetCol {
    return FirebaseFirestore.instance
        .collection('${Const.rooms.name}/$uid/${Const.tweets.name}')
        .withConverter(
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
Future<List<Room?>> searchRoomByNick(Ref ref) async {
  final nick = ref.watch(searchTextProvider);

  if (nick == null || nick == '') return [];

  return getRoomByNick(nick);
}

@riverpod
FutureOr<List<Room?>> searchFamousRooms(Ref ref) async {
  final rooms = await FirebaseFirestore.instance
      .collection(Const.rooms.name)
      .where(Const.famous.name, isEqualTo: true)
      .orderBy(Const.updated.name, descending: true)
      .limit(10)
      .get()
      .then(
          (value) => value.docs.map((e) => fromQuerySnap(Room(), e)!).toList());

  return rooms;
}

Future<List<Room?>> getRoomByNick(String nick) async {
  final rooms = await FirebaseFirestore.instance
      .collection(Const.rooms.name)
      .where(Const.nick.name, isEqualTo: nick)
      .get()
      .then(
          (value) => value.docs.map((e) => fromQuerySnap(Room(), e)!).toList());

  return rooms;
}

Future<int?> countRoomByNick(String nick) async {
  final count = await FirebaseFirestore.instance
      .collection(Const.rooms.name)
      .where(Const.nick.name, isEqualTo: nick)
      .count()
      .get()
      .then((value) => value.count);

  return count;
}

@Riverpod(keepAlive: true)
Stream<Room?> getRoomById(Ref ref, String roomId) {
  Stream<Room?>? room = FirebaseFirestore.instance
      .collection(Const.rooms.name)
      .doc(roomId)
      .snapshots()
      .map((event) => fromDocSnap(Room(), event))
      .handleError((error) => null);
  return room;
}

@Riverpod(keepAlive: true)
Stream<Room?> roomStream(Ref ref) {
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
      final idDoc = await FirebaseFirestore.instance
          .collection(
            Const.rooms.name,
          )
          .doc(id)
          .get();

      if (idDoc.exists) {
        state = AsyncValue.data(fromDocSnap(Room(), idDoc));
      } else {
        final nickRooms = await getRoomByNick(id);

        if (nickRooms.firstOrNull != null) {
          state = AsyncValue.data(nickRooms.first);
        } else {
          lava('No Room Found');
        }
      }
    }
  }

  void exitRoom(RoomUser? roomUser) {
    lava('Room Exited');

    if (roomUser != null) {
      try {
        SpaceMoon.httpCallable('roomuser-updateRoomUserTime')
            .call(roomUser.toMap());
      } catch (e) {
        debugPrint('updateRoomUserTime Failed');
      }
    }

    state = const AsyncValue.data(null);
  }

  Future<void> updateRoomInfo(Room room) async {
    try {
      await SpaceMoon.httpCallable('room-updateRoomInfo').call(room.toMap());
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
      final roomId = (await SpaceMoon.httpCallable('room-callCreateRoom').call(
        {
          'room': room.toMap(),
          'users': users,
        },
      ))
          .data as String;

      return Room(uid: roomId);
    } catch (e) {
      debugPrint('callCreateRoom Failed');
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> upgradeAccessToRoom(RoomUser user) async {
    try {
      await SpaceMoon.httpCallable('roomuser-upgradeAccessToRoom')
          .call(user.toMap());
    } catch (e) {
      debugPrint('upgradeAccessToRoom Failed');
    }
  }

  Future<void> deleteRoom(RoomUser user) async {
    try {
      await SpaceMoon.httpCallable('room-deleteRoom').call(user.toMap());
      exitRoom(user);
    } catch (e) {
      debugPrint('deleteRoom Failed $e');
    }
  }

  Future<void> reportRoom(RoomUser user, Set<String> reason) async {
    try {
      await SpaceMoon.httpCallable('room-reportRoom').call(
          user.toMap()?..addEntries([MapEntry('reason', reason.toList())]));
      exitRoom(user);
    } catch (e) {
      debugPrint('reportRoom Failed $e');
    }
  }

  Future<void> deleteRoomUser(RoomUser user) async {
    try {
      await SpaceMoon.httpCallable('roomuser-deleteRoomUser')
          .call(user.toMap());
    } catch (e) {
      debugPrint('deleteRoomUser Failed');
    }
  }
}
