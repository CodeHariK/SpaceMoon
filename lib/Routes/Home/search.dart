import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/validator.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AsyncTextFormField(
              con: roomCon,
              autofocus: true,
              decoration: (AsyncText value, roomCon) => const InputDecoration(
                hintText: 'Find Rooms',
                labelText: 'Find Rooms',
              ),
              milliseconds: 600,
              asyncValidator: (v) async {
                if (v.length < 7) return 'Invalid';

                if (v.startsWith('#')) {
                  v = v.substring(1);
                }

                if (!isAlphanumeric(v)) return 'Invalid';

                await ref.read(roomTextProvider.notifier).change(v);
                await 200.mil.delay();

                return null;
              },
            ),
            if (searchRooms.value != null && searchRooms.value!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                child: Text(
                  'Found ${searchRooms.value!.length} rooms',
                  style: context.tl,
                ),
              ),
            Expanded(
              child: searchRooms.map(
                data: (rooms) {
                  if (rooms.value == null || rooms.value?.isEmpty == true) {
                    return Center(
                      child: Text('No Room Found', style: context.hl),
                    );
                  }

                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: rooms.value!.length,
                    itemBuilder: (context, i) {
                      final room = rooms.value?[i];
                      return ListTile(
                        onTap: () {
                          if (room != null) {
                            if (context.mounted /*&& ref.read(isUserIsInRoomProvider)*/) {
                              ChatRoute(room.uid).go(context);
                            }
                          }
                        },
                        title: Text(room?.displayName ?? 'Name'),
                        subtitle: Text(room?.description ?? 'Description'),
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
