import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/form/form.dart';
import 'package:moonspace/helper/extensions/string.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/checkers.dart';
import 'package:moonspace/widgets/animated/animated_buttons.dart';
import 'package:moonspace/widgets/functions.dart';
import 'package:moonspace/widgets/async_lock.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/roomuser.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Routes/Home/profile.dart';
import 'package:spacemoon/Routes/Home/search.dart';
import 'package:moonspace/theme.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';
import 'package:spacemoon/Widget/Common/fire_image.dart';

class ChatInfoRoute extends GoRouteData {
  final String chatId;

  const ChatInfoRoute({required this.chatId});

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(child: ChatInfoPage(chatId: chatId));
  }
}

class ChatInfoPage extends ConsumerStatefulWidget {
  const ChatInfoPage({super.key, required this.chatId, this.showAppbar = true});

  final String chatId;
  final bool showAppbar;

  @override
  ConsumerState<ChatInfoPage> createState() => _ChatInfoPageState();
}

class _ChatInfoPageState extends ConsumerState<ChatInfoPage> {
  @override
  void initState() {
    super.initState();
    ref.read(currentRoomProvider.notifier).updateRoom(id: widget.chatId);
  }

  @override
  void didUpdateWidget(covariant ChatInfoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    ref.read(currentRoomProvider.notifier).updateRoom(id: widget.chatId);
  }

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(roomStreamProvider).value;
    final meUser = ref.watch(currentUserDataProvider).value;
    final meInRoom = ref.watch(currentRoomUserProvider).value;
    final allRoomUsersPro = ref.watch(getAllRoomUsersInRoomProvider);
    final allRoomUsers = allRoomUsersPro.value ?? [];

    if (room == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Info'),
          leading: BackButton(
            onPressed: () {
              context.pop();
            },
          ),
        ),
      );
    }

    // if (allUsersPro.isLoading) {
    //   return const Scaffold();
    // }

    return Scaffold(
      appBar: !widget.showAppbar
          ? null
          : AppBar(
              leading: BackButton(
                onPressed: () {
                  context.pop();
                },
              ),
              title: Text(
                room.displayName
                    .replaceAll(meUser?.displayName ?? '***', '')
                    .trim(),
              ),
              actions: [
                ReportDialogButton(meInRoom: meInRoom, ref: ref),

                if (meInRoom?.isUserOrAdmin == true)
                  IconButton(
                    onPressed: () {
                      context.bSlidePush(SearchPage(room: room));
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      semanticLabel: 'Invite Users',
                    ),
                  ),
              ],
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              //
              ChatInfoChangeProfilePicture(meInRoom: meInRoom, room: room),

              SliverList.list(
                children: [
                  ChatInfoUpdateRoomName(
                    room: room,
                    meInRoom: meInRoom,
                    ref: ref,
                  ),

                  ChatInfoUpdateRoomNickname(
                    room: room,
                    meInRoom: meInRoom,
                    ref: ref,
                  ),

                  ChatInfoUpdateRoomDescription(
                    room: room,
                    meInRoom: meInRoom,
                    ref: ref,
                  ),

                  const Divider(),

                  //
                  ChatInfoUpdateRoomVisibility(
                    meInRoom: meInRoom,
                    room: room,
                    ref: ref,
                  ),

                  const SizedBox(height: 5),

                  //
                  if (room.open == Visible.OPEN &&
                      meInRoom?.isAdmin == true &&
                      meUser?.admin == true)
                    ChatInfoUpdateRoomFamous(room: room, ref: ref),

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

                  if (meInRoom != null)
                    ChatInfoLeaveRoom(ref: ref, meInRoom: meInRoom),

                  const SizedBox(height: 4),

                  //------
                  if (meInRoom != null && meInRoom.isAdmin)
                    ChatInfoDeleteRoom(meInRoom: meInRoom, ref: ref),

                  if (meInRoom == null &&
                      room.open.value >= Visible.MODERATED.value)
                    ChatInfoUpgradeRoomAccess(
                      ref: ref,
                      meUser: meUser,
                      room: room,
                    ),

                  if (meInRoom?.role == Role.REQUEST)
                    ListTile(
                      tileColor: context.theme.csSecCon,
                      titleTextStyle: context.ts.c(context.theme.csSec),
                      iconColor: context.theme.csSec,
                      title: const Text('Request Sent'),
                    ),
                  const SizedBox(height: 10),
                ],
              ),

              //------
              if (meInRoom != null)
                SliverList.list(
                  children: [
                    const Divider(),
                    Text(
                      'Members',
                      textAlign: TextAlign.center,
                      style: context.tl,
                    ),
                  ],
                ),

              //------
              if (meInRoom != null)
                ChatInfoRoomUsers(
                  allRoomUsers: allRoomUsers,
                  meInRoom: meInRoom,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatInfoUpgradeRoomAccess extends StatelessWidget {
  const ChatInfoUpgradeRoomAccess({
    super.key,
    required this.ref,
    required this.meUser,
    required this.room,
  });

  final WidgetRef ref;
  final User? meUser;
  final Room room;

  @override
  Widget build(BuildContext context) {
    return AsyncLock(
      builder: (loading, status, lock, open, setStatus) {
        return FilledButton.icon(
          icon: const Icon(Icons.mail),
          onPressed: () async {
            lock();
            await ref
                .read(currentRoomProvider.notifier)
                .upgradeAccessToRoom(
                  RoomUser(user: meUser?.uid, room: room.uid),
                );

            ref.invalidate(currentRoomUserProvider);
            open();
          },
          label: Text(room.open == Visible.OPEN ? 'Join' : 'Send Request'),
        );
      },
    );
  }
}

class ChatInfoDeleteRoom extends StatelessWidget {
  const ChatInfoDeleteRoom({
    super.key,
    required this.meInRoom,
    required this.ref,
  });

  final RoomUser meInRoom;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection(Const.roomusers.name)
          .where(Const.room.name, isEqualTo: meInRoom.room)
          .where(Const.role.name, isEqualTo: Role.ADMIN.name)
          .count()
          .get(),
      builder: (context, snapshot) {
        if (snapshot.data?.count == 1) {
          return AsyncLock(
            builder: (loading, status, lock, open, setStatus) {
              return FilledButton.icon(
                icon: const Icon(Icons.delete),
                style: FilledButton.styleFrom(
                  backgroundColor: context.theme.csErrCon,
                  foregroundColor: context.theme.csOnErrCon,
                ),
                onPressed: () async {
                  lock();
                  final res = await context.showYesNo(
                    title: 'Are you sure you want to Delete this room?',
                  );
                  if (res == true) {
                    await ref
                        .read(currentRoomProvider.notifier)
                        .deleteRoom(meInRoom);
                    if (context.mounted) {
                      HomeRoute().go(context);
                    }
                  }
                  open();
                },
                label: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Delete Room'),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

class ChatInfoLeaveRoom extends StatelessWidget {
  const ChatInfoLeaveRoom({
    super.key,
    required this.ref,
    required this.meInRoom,
  });

  final WidgetRef ref;
  final RoomUser meInRoom;

  @override
  Widget build(BuildContext context) {
    return AsyncLock(
      builder: (loading, status, lock, open, setStatus) {
        return FilledButton.icon(
          icon: const Icon(Icons.logout),
          style: FilledButton.styleFrom(
            backgroundColor: context.theme.csErrCon,
            foregroundColor: context.theme.csOnErrCon,
          ),
          onPressed: () async {
            lock();
            final res = await context.showYesNo(
              title: 'Are you sure you want to Leave this room?',
            );
            if (res) {
              await ref
                  .read(currentRoomProvider.notifier)
                  .deleteRoomUser(meInRoom);
              ref.read(currentRoomProvider.notifier).exitRoom(null);
              if (context.mounted) {
                HomeRoute().go(context);
              }
            }
            open();
          },
          label: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                )
              : const Text('Leave Room'),
        );
      },
    );
  }
}

class ChatInfoUpdateRoomFamous extends StatelessWidget {
  const ChatInfoUpdateRoomFamous({
    super.key,
    required this.room,
    required this.ref,
  });

  final Room room;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return AsyncLock(
      builder: (loading, status, lock, open, setStatus) {
        return SwitchListTile(
          key: ValueKey(room.famous),
          value: room.famous,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          title: Text('Famous', style: context.ts),
          tileColor: context.theme.csSecCon,
          onChanged: (v) async {
            lock();
            await ref
                .read(currentRoomProvider.notifier)
                .updateRoomInfo(Room(uid: room.uid, famous: !room.famous));
            open();
          },
        );
      },
    );
  }
}

class ChatInfoUpdateRoomVisibility extends StatelessWidget {
  const ChatInfoUpdateRoomVisibility({
    super.key,
    required this.meInRoom,
    required this.room,
    required this.ref,
  });

  final RoomUser? meInRoom;
  final Room room;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: (meInRoom?.isAdmin != true),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AsyncLock(
          builder: (loading, status, lock, open, setStatus) {
            return DropdownButtonFormField(
              key: ValueKey(room.open),
              value: room.open,
              items: Visible.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                  .toList(),
              borderRadius: 8.br,
              dropdownColor: context.theme.csSecCon,
              decoration: InputDecoration(
                constraints: const BoxConstraints(maxWidth: 200),
                border: 0.bs.c(Colors.transparent).out.r(8),
                enabledBorder: 0.bs.c(Colors.transparent).out.r(8),
                focusedBorder: 0.bs.c(Colors.transparent).out.r(8),
                fillColor: context.theme.csSecCon,
                filled: true,
              ),
              onChanged: (value) async {
                if (value != null) {
                  lock();
                  await ref
                      .read(currentRoomProvider.notifier)
                      .updateRoomInfo(Room(uid: room.uid, open: value));
                  open();
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class ChatInfoUpdateRoomDescription extends StatelessWidget {
  const ChatInfoUpdateRoomDescription({
    super.key,
    required this.room,
    required this.meInRoom,
    required this.ref,
  });

  final Room room;
  final RoomUser? meInRoom;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return AsyncTextFormField(
      key: ValueKey(room.description),
      initialValue: room.description,
      enabled: meInRoom?.isAdmin == true,
      style: context.ts,
      maxLines: null,
      asyncValidator: (value) async {
        return value.checkMin(8);
      },
      showPrefix: false,
      textInputAction: TextInputAction.done,
      onSubmit: (con) async {
        await ref
            .read(currentRoomProvider.notifier)
            .updateRoomInfo(Room(uid: room.uid, description: con.text));
      },
      decoration: (AsyncText value, nickCon) =>
          AppTheme.uInputDecoration.copyWith(label: const Text('Description')),
    );
  }
}

class ChatInfoUpdateRoomNickname extends StatelessWidget {
  const ChatInfoUpdateRoomNickname({
    super.key,
    required this.room,
    required this.meInRoom,
    required this.ref,
  });

  final Room room;
  final RoomUser? meInRoom;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return AsyncTextFormField(
      key: ValueKey(room.nick),
      initialValue: room.nick,
      maxLines: 1,
      autocorrect: false,
      enableSuggestions: false,
      enabled: meInRoom?.isAdmin == true,
      style: context.tm,
      asyncValidator: (value) async {
        if (value.checkMin(8) != null) {
          return value.checkMin(8);
        }
        if (value.checkAlphanumeric() != null) {
          return value.checkAlphanumeric();
        }
        if (room.nick == value) {
          return null;
        }

        final r = await countRoomByNick(value);

        if (r != 0) {
          return 'Not available';
        }
        return null;
      },
      showPrefix: false,
      textInputAction: TextInputAction.done,
      onSubmit: (con) async {
        await ref
            .read(currentRoomProvider.notifier)
            .updateRoomInfo(Room(uid: room.uid, nick: con.text));
      },
      decoration: (AsyncText value, nickCon) =>
          AppTheme.uInputDecoration.copyWith(
            hintText: '  abc...',
            prefixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Nickname : #', style: context.tl)],
            ),
          ),
    );
  }
}

class ChatInfoUpdateRoomName extends StatelessWidget {
  const ChatInfoUpdateRoomName({
    super.key,
    required this.room,
    required this.meInRoom,
    required this.ref,
  });

  final Room room;
  final RoomUser? meInRoom;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Chat Name',
      child: AsyncTextFormField(
        key: ValueKey(room.displayName),
        initialValue: room.displayName,
        enabled: meInRoom?.isAdmin == true,
        style: context.hm,
        asyncValidator: (value) async {
          return value.checkMin(8);
        },
        maxLines: 1,
        showPrefix: false,
        textInputAction: TextInputAction.done,
        onSubmit: (con) async {
          await ref
              .read(currentRoomProvider.notifier)
              .updateRoomInfo(Room(uid: room.uid, displayName: con.text));
        },
        decoration: (AsyncText value, nickCon) =>
            AppTheme.uInputDecoration.copyWith(hintText: 'Name'),
      ),
    );
  }
}

class ChatInfoChangeProfilePicture extends StatelessWidget {
  const ChatInfoChangeProfilePicture({
    super.key,
    required this.meInRoom,
    required this.room,
  });

  final RoomUser? meInRoom;
  final Room room;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Align(
        child: Container(
          height: (240, 300).c,
          width: (240, 300).c,
          padding: const EdgeInsets.all(8),
          child: Semantics(
            label: 'Change profile picture',
            child: InkWell(
              splashFactory: InkSplash.splashFactory,
              onTap: meInRoom?.role != Role.ADMIN
                  ? null
                  : () async {
                      final imageMetadata = await selectImageMedia();

                      if (imageMetadata == null) return;

                      await uploadFire(
                        meta: imageMetadata.$1,
                        file: imageMetadata.$2,
                        imageName: 'profile${randomString(4)}',
                        docPath: 'rooms/${room.uid}',
                        storagePath: 'profile/rooms/${room.uid}',
                        singlepath: Const.photoURL.name,
                      );
                    },
              child: room.photoURL.isEmpty == true
                  ? Icon(Icons.face_2_outlined, size: (120, 160).c)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(250),
                      child: FutureSpaceBuilder(
                        path: room.photoURL,
                        thumbnail: true,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReportDialogButton extends StatelessWidget {
  const ReportDialogButton({
    super.key,
    required this.meInRoom,
    required this.ref,
  });

  final RoomUser? meInRoom;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return MarioChoiceDialog<String>(
      multi: true,
      title: Text('Reasons for reporting this room?', style: context.tm),
      choices: const {
        'Contains offensive media',
        'Promotes violence',
        'Is not appropriate for community',
      },
      child: const Icon(
        Icons.report,
        color: Colors.red,
        semanticLabel: 'Report this chat',
      ),
      actions: (marioContext, selection) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            child: const Text('CANCEL'),
            onPressed: () {
              marioContext.nav.pop();
            },
          ),
          const SizedBox(width: 10),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: marioContext.theme.csErrCon,
              foregroundColor: marioContext.theme.csOnErrCon,
            ),
            child: const Text('Report'),
            onPressed: () async {
              if (selection.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Your report is under review, action will be taken within 12 hrs.',
                    ),
                  ),
                );
                marioContext.nav.pop();
                HomeRoute().go(context);
                if (meInRoom != null) {
                  await ref
                      .read(currentRoomProvider.notifier)
                      .reportRoom(meInRoom!, selection);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class ChatInfoRoomUsers extends StatelessWidget {
  const ChatInfoRoomUsers({
    super.key,
    required this.allRoomUsers,
    required this.meInRoom,
  });

  final List<RoomUser?> allRoomUsers;
  final RoomUser meInRoom;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, index) {
        return Consumer(
          builder: (context, ref, child) {
            final roomUser = allRoomUsers[index]!;

            final user = ref.watch(getUserByIdProvider(roomUser.user)).value;

            return ListTile(
              title: Text(user?.displayName ?? roomUser.user),
              subtitle: Text(roomUser.role.name),
              onTap: () {
                context.rSlidePush(
                  ProfilePage(searchuser: user, showAppbar: true),
                );
              },
              leading: (user == null)
                  ? Icon(
                      roomUser == meInRoom ? Icons.star_border : Icons.circle,
                    )
                  : CircleAvatar(
                      child: FutureSpaceBuilder(
                        path: user.photoURL,
                        radius: 100,
                        thumbnail: true,
                      ),
                    ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (roomUser.role.value < meInRoom.role.value &&
                      roomUser != meInRoom &&
                      !roomUser.isInvite &&
                      meInRoom.isAdminOrMod)
                    AsyncLock(
                      builder: (loading, status, lock, open, setStatus) {
                        return IconButton.filledTonal(
                          onPressed: roomUser.isAdmin
                              ? null
                              : () async {
                                  lock();
                                  final res = await context.showYesNo(
                                    title: 'Do you want to promote this user?',
                                  );
                                  if (res) {
                                    await ref
                                        .read(currentRoomProvider.notifier)
                                        .upgradeAccessToRoom(roomUser);
                                    ref.invalidate(currentRoomUserProvider);
                                  }
                                  open();
                                },
                          icon: !loading
                              ? Icon(
                                  roomUser.isRequest
                                      ? Icons.check
                                      : (roomUser.isAdmin
                                            ? Icons.star
                                            : Icons.star_border),
                                )
                              : const CircularProgress(size: 20),
                        );
                      },
                    ),

                  const SizedBox(width: 5),

                  if (roomUser.role.value < meInRoom.role.value &&
                      roomUser != meInRoom &&
                      meInRoom.isAdminOrMod)
                    AsyncLock(
                      builder: (loading, status, lock, open, setStatus) {
                        return IconButton.filledTonal(
                          onPressed: () async {
                            lock();
                            final res = await context.showYesNo(
                              title: 'Do you want to kickout this user?',
                            );
                            if (res) {
                              await ref
                                  .read(currentRoomProvider.notifier)
                                  .deleteRoomUser(roomUser);
                            }
                            open();
                            // ref.read(currentRoomProvider.notifier).exitRoom(null);
                            // // ref.invalidate(currentRoomUserProvider);
                            // // if (context.mounted) {
                            // //   HomeRoute().go(context);
                            // // }
                          },
                          icon: !loading
                              ? const Icon(Icons.close)
                              : const CircularProgress(size: 20),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
      itemCount: allRoomUsers.length,
    );
  }
}
