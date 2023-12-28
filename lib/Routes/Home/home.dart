import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/gorouter_ext.dart';
import 'package:spacemoon/Helpers/shell_data.dart';
import 'package:spacemoon/Helpers/tab_shell.dart';
import 'package:spacemoon/Routes/Home/Chat/Info/chat_info.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/all_chat.dart';
import 'package:spacemoon/Routes/Home/account.dart';
import 'package:spacemoon/Routes/Home/notifications.dart';
import 'package:spacemoon/Routes/Home/profile.dart';
import 'package:spacemoon/Routes/Home/search.dart';
import 'package:spacemoon/Routes/Home/settings.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Static/theme.dart';

part 'home.g.dart';

class Home {
  static final routes = $appRoutes;
}

@TypedGoRoute<ExitRoute>(
  path: AppRouter.home,
  routes: [
    //
    TypedGoRoute<SettingsRoute>(path: AppRouter.settings),
    TypedGoRoute<AccountRoute>(path: AppRouter.account),

    TypedStatefulShellRoute<NotificationShell>(
      branches: [
        TypedStatefulShellBranch<NotificationShellBranchData>(
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<NotificationsRoute>(name: AppRouter.notification, path: AppRouter.notification),
          ],
        ),
        TypedStatefulShellBranch<NotificationShellBranchData>(
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<SubscriptionsRoute>(name: AppRouter.subscription, path: AppRouter.subscription),
          ],
        ),
      ],
    ),

    TypedStatefulShellRoute<HomeShellRoute>(
      branches: [
        TypedStatefulShellBranch<HomeShellBranchData>(
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<HomeRoute>(
              name: AppRouter.allchat,
              path: AppRouter.allchat,
              routes: [
                TypedGoRoute<ChatRoute>(
                  path: AppRouter.chat,
                  routes: [
                    // TypedGoRoute<TweetRoute>(path: AppRouter.tweet),
                    TypedGoRoute<ChatInfoRoute>(path: AppRouter.chatInfo),
                  ],
                ),
              ],
            ),
          ],
        ),
        TypedStatefulShellBranch<HomeShellBranchData>(
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<SearchRoute>(name: AppRouter.search, path: AppRouter.search),
          ],
        ),
        TypedStatefulShellBranch<HomeShellBranchData>(
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<ProfileRoute>(name: AppRouter.profile, path: AppRouter.profile),
          ],
        ),
      ],
    )
  ],
)
class ExitRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadePage(
      context,
      state,
      const ExitPage(navigator: AllChatPage()),
    );
  }

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return state.match(AppRouter.home) ? (AppRouter.home + AppRouter.allchat) : null;
  }
}

class HomeRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadePage(context, state, const AllChatPage());
  }
}

class HomeShellRoute extends StatefulShellRouteData {
  const HomeShellRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = AppRouter.homeShellNavigatorKey;

  static List<ShellData> data = [
    ShellData(
        name: 'Chat', title: 'Spacemoon', location: [AppRouter.allchat], icon: const Icon(Icons.chat_bubble_outline)),
    ShellData(name: 'Search', location: [AppRouter.search], icon: const Icon(Icons.search)),
    // ShellData(
    //     name: 'Notification',
    //     location: ['notification', 'subscription'],
    //     icon: const Icon(Icons.notifications_none_rounded)),
    ShellData(name: 'Profile', location: [AppRouter.profile], icon: const Icon(Icons.face_2_outlined)),
  ];

  @override
  Widget builder(BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
    return navigationShell;
  }

  static actions(context) => [
        IconButton(
          onPressed: () {
            NotificationsRoute().push(context);
          },
          icon: const Icon(
            Icons.notifications_none_outlined,
            semanticLabel: 'Open notifications',
          ),
        ),
        IconButton(
          onPressed: () {
            SettingsRoute().push(context);
          },
          icon: const Icon(
            Icons.settings,
            semanticLabel: 'Open settings',
          ),
        ),
      ];

  static Widget $navigatorContainerBuilder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) => TabShell(
        navigationShell: navigationShell,
        shellData: data,
        showTabbar: AppTheme.isTab,
        showNavigationBar: false,
        showNavigationRail: !AppTheme.isTab,
        actions: actions(context),
        children: children,
      ),
    );
  }
}

class HomeShellBranchData extends StatefulShellBranchData {
  // static const String $restorationScopeId = 'restorationScopeId';
  const HomeShellBranchData();
}

class ExitPage extends StatelessWidget {
  const ExitPage({
    super.key,
    required this.navigator,
  });

  final Widget navigator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(HomeShellRoute.data.title(context)),
        actions: HomeShellRoute.actions(context),
      ),
      body: navigator,
      extendBody: true,
      bottomNavigationBar: HomeShellRoute.data.bottomNavigationBar(context: context),
    );
  }
}
