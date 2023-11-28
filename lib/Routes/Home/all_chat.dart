import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moonspace/helper/extensions/string.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Gen/google/protobuf/timestamp.pb.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';

extension SupetTimeStamp on Timestamp {
  DateTime get date => toDateTime().toLocal();
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
                            // leading: const Icon(Icons.panorama_fish_eye_sharp),
                            leading: (count != null) ? Text(count.toString()) : const SizedBox(),
                            trailing: Text(room.updated.timeString),
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
          loading: () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lottie.asset(
              //   LottieAnimation.loading.fullPath,
              //   reverse: true,
              //   repeat: true,
              // ),
              Text('Loading...', style: context.hl),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'Create Room',
            onPressed: () async {
              ref.read(currentRoomProvider.notifier).createRoom(
                room: Room(
                  nick: 'nickle',
                  description: 'Description',
                  displayName: 'Hello',
                  open: Visible.MODERATED,
                ),
                users: [
                  randomString(5),
                  randomString(5),
                  randomString(5),
                ],
              );
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            heroTag: 'Create Dummy Room',
            onPressed: () async {
              ref.read(currentRoomProvider.notifier).createRoom(
                room: Room(
                  nick: randomString(7),
                  description: 'Description',
                  displayName: 'Hello',
                  open: Visible.MODERATED,
                ),
                users: [
                  randomString(5),
                  randomString(5),
                  randomString(5),
                ],
              );
            },
            child: const Icon(Icons.pest_control_rodent_outlined),
          ),
        ],
      ),
    );
  }
}
