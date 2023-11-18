import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Routes/Special/error_page.dart';

import 'dart:math' as math;

import 'package:moonspace/Helper/debug_functions.dart';
import 'package:moonspace/Helper/extensions.dart';

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

    useEffect(() {
      ref.read(currentRoomProvider.notifier).updateRoom(id: chatId);

      return null;
    }, [room]);

    if (room == null) {
      return const Error404Page();
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
      body: Column(
        children: [
          LimitedBox(
            maxHeight: 200,
            child: Consumer(
              builder: (context, ref, child) {
                final allUsers = ref.watch(getAllMyUsersProvider);
                return allUsers.when(
                  data: (data) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final roomUser = data[index]!;
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
                      itemCount: data.length,
                    );
                  },
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const CircularProgressIndicator(),
                );
              },
            ),
          ),
          Text(room.toString()),
          Text(meInRoom.toString()),
          FilledButton(
            onPressed: () {
              ref.read(currentRoomProvider.notifier).deleteRoomUser(meInRoom!);
            },
            child: const Text('Leave Room'),
          ),
        ],
      ),
    );
  }
}

// class RoomInfo extends StatefulHookConsumerWidget {
//   const RoomInfo(this.id, {super.key});

//   final String id;

//   @override
//   ConsumerState<RoomInfo> createState() => _RoomInfoState();
// }

// class _RoomInfoState extends ConsumerState<RoomInfo> {
//   @override
//   Widget build(BuildContext context) {
//     final roomProvider = ref.watch(currentRoomProvider);
//     final me = ref.watch(currentRoomUserProvider)!;

//     final scrollCon = useScrollController();
//     final scrollPer = useState(0.0);

//     ref.listen(
//       currentRoomProvider,
//       (prev, next) {
//         if (next.value == null) {
//           GoRouter.of(context).pop();
//         }
//       },
//     );

//     useEffect(() {
//       void scrollUpdate() {
//         scrollPer.value = math.min(
//           1,
//           math.max(
//             0,
//             (1 - scrollCon.offset / (200 - 80)),
//           ),
//         );
//         // setState(() {});
//       }

//       scrollCon.addListener(scrollUpdate);

//       dino('Use Effect');

//       return () {
//         scrollCon.removeListener(scrollUpdate);
//         // scrollCon.dispose();
//       };
//     }, [scrollCon]);

//     return roomProvider.when(
//       data: (room) {
//         return DefaultTabController(
//           length: 2,
//           child: Scaffold(
//             body: CustomScrollView(
//               controller: scrollCon,

//               //
//               physics: BouncingScrollPhysics(),

//               //
//               slivers: [
//                 SliverAppBar(
//                   expandedHeight: 200,
//                   // flexibleSpace: Image.network(
//                   //   'https://vedicfeed.com/wp-content/uploads/2019/08/satyabhama-killing-narakasura.jpg',
//                   //   fit: BoxFit.cover,
//                   // ),

//                   primary: true,

//                   backgroundColor: context.theme.pri,
//                   collapsedHeight: 80,
//                   shadowColor: Colors.yellow,

//                   flexibleSpace: FlexibleSpaceBar(
//                     stretchModes: [
//                       StretchMode.fadeTitle,
//                       StretchMode.zoomBackground,
//                       StretchMode.blurBackground,
//                     ],
//                     background: Container(
//                       foregroundDecoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.blue.withOpacity(0.4),
//                             Colors.purple.withOpacity(0.0),
//                           ],
//                         ),

//                         color: Colors.blue,

//                         // backgroundBlendMode: BlendMode.color,

//                         //
//                         // image: DecorationImage(
//                         //   image: NetworkImage(
//                         //     'https://vedicfeed.com/wp-content/uploads/2019/08/satyabhama-killing-narakasura.jpg',
//                         //   ),
//                         //   fit: BoxFit.cover,
//                         // ),
//                       ),
//                       child: Stack(
//                         children: [
//                           Positioned.fill(
//                             child: Image.network(
//                               'https://vedicfeed.com/wp-content/uploads/2019/08/satyabhama-killing-narakasura.jpg',
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           if (scrollCon.hasClients)
//                             Positioned(
//                               left: context.mq.w * 0.5 * scrollPer.value,
//                               top: 100 * scrollPer.value,
//                               child: Container(
//                                 width: 50 * scrollPer.value,
//                                 height: 50 * scrollPer.value,
//                                 color: Colors.white,
//                                 child: Text(scrollPer.value.toStringAsFixed(2)),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),

//                     //
//                     centerTitle: true,
//                     title: Text('${room?.nick}'),
//                   ),

//                   // bottom: PreferredSize(
//                   //   preferredSize: Size.fromHeight(4.0),
//                   //   child: Opacity(
//                   //     opacity: 1,
//                   //     child: Container(
//                   //       height: 40.0,
//                   //       color: Colors.blue,
//                   //     ),
//                   //   ),
//                   // ),

//                   // bottom: TabBar(
//                   //   // labelColor: Colors.red,
//                   //   dividerColor: Colors.yellow,
//                   //   indicatorColor: Colors.blue,
//                   //   unselectedLabelColor: Colors.cyan,
//                   //   indicator: BoxDecoration(
//                   //     border: Border.all(),
//                   //   ),
//                   //   // indicatorPadding: 8.e,
//                   //   indicatorSize: TabBarIndicatorSize.label,
//                   //   tabs: [
//                   //     Tab(
//                   //       text: 'Hello',
//                   //     ),
//                   //     Tab(
//                   //       text: 'Hello',
//                   //     ),
//                   //   ],
//                   // ),

//                   //
//                   actions: [
//                     IconButton(
//                       icon: Icon(Icons.exit_to_app),
//                       onPressed: () {
//                         ref.watch(currentRoomProvider.notifier).leaveRoom();
//                       },
//                     ),
//                   ],

//                   //
//                   snap: true,
//                   pinned: true,
//                   floating: true,

//                   //
//                   surfaceTintColor: Colors.red,
//                   foregroundColor: context.theme.csBg,

//                   //
//                   title: Text(room?.displayName ?? 'Room name', style: 15.ts),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Text('${room?.description}'),
//                 ),
//                 SliverToBoxAdapter(
//                   child: FilledButton.tonal(
//                     child: Text('update room'),
//                     onPressed: () {
//                       if (room?.uid != null) {
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return RoomUpdateDialog(room!.uid);
//                           },
//                         );
//                       }
//                     },
//                   ),
//                 ),
//                 SliverPadding(
//                   padding: (16, 4, 16, 4).e,
//                   sliver: SliverToBoxAdapter(
//                     child: Text('Members', style: 20.ts.c(context.theme.csOnBg).bold),
//                   ),
//                 ),
//                 SliverList.builder(
//                   itemCount: room?.members.length ?? 0,
//                   itemBuilder: (context, index) {
//                     //
//                     return Consumer(
//                       builder: (context, ref, child) {
//                         final memberProvider = ref.watch(
//                           GetUserByIdProvider(room!.members[index].id),
//                         );
//                         return memberProvider.when(
//                           data: (member) {
//                             return ListTile(
//                               tileColor: me.id == room.members[index].id ? context.theme.pri : null,
//                               onLongPress: (me.isAdminOrMod &&
//                                       me.id != room.members[index].id &&
//                                       room.members[index].role.value <= Role.USER.value)
//                                   ? () async {
//                                       // if (await showYesNo(
//                                       //   context,
//                                       //   title: 'Kick user out',
//                                       //   content: '',
//                                       // )) {
//                                       //   ref.read(currentRoomProvider.notifier).kickUser(room.members[index]);
//                                       // }
//                                     }
//                                   : null,
//                               leading: ClipRRect(
//                                 borderRadius: 30.br,
//                                 child: Image.network(
//                                   '${member?.avatar}',
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Icon(Icons.person);
//                                   },
//                                 ),
//                               ),
//                               title: Text('${member?.nam}'),
//                               subtitle: Text('${member?.email ?? member?.phone}'),
//                               trailing: ((me.isAdminOrMod) && room.members[index].isRequest)
//                                   ? ElevatedButton(
//                                       onPressed: () {
//                                         ref.read(currentRoomProvider.notifier).changeRole(
//                                               room.members[index],
//                                               Role.USER,
//                                             );
//                                       },
//                                       child: Text(room.members[index].role.name),
//                                     )
//                                   : Text(room.members[index].role.name),
//                             );
//                           },
//                           error: (error, stackTrace) => Text('Error'),
//                           loading: () => ListTile(
//                             leading: CircularProgressIndicator(),
//                             title: Text('${room.members[index].id}'),
//                             trailing: Text('${room.members[index].role.name}'),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       error: (error, stackTrace) {
//         return Text(error.toString());
//       },
//       loading: () {
//         return const Scaffold(
//           body: Center(
//             child: CircularProgressIndicator.adaptive(),
//           ),
//         );
//       },
//     );
//   }
// }

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
