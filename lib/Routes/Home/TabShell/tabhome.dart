import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Helpers/shell_data.dart';

final GlobalKey<NavigatorState> tabShellNavigatorKey = GlobalKey<NavigatorState>();

class TabShellRoute extends ShellRouteData {
  const TabShellRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = tabShellNavigatorKey;

  static List<ShellData> data = [
    ShellData(name: 'Tab1', location: '/tabhome/tab1', icon: const Icon(Icons.mode_of_travel)),
    ShellData(name: 'Tab2', location: '/tabhome/tab2', icon: const Icon(Icons.face_2_outlined)),
  ];

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabShell'),
        ),
        body: Column(
          children: [
            Container(
              height: 400,
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  TabShellRoute.data.tabBar(context),
                  Expanded(
                    child: navigator,
                  ),
                ],
              ),
            ),
            const Text('Shell'),
          ],
        ),
      ),
    );
  }
}

class TabHomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TabHomePage();
  }

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return '/tabhome/tab1';
  }
}

class TabHomePage extends StatelessWidget {
  const TabHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabHome'),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}

class Tab1Route extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Tab1Page();
  }
}

class Tab1Page extends StatelessWidget {
  const Tab1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab1'),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}

class Tab2Route extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Tab2Page();
  }
}

class Tab2Page extends StatelessWidget {
  const Tab2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab2'),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
