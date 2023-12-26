import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:moonspace/widgets/animated/animated_buttons.dart';
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
import 'package:spacemoon/Static/theme.dart';
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
      bottomNavigationBar: SizedBox(
        height: context.mq.pad.bottom,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          ref.invalidate(currentUserProvider);
          ref.invalidate(searchFamousRoomsProvider);
          return 1.sec.delay();
        },
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              if (!subscription)
                SliverAppBar(
                  pinned: true,
                  backgroundColor: AppTheme.background,
                  collapsedHeight: 82,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
                    child: Hero(
                      tag: 'Search',
                      child: TextFormField(
                        autofocus: false,
                        decoration: const InputDecoration(
                          hintText: 'abc...',
                          prefixIcon: Icon(Icons.search),
                          labelText: 'Find by nickname',
                        ),
                        onTap: () {
                          SearchRoute().go(context);
                        },
                      ),
                    ),
                  ),
                ),
              if (!subscription)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: openRooms
                            .map(
                              (room) => InkWell(
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
                                    color: AppTheme.seedCard,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: (room?.photoURL == null || room?.photoURL.isEmpty == true)
                                      ? Icon(
                                          Icons.local_activity_rounded,
                                          size: 64,
                                          color: AppTheme.op,
                                        )
                                      : FutureSpaceBuilder(
                                          thumbnail: true,
                                          path: room?.photoURL,
                                          radius: 16,
                                        ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              allRoomsUsers.when(
                data: (roomUsers) {
                  if (roomUsers.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Animate(
                        effects: const [FadeEffect()],
                        child: Lottie.asset(
                          Asset.lEmpty,
                          reverse: false,
                          repeat: true,
                        ),
                      ),
                    );
                  }

                  return SliverList.builder(
                    itemBuilder: (context, index) {
                      return Consumer(
                        builder: (context, ref, child) {
                          final roomuser = roomUsers[index] ?? RoomUser();

                          final room = ref.watch(GetRoomByIdProvider(roomuser.room)).value;
                          if (room == null) {
                            return const SizedBox.shrink();
                          }

                          final count = ref.watch(GetNewTweetCountProvider(roomuser)).value;

                          return ListTile(
                            key: ValueKey(room.nick),
                            tileColor: index % 2 == 1 ? null : Color.lerp(AppTheme.card, context.theme.csPri, .005),
                            title: Text(room.displayName.replaceAll(user?.displayName ?? '***', '').trim()),
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
                                if (!subscription) Text(room.updated.timeString, style: context.ll),
                                if (count != 0) const SizedBox(width: 10),
                                if (count != 0)
                                  AnimatedFlipCounter(
                                    value: (count == null) ? 0 : min(99, count),
                                    wholeDigits: 1,
                                    textStyle: context.ll,
                                    duration: const Duration(seconds: 1),
                                  ),
                                if (roomuser.isRequest || roomuser.isInvite) const SizedBox(width: 10),
                                if (roomuser.isRequest || roomuser.isInvite) const Icon(Icons.pets_rounded),
                                if (subscription) const SizedBox(width: 10),
                                if (subscription)
                                  AsyncLock(
                                    builder: (loading, status, lock, open, setStatus) {
                                      return Switch(
                                        value: roomuser.subscribed,
                                        thumbIcon: const MaterialStatePropertyAll(Icon(Icons.nights_stay_sharp)),
                                        onChanged: (v) async {
                                          lock();
                                          if (v) {
                                            await SpaceMoon.fn('messaging-callSubscribeFromTopic')
                                                .call(roomuser.toMap());
                                          } else {
                                            await SpaceMoon.fn('messaging-callUnsubscribeFromTopic')
                                                .call(roomuser.toMap());
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
                          );
                        },
                      );
                    },
                    itemCount: roomUsers.length,
                  );
                },
                error: (error, stackTrace) {
                  return SliverToBoxAdapter(child: Text(error.toString()));
                },
                loading: () => const SliverToBoxAdapter(child: SizedBox()),
              ),
            ],
          ),
        ),
      ),
      extendBody: true,
      floatingActionButton: subscription
          ? null
          : AsyncLock(
              builder: (loading, status, lock, open, setStatus) {
                return FloatingActionButton(
                  heroTag: loading ? 'Loading' : 'Create Room',
                  onPressed: () async {
                    lock();
                    final room = await ref.read(currentRoomProvider.notifier).createRoom(
                      room: Room(),
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
