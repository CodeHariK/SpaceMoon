import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        type: BottomNavigationBarType.fixed,
      );

  String title(BuildContext context) => this[getCurrentIndex(context)].name;

  NavigationBar navigationBar(BuildContext context) => NavigationBar(
        selectedIndex: getCurrentIndex(context),
        onDestinationSelected: (v) {
          context.go(this[v].location);
        },
        destinations: map(
          (e) => NavigationDestination(
            icon: e.icon,
            label: e.name,
          ),
        ).toList(),
      );

  TabBar tabBar(BuildContext context) => TabBar(
        onTap: (v) {
          context.go(this[v].location);
        },
        tabs: map(
          (e) => Tab(
            // icon: e.icon,
            text: e.name,
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
