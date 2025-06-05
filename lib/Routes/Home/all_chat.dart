import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:moonspace/widgets/async_lock.dart';
import 'package:moonspace/widgets/animated/animated_counter.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/auth.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/roomuser.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/Routes/Home/Chat/Info/chat_info.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Routes/Home/search.dart';
import 'package:spacemoon/Static/assets.dart';
import 'package:moonspace/theme.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';
import 'package:spacemoon/main.dart';

class AllChatPage extends ConsumerWidget {
  const AllChatPage({super.key, this.subscription = false});

  final bool subscription;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRoomsUsers = ref.watch(getAllRoomUserForUserProvider);
    final user = ref.watch(currentUserDataProvider).value;
    final openRooms = ref.watch(searchFamousRoomsProvider).value ?? [];

    return Scaffold(
      bottomNavigationBar: SizedBox(height: context.mq.pad.bottom),
      body: RefreshIndicator(
        onRefresh: () {
          ref.invalidate(currentUserProvider);
          ref.invalidate(searchFamousRoomsProvider);
          return 1.sec.delay();
        },
        child: Semantics(
          label: 'All Chat Page',
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                //------
                if (!subscription) AllChatSliverAppBar(),

                //------
                if (!subscription)
                  AllChatOpenRoomsSliverScrollRow(openRooms: openRooms),

                //------
                allRoomsUsers.when(
                  data: (roomUsers) {
                    if (roomUsers.isEmpty) {
                      return AllChatNoRoomUsers();
                    }

                    return SliverList.builder(
                      itemBuilder: (context, tileIndex) {
                        return Consumer(
                          builder: (context, ref, child) {
                            final roomuser = roomUsers[tileIndex] ?? RoomUser();
                            final room = ref
                                .watch(getRoomByIdProvider(roomuser.room))
                                .value;

                            if (room == null) {
                              return const SizedBox.shrink();
                            }

                            final count = ref
                                .watch(getNewTweetCountProvider(roomuser))
                                .value;

                            final roomName = room.displayName
                                .replaceAll(user?.displayName ?? '***', '')
                                .trim();

                            return AllChatRoomTile(
                              roomName: roomName,
                              room: room,
                              subscription: subscription,
                              count: count,
                              tileIndex: tileIndex,
                              roomuser: roomuser,
                            );
                          },
                        );
                      },
                      itemCount: roomUsers.length,
                    );
                  },
                  error: (error, stackTrace) {
                    return SliverToBoxAdapter(
                      child: SelectableText(error.toString()),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(child: SizedBox()),
                ),
              ],
            ),
          ),
        ),
      ),
      extendBody: true,
      floatingActionButton: subscription
          ? null
          : AsyncLock(
              builder: (loading, status, lock, unlock, setStatus) {
                return FloatingActionButton(
                  heroTag: loading ? 'Loading' : 'Create Chat',
                  onPressed: () async {
                    lock();
                    final room = await ref
                        .read(currentRoomProvider.notifier)
                        .createRoom(room: Room(), users: []);

                    if (context.mounted) {
                      if (room == null) {
                        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                          const SnackBar(content: Text('Chat creation failed')),
                        );
                      } else {
                        ChatInfoRoute(chatId: room.uid).go(context);
                      }
                    }
                    unlock();
                  },
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        )
                      : const Icon(Icons.add, semanticLabel: 'Create new Chat'),
                );
              },
            ),
    );
  }
}

class AllChatSliverAppBar extends StatelessWidget {
  const AllChatSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      // backgroundColor: AppTheme.background,
      collapsedHeight: 82,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
        child: Hero(
          tag: 'Search',
          child: InkWell(
            onTap: () {
              SearchRoute().go(context);
            },
            child: IgnorePointer(
              child: TextFormField(
                autofocus: false,
                decoration: const InputDecoration(
                  hintText: 'abc...',
                  prefixIcon: Icon(Icons.search),
                  labelText: 'Find by nickname',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AllChatOpenRoomsSliverScrollRow extends StatelessWidget {
  const AllChatOpenRoomsSliverScrollRow({super.key, required this.openRooms});

  final List<Room?> openRooms;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: openRooms
                .map(
                  (room) => Semantics(
                    label: 'Go to ${room?.displayName}',
                    child: InkWell(
                      onTap: () {
                        if (room != null) {
                          ChatRoute(chatId: room.uid).go(context);
                        }
                      },
                      child: Container(
                        width: (120, 160).c,
                        height: (120, 160).c,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:
                            (room?.photoURL == null ||
                                room?.photoURL.isEmpty == true)
                            ? Icon(Icons.local_activity_rounded, size: 64)
                            : FutureSpaceBuilder(
                                thumbnail: true,
                                path: room?.photoURL,
                                radius: 16,
                              ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class AllChatRoomTile extends StatelessWidget {
  const AllChatRoomTile({
    super.key,
    required this.roomName,
    required this.room,
    required this.subscription,
    required this.count,
    required this.tileIndex,
    required this.roomuser,
  });

  final String roomName;
  final Room room;
  final bool subscription;
  final int? count;
  final int tileIndex;
  final RoomUser roomuser;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Go to $roomName',
      button: true,
      enabled: true,
      child: ExcludeSemantics(
        child: ListTile(
          key: ValueKey(room.nick),
          tileColor: tileIndex % 2 == 1 ? null : Colors.red,
          title: Text(roomName),
          subtitle: Text(room.nick),
          leading: CircleAvatar(
            radius: 28,
            child: FutureSpaceBuilder(
              thumbnail: true,
              path: room.photoURL,
              radius: 200,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!subscription)
                Text(room.updated.timeString, style: context.ll),
              if (count != 0) const SizedBox(width: 10),
              if (count != 0)
                AnimatedFlipCounter(
                  value: (count == null) ? 0 : min(99, count!),
                  wholeDigits: 1,
                  textStyle: context.ll,
                  duration: const Duration(seconds: 1),
                ),
              if (roomuser.isRequest || roomuser.isInvite)
                const SizedBox(width: 10),
              if (roomuser.isRequest || roomuser.isInvite)
                const Icon(Icons.pets_rounded),
              if (subscription) const SizedBox(width: 10),
              if (subscription)
                AsyncLock(
                  builder: (loading, status, lock, open, setStatus) {
                    return Switch(
                      value: roomuser.subscribed,
                      thumbIcon: const WidgetStatePropertyAll(
                        Icon(Icons.nights_stay_sharp),
                      ),
                      onChanged: (v) async {
                        lock();
                        if (v) {
                          await SpaceMoon.httpCallable(
                            'messaging-callSubscribeFromTopic',
                          ).call(roomuser.toMap());
                        } else {
                          await SpaceMoon.httpCallable(
                            'messaging-callUnsubscribeFromTopic',
                          ).call(roomuser.toMap());
                        }
                        await 1.sec.delay();
                        open();
                      },
                    );
                  },
                ),
            ],
          ),
          onTap: subscription
              ? null
              : () {
                  dino(room.uid);
                  ChatRoute(chatId: room.uid).go(context);
                },
        ),
      ),
    );
  }
}

class AllChatNoRoomUsers extends StatelessWidget {
  const AllChatNoRoomUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Animate(
        effects: const [FadeEffect()],
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 500, maxWidth: 500),
          child: Lottie.asset(Asset.lEmpty, reverse: false, repeat: true),
        ),
      ),
    );
  }
}
