import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonspace/Helper/debug_functions.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:protobuf/protobuf.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/auth.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';

part 'all_chat.g.dart';

class AllChatPage extends StatelessWidget {
  const AllChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AllUsersPage();
    return AllRoomsPage();
    return Scaffold(
      appBar: AppBar(
        title: const Text('AllChat'),
      ),
      body: Wrap(
        children: [
          TextButton(
            onPressed: () {
              const ChatRoute('39dksc').go(context);
            },
            child: const Text('Chat'),
          ),
        ],
      ),
    );
  }
}

void callUserUpdate(User user) {
  FirebaseFunctions.instance.httpsCallable('callUserUpdate').call(user.toMap());
}

extension ProtoParse on GeneratedMessage {
  Map<String, dynamic>? toMap() {
    try {
      return toProto3Json() as Map<String, dynamic>;
      // return (json.decode(json.encode(toProto3Json())) as Map<String, dynamic>);
    } catch (e) {
      lava('Protobuf parsing error');
    }
    return null;
  }

  toJson() {
    return json.encode(toMap());
  }

  T merge<T extends GeneratedMessage>(T obj) {
    return (this as T)..mergeFromProto3Json(obj.toMap(), ignoreUnknownFields: true);
  }

  T mergeMap<T extends GeneratedMessage>(Map<String, dynamic>? map) {
    return (this as T)..mergeFromProto3Json(map, ignoreUnknownFields: true);
  }
}

@Riverpod(keepAlive: true)
Future<List<Room?>> getAllRooms(GetAllRoomsRef ref) async {
  List<Room?> rooms = await FirebaseFirestore.instance
      .collection(Const.rooms.name)
      // .where(Room.roomIdField, isEqualTo: user?.id)
      .get()
      .then(
        (value) => value.docs.map(
          (e) {
            // unicorn(e.toString());
            return fromQuerySnap(Room(), e);
          },
        ).toList(),
      );

  return rooms;
}

class AllRoomsPage extends ConsumerWidget {
  const AllRoomsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRooms = ref.watch(getAllRoomsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(getAllRoomsProvider);
        return 1.sec.delay();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.pest_control_rodent_outlined),
        ),
        body: allRooms.map(
          data: (rooms) {
            return Animate(
              effects: [FadeEffect()],
              child: (rooms.value.isEmpty)
                  ? Column(
                      children: [
                        // Lottie.asset(
                        //   LottieAnimation.empty.fullPath,
                        //   reverse: true,
                        //   repeat: true,
                        // ),
                        Text('Not in any rooms', style: 25.ts),
                      ],
                    )
                  : ListView.builder(
                      itemCount: rooms.value.length,
                      itemBuilder: (context, index) {
                        final room = rooms.value[index];
                        return ListTile(
                          title: Text(room?.displayName ?? 'Name'),
                          subtitle: Text(room?.nick ?? 'Nick Name'),
                          trailing: Text(room?.open.toString() ?? 'status'),
                          onTap: () async {
                            if (room != null) {
                              if (context.mounted /*&& ref.read(isUserIsInRoomProvider)*/) {
                                ChatRoute(room.uid).push(context);
                              }
                            }
                          },
                        );
                      },
                    ),
            );
          },
          error: (e) => Text(e.toString()),
          loading: (o) => Column(
            children: [
              // Lottie.asset(
              //   LottieAnimation.loading.fullPath,
              //   reverse: true,
              //   repeat: true,
              // ),
              Text('Loading...', style: 25.ts),
            ],
          ),
        ),
      ),
    );
  }
}

@riverpod
Future<List<User?>> getAllUsers(GetAllUsersRef ref) async {
  dino('Get All Users');
  ref.onDispose(() {
    lava('Dispose Get All Users');
  });
  ref.onCancel(() {
    lava('Cancel Get All Users');
  });

  return FirebaseFirestore.instance.collection(Const.users.name).get().then(
    (value) {
      return value.docs.map(
        (e) {
          return fromQuerySnap(User(), e);
        },
      ).toList();
    },
    onError: (e) {
      lava(e);
    },
  );
}

class AllUsersPage extends ConsumerWidget {
  const AllUsersPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsers = ref.watch(getAllUsersProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(getAllUsersProvider);
          return 1.sec.delay();
        },
        child: allUsers.map(
          data: (user) {
            return ListView.builder(
              itemCount: user.value.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(user.value[index]?.displayName ?? 'Name'),
                  subtitle: Text(user.value[index]?.nick ?? 'Nick Name'),
                  trailing: Text(user.value[index]?.rooms.length.toString() ?? 'Rooms'),
                  onTap: user.value[index]! == currentUser
                      ? null
                      : () async {
                          final room = await ref.read(currentRoomProvider.notifier).createRoom(
                            roomName: 'Room : ${Random().nextInt(100000)}',
                            avatar: 'avatar',
                            description: 'description',
                            users: [
                              user.value[index]!,
                            ],
                          );
                          if (context.mounted && room?.uid != null && room?.uid != '') {
                            ChatRoute(room!.uid).go(context);
                          }
                        },
                );
              },
            );
          },
          error: (e) => Text(e.toString()),
          loading: (o) => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

T? fromQuerySnap<T extends GeneratedMessage>(T obj, QueryDocumentSnapshot<Map<String, dynamic>> q) {
  if (!q.exists) return null;
  // obj.log();
  obj.mergeFromProto3Json(q.data(), ignoreUnknownFields: true);
  obj.mergeFromProto3Json({Const.uid.name: q.id}, ignoreUnknownFields: true);
  // obj.log();

  return obj;
}

T? fromDocSnap<T extends GeneratedMessage>(T obj, DocumentSnapshot<Map<String, dynamic>> doc) {
  if (!doc.exists || doc.data() == null) return null;
  // obj.log();
  obj.mergeFromProto3Json(doc.data(), ignoreUnknownFields: true);
  obj.mergeFromProto3Json({Const.uid.name: doc.id}, ignoreUnknownFields: true);
  // obj.log();

  return obj;
}

T fromMap<T extends GeneratedMessage>(T obj, Map<String, dynamic> map) {
  // obj.log();
  obj.mergeFromProto3Json(map, ignoreUnknownFields: true);
  // obj.log();

  return obj;
}
