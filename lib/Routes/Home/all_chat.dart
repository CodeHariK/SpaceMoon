import 'dart:math';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:moonspace/form/highlight_text_field.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:moonspace/helper/validator/validator.dart';
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
import 'package:spacemoon/Widget/Common/shimmer_boxes.dart';

class AllChatPage extends ConsumerWidget {
  const AllChatPage({super.key, this.subscription = false});

  final bool subscription;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRoomsUsers = ref.watch(getAllRoomUserForUserProvider);
    final user = ref.watch(currentUserDataProvider).value;

    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: context.mq.pad.bottom,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          ref.invalidate(currentUserProvider);
          return 1.sec.delay();
        },
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 300,
                child: ExampleWidget(),
              ),
              TextField(
                style: TextStyle(fontSize: 32),
                controller: FruitColorizer({
                  'apple': TextStyle(color: Colors.green, decoration: TextDecoration.underline),
                  'orange': TextStyle(color: Colors.orange, shadows: kElevationToShadow[2]),
                }),
              ),
              TextField(
                style: TextStyle(fontSize: 32),
                controller: FruitColorizer.fromColors({
                  'apple': Colors.green,
                  r'@\w+': Colors.blue,
                  'orange': Colors.orange,
                })
                  ..text = 'orange hari apple @all',
              ),
              if (!subscription)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Hero(
                    tag: 'Search',
                    child: TextFormField(
                      autofocus: false,
                      decoration: const InputDecoration(
                        hintText: 'abc...',
                        prefixIcon: Icon(Icons.search),
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
                    data: (roomUsers) {
                      return Animate(
                        effects: const [FadeEffect()],
                        child: (roomUsers.isEmpty)
                            ? Lottie.asset(
                                Asset.lEmpty,
                                reverse: false,
                                repeat: true,
                              )
                            : ListView.builder(
                                itemBuilder: (context, index) {
                                  return Consumer(builder: (context, ref, child) {
                                    final roomuser = roomUsers[index] ?? RoomUser();

                                    final room = ref.watch(GetRoomByIdProvider(roomuser.room)).value;
                                    if (room == null) {
                                      return const SizedBox.shrink();
                                    }

                                    final count = ref.watch(GetNewTweetCountProvider(roomuser)).value;

                                    return ListTile(
                                      key: ValueKey(room.nick),
                                      tileColor:
                                          index % 2 == 1 ? null : Color.lerp(AppTheme.card, context.theme.csPri, .005),
                                      title: Text(room.displayName.replaceAll(user?.displayName ?? '***', '').trim()),
                                      subtitle: Text(room.nick),
                                      leading: CircleAvatar(
                                        radius: 28,
                                        child: (!isURL(room.photoURL))
                                            ? null
                                            : CustomCacheImage(
                                                imageUrl: spaceThumbImage(room.photoURL),
                                                showError: false,
                                                radius: 32,
                                              ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (!subscription) Text(room.updated.timeString),
                                          if (count != 0) const SizedBox(width: 10),
                                          if (count != 0)
                                            AnimatedFlipCounter(
                                              value: (count == null) ? 0 : min(99, count),
                                              wholeDigits: 1,
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
                                                  thumbIcon:
                                                      const MaterialStatePropertyAll(Icon(Icons.nights_stay_sharp)),
                                                  onChanged: (v) async {
                                                    lock();
                                                    if (v) {
                                                      await FirebaseFunctions.instance
                                                          .httpsCallable('callSubscribeFromTopic')
                                                          .call(roomuser.toMap());
                                                    } else {
                                                      await FirebaseFunctions.instance
                                                          .httpsCallable('callUnsubscribeFromTopic')
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
                                  });
                                },
                                itemCount: roomUsers.length,
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

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({super.key});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  late final TextWithNamesEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextWithNamesEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldWithNames(
      controller: _controller,
      onNamesRequested: (BuildContext context) {
        return ['Simon', 'Randal', 'Scott'];
      },
    );
  }
}
