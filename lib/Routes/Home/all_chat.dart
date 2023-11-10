import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:moonspace/darkknight/extensions/string.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Widget/AppFlowy/app_flowy.dart';

class AllChatPage extends ConsumerWidget {
  const AllChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRooms = ref.watch(getAllMyRoomsProvider);

    return AppFlowy(jsonData: exampleJson);

    return Scaffold(
      body: Center(
        child: allRooms.when(
          data: (data) {
            return Animate(
              effects: const [FadeEffect()],
              child: (data.isEmpty)
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
                          final room = ref.watch(GetRoomByIdProvider(data[index]!.room)).value;
                          if (room == null) return const CircularProgressIndicator();
                          return ListTile(
                            title: Text(room.uid),
                            subtitle: Text(room.displayName),
                            leading: const Icon(Icons.panorama_fish_eye_sharp),
                            trailing: Text(room.open.name),
                            onTap: () {
                              ChatRoute(room.uid).go(context);
                            },
                          );
                        });
                      },
                      itemCount: data.length,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ref.read(currentRoomProvider.notifier).createRoom(
            room: Room(
              nick: '@nick',
              description: 'Description',
              displayName: 'Hello',
              open: Visible.MODERATED,
              photoURL: 'photoUrl',
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
    );
  }
}
