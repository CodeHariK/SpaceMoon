import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/Form/async_text_field.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';

class SearchRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SearchPage();
  }
}

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomCon = useTextEditingController();
    final searchRooms = ref.watch(getRoomProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AsyncTextFormField(
              con: roomCon,
              decoration: const InputDecoration(
                hintText: 'Enter Unique Nick Name',
                labelText: 'Nick Name',
              ),
              asyncFn: (v) async {
                await 2.sec.delay();

                return Random().nextDouble() < .7;
              },
            ),
            // AsyncTextFormField(
            //   con: roomCon,
            //   autofocus: true,
            //   decoration: const InputDecoration(
            //     hintText: 'Find Rooms',
            //   ),
            //   asyncFn: (v) async {
            //     await ref.read(roomTextProvider.notifier).change(v);
            //     return true;
            //   },
            // ),
            Expanded(
              child: searchRooms.map(
                data: (rooms) {
                  if (rooms.value == null || rooms.value?.isEmpty == true) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(border: 1.bs.c(context.theme.csPri).border),
                        child: context.hl.text('No Room'),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: rooms.value?.length,
                    itemBuilder: (context, i) {
                      final room = rooms.value?[i];
                      return InkWell(
                        onTap: () {
                          if (room != null) {
                            if (context.mounted /*&& ref.read(isUserIsInRoomProvider)*/) {
                              ChatRoute(room.uid).go(context);
                            }
                          }
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Text(room?.displayName ?? 'Name'),
                              Text(room?.description ?? 'Description'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (e) => Text(e.toString()),
                loading: (o) => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
