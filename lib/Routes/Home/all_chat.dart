import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moonspace/helper/extensions/string.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/widgets/animated/animated_counter.dart';
import 'package:moonspace/widgets/shimmer_boxes.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Gen/google/protobuf/timestamp.pb.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';

extension SupetTimeStamp on Timestamp {
  DateTime get date => toDateTime().toLocal();
  String get isoDate => toDateTime().toLocal().toIso8601String();
  String get timeString => hasSeconds() ? DateFormat.jm().format(toDateTime().toLocal()) : '';
  String get dateString => hasSeconds() ? DateFormat.yMMMd().format(toDateTime().toLocal()) : '';
}

class AllChatPage extends ConsumerWidget {
  const AllChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRoomsUsers = ref.watch(getAllMyRoomsProvider);

    return Scaffold(
      body: Center(
        child: allRoomsUsers.when(
          data: (roomUser) {
            return Animate(
              effects: const [FadeEffect()],
              child: (roomUser.isEmpty)
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
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
                      itemBuilder: (context, index) {
                        return Consumer(builder: (context, ref, child) {
                          final room = ref.watch(GetRoomByIdProvider(roomUser[index]!.room)).value;
                          if (room == null) return const SizedBox.shrink();

                          final count = ref.watch(GetNewTweetCountProvider(roomUser[index]!)).value;

                          return ListTile(
                            title: Text(room.displayName),
                            subtitle: Text(room.nick),
                            leading: CircleAvatar(
                              child: CustomCacheImage(
                                imageUrl: spaceThumbImage(room.photoURL),
                                radius: 32,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(room.updated.timeString),
                                const SizedBox(width: 10),
                                AnimatedFlipCounter(
                                  value: (count == null) ? 0 : min(99, count),
                                  wholeDigits: 1,
                                  duration: const Duration(seconds: 1),
                                ),
                              ],
                            ),
                            onTap: () {
                              ChatRoute(chatId: room.uid).go(context);
                            },
                          );
                        });
                      },
                      itemCount: roomUser.length,
                    ),
            );
          },
          error: (error, stackTrace) {
            return Text(error.toString());
          },
          loading: () => null,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Create Room',
        onPressed: () async {
          await ref.read(currentRoomProvider.notifier).createRoom(
            room: Room(
              displayName: randomString(7),
              nick: randomString(7),
              description: 'Description',
              open: Visible.MODERATED,
            ),
            users: [],
          );

          if (context.mounted) {
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              const SnackBar(
                content: Text('Room Created'),
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
