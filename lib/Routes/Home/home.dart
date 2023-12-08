import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Helpers/shell_data.dart';
import 'package:spacemoon/Routes/Home/Chat/Info/chat_info.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/all_chat.dart';
import 'package:spacemoon/Routes/Home/account.dart';
import 'package:spacemoon/Routes/Home/profile.dart';
import 'package:spacemoon/Routes/Home/search.dart';
import 'package:spacemoon/Routes/Home/settings.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Widget/Chat/tweet_box.dart';

part 'home.g.dart';

class Home {
  static final routes = $appRoutes;
}

@TypedShellRoute<HomeShellRoute>(
  routes: [
    TypedGoRoute<SearchRoute>(path: AppRouter.search),
    TypedGoRoute<ProfileRoute>(path: AppRouter.profile),

    // TypedGoRoute<TabHomeRoute>(path: '/tabhome', routes: [
    //   //
    //   TypedShellRoute<TabShellRoute>(routes: [
    //     TypedGoRoute<Tab1Route>(path: 'tab1'),
    //     TypedGoRoute<Tab2Route>(path: 'tab2'),
    //   ]),
    // ]),

    // TypedShellRoute<TabShellRoute>(routes: [
    //   TypedGoRoute<UnsplashRoute>(path: '/tabhome/tab1'),
    //   TypedGoRoute<Tab2Route>(path: '/tabhome/tab2'),
    // ]),

    //
    TypedGoRoute<HomeRoute>(
      path: AppRouter.home,
      routes: [
        //
        TypedGoRoute<SettingsRoute>(path: AppRouter.settings),
        TypedGoRoute<AccountRoute>(path: AppRouter.account),

        //
        TypedGoRoute<ChatRoute>(
          path: AppRouter.chat,
          routes: [
            TypedGoRoute<TweetRoute>(path: AppRouter.tweet),
            TypedGoRoute<ChatInfoRoute>(path: AppRouter.chatInfo),
          ],
        ),
      ],
    )
  ],
)
class HomeShellRoute extends ShellRouteData {
  const HomeShellRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = AppRouter.homeShellNavigatorKey;

  static List<ShellData> data = [
    // ShellData(name: 'TabHome', location: '/tabhome/tab1', icon: const Icon(Icons.mode_of_travel)),
    ShellData(name: 'Spacemoon', location: AppRouter.home, icon: const Icon(Icons.chat_bubble_outline)),
    ShellData(name: 'Search', location: AppRouter.search, icon: const Icon(Icons.search)),
    ShellData(name: 'Profile', location: AppRouter.profile, icon: const Icon(Icons.face_2_outlined)),
  ];

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HomeShellRoute.data.title(context)),
        actions: [
          IconButton(
            onPressed: () {
              SettingsRoute().push(context);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: navigator,
      extendBody: true,
      bottomNavigationBar: HomeShellRoute.data.bottomNavigationBar(context),
    );
  }
}

class HomeRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const CupertinoPage(
      child: AllChatPage(),
    );
  }
}
