import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:moonspace/helper/extensions/string.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/validator.dart';
import 'package:moonspace/widgets/animated/animated_buttons.dart';
import 'package:moonspace/widgets/animated/animated_counter.dart';
import 'package:moonspace/widgets/shimmer_boxes.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Gen/google/protobuf/timestamp.pb.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Routes/Home/Chat/Info/chat_info.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Routes/Home/search.dart';
import 'package:spacemoon/Static/assets.dart';
import 'package:spacemoon/Static/theme.dart';
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
      bottomNavigationBar: SizedBox(
        height: context.mq.pad.bottom,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Hero(
              tag: 'Search',
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'abc...',
                  labelText: 'Find Rooms or Users by nickname',
                ),
                onTap: () {
                  SearchRoute().go(context);
                },
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: allRoomsUsers.when(
                data: (roomUser) {
                  return Animate(
                    effects: const [FadeEffect()],
                    child: (roomUser.isEmpty)
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Lottie.asset(
                                Asset.lEmpty,
                                reverse: false,
                                repeat: true,
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              return Consumer(builder: (context, ref, child) {
                                final room = ref.watch(GetRoomByIdProvider(roomUser[index]!.room)).value;
                                if (room == null) return const SizedBox.shrink();

                                final count = ref.watch(GetNewTweetCountProvider(roomUser[index]!)).value;

                                return ListTile(
                                  tileColor: index % 2 == 1 ? AppTheme.card : null,
                                  title: Text(room.displayName),
                                  subtitle: Text(room.nick),
                                  leading: CircleAvatar(
                                    radius: 28,
                                    child: (!isURL(room.photoURL))
                                        ? null
                                        : CustomCacheImage(
                                            imageUrl: spaceThumbImage(room.photoURL),
                                            radius: 32,
                                          ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(room.updated.timeString),
                                      if (count != 0) const SizedBox(width: 10),
                                      if (count != 0)
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
                loading: () => const SizedBox(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AsyncLock(
        builder: (loading, status, lock, open, setStatus) {
          return FloatingActionButton(
            heroTag: loading ? 'Loading' : 'Create Room',
            onPressed: () async {
              lock();
              final room = await ref.read(currentRoomProvider.notifier).createRoom(
                room: Room(
                  displayName: randomString(7),
                  nick: randomString(16),
                  description: 'Description',
                  open: Visible.MODERATED,
                ),
                users: [],
              );

              if (context.mounted) {
                if (room == null) {
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    const SnackBar(
                      content: Text('Chat creation failed'),
                    ),
                  );
                } else {
                  ChatInfoRoute(chatId: room.uid).go(context);
                }
              }
              open();
            },
            child: loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
                : const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
