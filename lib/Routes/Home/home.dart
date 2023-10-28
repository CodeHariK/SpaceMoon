import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/all_chat.dart';
import 'package:spacemoon/Routes/Home/account.dart';
import 'package:spacemoon/Routes/Home/profile.dart';
import 'package:spacemoon/Routes/Home/search.dart';
import 'package:spacemoon/Routes/Home/settings.dart';
import 'package:spacemoon/Providers/router.dart';

part 'home.g.dart';

class Home {
  static final routes = $appRoutes;
}

class ShellData {
  final String name;
  final String location;
  final Icon icon;

  ShellData({
    required this.name,
    required this.location,
    required this.icon,
  });
}

extension SuperShellData on List<ShellData> {
  BottomNavigationBar bottomNavigationBar(BuildContext context) => BottomNavigationBar(
        currentIndex: getCurrentIndex(context),
        onTap: (v) {
          context.go(this[v].location);
        },
        items: map(
          (e) => BottomNavigationBarItem(
            icon: e.icon,
            label: e.name,
          ),
        ).toList(),
      );

  int getCurrentIndex(BuildContext context) {
    try {
      final String location = GoRouterState.of(context).uri.toString();
      final i = indexWhere((e) {
        return location.endsWith(e.location);
      });
      return i == -1 ? 0 : i;
    } catch (e) {
      log('Error : $e');
    }
    return 0;
  }
}

@TypedShellRoute<HomeShellRoute>(
  routes: [
    TypedGoRoute<SearchRoute>(path: AppRouter.search),
    TypedGoRoute<ProfileRoute>(path: AppRouter.profile),
    TypedGoRoute<HomeRoute>(
      path: AppRouter.home,
      routes: [
        //
        TypedGoRoute<SettingsRoute>(path: AppRouter.settings),
        TypedGoRoute<AccountRoute>(path: AppRouter.account),

        //
        TypedGoRoute<ChatRoute>(path: AppRouter.chat),
      ],
    )
  ],
)
class HomeShellRoute extends ShellRouteData {
  const HomeShellRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = AppRouter.homeShellNavigatorKey;

  static List<ShellData> data = [
    ShellData(name: 'Chat', location: AppRouter.home, icon: const Icon(Icons.chat_bubble_outline)),
    ShellData(name: 'Search', location: AppRouter.search, icon: const Icon(Icons.search)),
    ShellData(name: 'Profile', location: AppRouter.profile, icon: const Icon(Icons.face_2_outlined)),
  ];

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
      bottomNavigationBar: HomeShellRoute.data.bottomNavigationBar(context),
    );
  }
}

class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AllChatPage();
  }
}
