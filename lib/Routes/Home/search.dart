import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/validator.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Routes/Home/profile.dart';
import 'package:spacemoon/Static/assets.dart';

class SearchRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SearchPage();
  }
}

class SearchPage extends HookConsumerWidget {
  const SearchPage({
    super.key,
    this.room,
  });

  final Room? room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomCon = useTextEditingController();
    final searchRoom = ref.watch(searchRoomByNickProvider).value;
    final searchUser = ref.watch(searchUserByNickProvider).value;

    return Scaffold(
      appBar: room != null ? AppBar(title: const Text('Invite Members')) : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AsyncTextFormField(
              con: roomCon,
              autofocus: true,
              decoration: (AsyncText value, roomCon) => const InputDecoration(
                hintText: 'abc...',
                labelText: 'Find Rooms or Users by nickname',
              ),
              milliseconds: 600,
              asyncValidator: (v) async {
                if (v.length < 7) return 'more than 6 characters required';

                if (!isAlphanumeric(v)) return 'only alphanumeric characters are allowed';

                ref.read(searchTextProvider.notifier).change(v);
                await 200.mil.delay();

                return null;
              },
              showSubmitSuffix: false,
            ),
            if (searchRoom != null || searchUser != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                child: Text(
                  'Found ${searchRoom != null ? 1 : 0} room, ${searchUser != null ? 1 : 0} user',
                  style: context.tl,
                ),
              ),
            if (searchRoom == null && searchUser == null)
              Expanded(
                child: Center(
                  child: Lottie.asset(
                    Asset.lDot,
                    reverse: false,
                    repeat: true,
                  ),
                ),
              ),
            if (searchRoom != null || searchUser != null)
              Expanded(
                child: ListView(
                  children: [
                    if (searchRoom != null)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          if (context.mounted) {
                            ChatRoute(chatId: searchRoom.uid).go(context);
                          }
                        },
                        title: Text(searchRoom.displayName),
                        trailing: const Text('Room'),
                      ),
                    if (searchUser != null)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          if (context.mounted) {
                            ProfileRoute($extra: ProfileObj(user: searchUser)).go(context);
                          }
                        },
                        title: Text(searchUser.displayName),
                        trailing: const Text('User'),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
