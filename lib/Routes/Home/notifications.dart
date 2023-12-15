import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/painter/dashed_border.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/gorouter_ext.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Helpers/shell_data.dart';
import 'package:spacemoon/Helpers/tab_shell.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/all_chat.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Widget/AppFlowy/app_flowy.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';

final GlobalKey<NavigatorState> tabShellNavigatorKey = GlobalKey<NavigatorState>();

class NotificationShell extends StatefulShellRouteData {
  const NotificationShell();

  static final GlobalKey<NavigatorState> $navigatorKey = tabShellNavigatorKey;

  static List<ShellData> data = [
    ShellData(
      name: 'Notification',
      location: [AppRouter.notification],
      icon: const Icon(Icons.notifications_none_rounded),
    ),
    ShellData(name: 'Subscription', location: [AppRouter.subscription], icon: const Icon(Icons.subject_sharp)),
  ];

  @override
  Page<void> pageBuilder(BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
    return fadePage(context, state, navigationShell);
  }

  static Widget $navigatorContainerBuilder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) {
    return TabShell(
      navigationShell: navigationShell,
      shellData: NotificationShell.data,
      canPop: true,
      showTabbar: true,
      showNavigationBar: false,
      children: children,
    );
  }
}

class NotificationShellBranchData extends StatefulShellBranchData {
  const NotificationShellBranchData();
}

class SubscriptionShellBranchData extends StatefulShellBranchData {
  const SubscriptionShellBranchData();
}

class NotificationsRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadePage(context, state, const NotificationsPage());
  }
}

class SubscriptionsRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadePage(context, state, const SubscriptionsPage());
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static final StreamController<Tweet> tweetStream = StreamController<Tweet>.broadcast()
    ..stream.listen((tweet) {
      //
      _tweets.add(tweet);
    });

  static final List<Tweet> _tweets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: tweetStream.stream,
        builder: (context, snapshot) {
          if (_tweets.isEmpty) {
            return const Center(
              child: Text('Empty'),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              cacheExtent: 1000,
              itemCount: _tweets.length,
              itemBuilder: (context, index) {
                final t = _tweets[index];

                return Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    final tweet = ref.watch(getTweetByIdProvider(t)).value;
                    final room = ref.watch(getRoomByIdProvider(t.room)).value;
                    if (tweet == null) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
                      child: DashedBorderContainer(
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () {
                            ChatRoute(chatId: t.room).push(context);
                          },
                          child: IgnorePointer(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 6,
                                    color: Colors.primaries[index % 12],
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text.rich(
                                      TextSpan(
                                        text: room?.displayName ?? '-',
                                        children: [
                                          TextSpan(
                                            text: ' @ ${tweet.created.timeString}',
                                            style: context.ls,
                                          ),
                                        ],
                                      ),
                                      style: context.ts,
                                    ),
                                  ),
                                  if (tweet.mediaType == MediaType.TEXT)
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(tweet.text, style: context.tm),
                                    ),
                                  if (tweet.mediaType == MediaType.POST)
                                    SizedBox(
                                      width: 300,
                                      height: 300,
                                      child: AppFlowy(
                                        key: ObjectKey(tweet),
                                        jsonData: tweet.text,
                                        showAppbar: false,
                                      ),
                                    ),
                                  if (tweet.mediaType == MediaType.GALLERY) GalleryBox(tweet: tweet),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AllChatPage(
      subscription: true,
    );
  }
}
