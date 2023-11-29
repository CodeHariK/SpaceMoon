import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/widgets/animated/animated_buttons.dart';
import 'package:moonspace/widgets/shimmer_boxes.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Routes/Home/all_chat.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Routes/Home/profile.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';
import 'package:spacemoon/Widget/Common/fire_image.dart';

class ChatInfoRoute extends GoRouteData {
  final String chatId;

  const ChatInfoRoute(this.chatId);

  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatInfoPage(
      chatId: chatId,
    );
  }
}

class ChatInfoPage extends HookConsumerWidget {
  const ChatInfoPage({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(roomStreamProvider).value;
    final meInRoom = ref.watch(currentRoomUserProvider).value;
    final allUsersPro = ref.watch(getAllRoomUsersProvider);
    final allUsers = allUsersPro.value ?? [];

    useEffect(() {
      ref.read(currentRoomProvider.notifier).updateRoom(id: chatId);

      return null;
    }, [room]);

    if (room == null) {
      return Scaffold(
        appBar: AppBar(),
      );
    }

    // if (allUsersPro.isLoading) {
    //   return const Scaffold();
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Align(
                  child: Container(
                    height: 240,
                    width: 240,
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      splashFactory: InkSplash.splashFactory,
                      onTap: meInRoom?.role != Role.ADMIN
                          ? null
                          : () async {
                              final imageMetadata = await selectImageMedia();

                              if (imageMetadata == null) return;

                              await uploadFire(
                                meta: imageMetadata,
                                imageName: 'profile',
                                docPath: 'rooms/${room.uid}',
                                storagePath: 'profile/rooms/${room.uid}',
                                singlepath: Const.photoURL.name,
                              );
                            },
                      child: room.photoURL.isEmpty == true
                          ? const Icon(
                              CupertinoIcons.person_crop_circle_badge_plus,
                              size: 120,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(250),
                              child: CustomCacheImage(
                                imageUrl: spaceThumbImage(room.photoURL),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              SliverList.list(
                children: [
                  IgnorePointer(
                    ignoring: (meInRoom?.isAdmin != true),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: AsyncProfileField(
                        text: room.displayName,
                        style: context.hm,
                        textAlign: TextAlign.start,
                        hintText: 'Name',
                        alphanumeric: false,
                        asyncValidator: (value) async {
                          return null;
                        },
                        onSubmit: (con) {
                          ref.read(currentRoomProvider.notifier).updateRoomInfo(
                                Room(
                                  uid: room.uid,
                                  displayName: con.text,
                                ),
                              );
                        },
                      ),
                    ),
                  ),
                  IgnorePointer(
                    ignoring: (meInRoom?.isAdmin != true),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: AsyncProfileField(
                        text: room.nick,
                        style: context.hs,
                        textAlign: TextAlign.start,
                        hintText: 'Nickname',
                        prefix: const Text('#'),
                        asyncValidator: (value) async {
                          return null;
                        },
                        onSubmit: (con) {
                          ref.read(currentRoomProvider.notifier).updateRoomInfo(
                                Room(
                                  uid: room.uid,
                                  nick: con.text,
                                ),
                              );
                        },
                      ),
                    ),
                  ),
                  IgnorePointer(
                    ignoring: (meInRoom?.isAdmin != true),
                    child: AsyncProfileField(
                      text: room.description,
                      style: context.ts,
                      textAlign: TextAlign.start,
                      hintText: 'Description',
                      alphanumeric: false,
                      asyncValidator: (value) async {
                        return null;
                      },
                      maxLines: null,
                      onSubmit: (con) {
                        ref.read(currentRoomProvider.notifier).updateRoomInfo(
                              Room(
                                uid: room.uid,
                                description: con.text,
                              ),
                            );
                      },
                    ),
                  ),
                  IgnorePointer(
                    ignoring: (meInRoom?.isAdmin != true),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButtonFormField(
                        key: ValueKey(room.open),
                        value: room.open,
                        items: Visible.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                        borderRadius: 20.br,
                        decoration: const InputDecoration(
                          labelText: 'Visiblity',
                          constraints: BoxConstraints(maxWidth: 200),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            room.open = value;
                            ref.read(currentRoomProvider.notifier).updateRoomInfo(room);
                          }
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Created on : ${room.created.dateString}',
                      style: context.tm,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Last message on : ${room.updated.dateString}  @  ${room.updated.timeString}',
                      style: context.tm,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (meInRoom != null && meInRoom.isAdmin)
                        Align(
                          child: FilledButton(
                            onPressed: () async {
                              await ref.read(currentRoomProvider.notifier).deleteRoom(meInRoom);
                              if (context.mounted) {
                                HomeRoute().go(context);
                              }
                            },
                            child: const Text('Delete Room'),
                          ),
                        ),
                      if (meInRoom != null)
                        Align(
                          child: FilledButton(
                            onPressed: () async {
                              await ref.read(currentRoomProvider.notifier).deleteRoomUser(meInRoom);
                              if (context.mounted) {
                                HomeRoute().go(context);
                              }
                            },
                            child: const Text('Leave Room'),
                          ),
                        ),
                      if (meInRoom == null && room.open == Visible.MODERATED)
                        AsyncButton(
                          icon: Icons.mail,
                          asyncFn: () async {
                            await ref.read(currentRoomProvider.notifier).requestAccessToRoom();
                            return true;
                          },
                          name: 'Send Request',
                        ),
                      if (meInRoom?.role == Role.REQUEST) const Text('Request Sent'),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              if (meInRoom != null && meInRoom.isAdminOrMod)
                SliverList.list(
                  children: [
                    const Divider(),
                    Text('Members', textAlign: TextAlign.center, style: context.tl),
                  ],
                ),
              if (meInRoom != null && meInRoom.isAdminOrMod)
                SliverList.builder(
                  itemBuilder: (context, index) {
                    final roomUser = allUsers[index]!;
                    return ListTile(
                      title: Text(roomUser.user),
                      subtitle: Text(roomUser.role.name),
                      leading: Icon(roomUser == meInRoom ? Icons.star_border : Icons.circle),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (roomUser.isRequest)
                            IconButton.filledTonal(
                              onPressed: () {
                                ref.read(currentRoomProvider.notifier).acceptAccessToRoom(roomUser);
                              },
                              icon: const Icon(Icons.check),
                            ),
                          if (!roomUser.isAdminOrMod && roomUser != meInRoom && meInRoom.isAdminOrMod)
                            IconButton(
                              onPressed: () {
                                ref.read(currentRoomProvider.notifier).deleteRoomUser(roomUser);
                                ref.read(currentRoomProvider.notifier).exitRoom(roomUser);
                                ref.invalidate(currentRoomUserProvider);
                              },
                              icon: const Icon(Icons.close),
                            )
                        ],
                      ),
                    );
                  },
                  itemCount: allUsers.length,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
