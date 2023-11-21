import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/widgets/shimmer_boxes.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Routes/Special/error_page.dart';
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
    final allUsersPro = ref.watch(getAllMyUsersProvider);
    final allUsers = allUsersPro.value ?? [];

    useEffect(() {
      ref.read(currentRoomProvider.notifier).updateRoom(id: chatId);

      return null;
    }, [room]);

    if (room == null) {
      return const Error404Page();
    }

    if (allUsersPro.isLoading) {
      return const Scaffold();
    }

    if ((meInRoom == null || meInRoom.role == Role.REQUEST) && room.open != Visible.OPEN) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              Text('Me in room : $meInRoom'),
              Text(room.toString()),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat $chatId'),
      ),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 240,
                width: 240,
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  splashFactory: InkSplash.splashFactory,
                  onTap: () async {
                    final imageMetadata = await selectImageMedia();

                    if (imageMetadata == null) return;

                    // await uploadFire(
                    //   meta: imageMetadata,
                    //   imageName: 'profile',
                    //   user: user!.uid,
                    //   location: 'users/${user.uid}',
                    //   singlepath: Const.photoURL.name,
                    // );
                  },
                  child: room.photoURL.isEmpty == true
                      ? const Icon(
                          CupertinoIcons.person_crop_circle_badge_plus,
                          size: 120,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(250),
                          child: CustomCacheImage(
                            imageUrl: thumbImage(room.photoURL),
                          ),
                        ),
                ),
              ),
            ),
          ),
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
                    if (!roomUser.isAdminOrMod && roomUser != meInRoom && meInRoom!.isAdminOrMod)
                      IconButton(
                        onPressed: () {
                          ref.read(currentRoomProvider.notifier).deleteRoomUser(roomUser);
                        },
                        icon: const Icon(Icons.close),
                      )
                  ],
                ),
              );
            },
            itemCount: allUsers.length,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Text(room.toString()),
              ],
            ),
          ),
          // Text(meInRoom.toString()),
          // FilledButton(
          //   onPressed: () {
          //     ref.read(currentRoomProvider.notifier).deleteRoomUser(meInRoom!);
          //   },
          //   child: const Text('Leave Room'),
          // ),
        ],
      ),
    );
  }
}



// class RoomUpdateDialog extends HookConsumerWidget {
//   final String id;

//   const RoomUpdateDialog(this.id, {super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final room = ref.read(currentRoomProvider).value;

//     final roomNameCon = useTextEditingController(text: room?.nam);
//     final roomNickCon = useTextEditingController(text: room?.nick);
//     final roomDescriptionCon = useTextEditingController(text: room?.description);
//     final roomOpen = useState(room?.open);
//     final roomAvatar = useState(room?.avatar);

//     final formKey = useState(GlobalKey<FormState>());

//     return Form(
//       key: formKey.value,
//       child: Dialog(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // FireImage(
//                 //   location: '${room?.id}/avatar',
//                 //   imageUrl: '${room?.avatar}',
//                 //   function: (url) {
//                 //     roomAvatar.value = url;
//                 //   },
//                 // ),
//                 TextFormField(
//                   controller: roomNameCon,
//                   decoration: const InputDecoration(
//                     hintText: 'Name',
//                     labelText: 'Change Room name',
//                   ),
//                   textInputAction: TextInputAction.next,
//                 ),
//                 TextFormField(
//                   controller: roomDescriptionCon,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Empty';
//                     }
//                     return null;
//                   },
//                   decoration: const InputDecoration(
//                     labelText: 'Change Room Description',
//                     hintText: 'Description',
//                   ),
//                   textInputAction: TextInputAction.next,
//                 ),
//                 TextFormField(
//                   controller: roomNickCon,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Empty';
//                     }
//                     return null;
//                   },
//                   decoration: const InputDecoration(
//                     labelText: 'Nickname',
//                     contentPadding: EdgeInsets.zero,
//                     hintText: 'Change nickname of room',
//                   ),
//                   textInputAction: TextInputAction.next,
//                 ),
//                 DropdownButtonFormField(
//                   value: roomOpen.value,
//                   items: Visible.values
//                       .map(
//                         (e) => DropdownMenuItem(
//                           child: Text(e.name),
//                           value: e,
//                         ),
//                       )
//                       .toList(),
//                   borderRadius: 20.br,
//                   decoration: InputDecoration(
//                     labelText: 'Visiblity',
//                     contentPadding: EdgeInsets.zero,
//                     // constraints: BoxConstraints(maxWidth: 200),
//                   ),
//                   onChanged: (value) {
//                     roomOpen.value = value;
//                   },
//                 ),
//                 // Flexible(
//                 //   child: Center(
//                 //     child: FilledButton.tonal(
//                 //       child: const Text('Save'),
//                 //       onPressed: () {
//                 //         if (formKey.value.currentState?.validate() ?? false) {
//                 //           dino({
//                 //             Const.nam.name: roomNameCon.text,
//                 //             Const.nick.name: roomNickCon.text,
//                 //             Const.description.name: roomDescriptionCon.text,
//                 //             Const.avatar.name: roomAvatar.value,
//                 //             Const.open.name: roomOpen.value,
//                 //           }.toString());
//                 //           ref.read(currentRoomProvider.notifier).updateRoomInfo(
//                 //                 roomName: roomNameCon.text,
//                 //                 nick: roomNickCon.text,
//                 //                 description: roomDescriptionCon.text,
//                 //                 avatar: roomAvatar.value,
//                 //                 open: roomOpen.value ?? Visible.CLOSE,
//                 //               );
//                 //         }
//                 //       },
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
