import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:spacemoon/Static/theme.dart';

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

  Widget googleBar(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.high,
          borderRadius: BorderRadius.circular(16),
          // boxShadow: [
          //   BoxShadow(
          //     offset: const Offset(0, 4),
          //     blurRadius: 4,
          //     spreadRadius: 2,
          //     color: AppTheme.darkness ? const Color.fromARGB(255, 47, 47, 47) : const Color.fromARGB(70, 72, 72, 72),
          //   ),
          // ],
        ),
        height: 76,
        padding: const EdgeInsets.only(bottom: 2),
        margin: context.mq.pad.copyWith(top: 0, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: asMap()
              .map(
                (i, e) => MapEntry(
                  i,
                  InkWell(
                    onTap: () {
                      context.go(this[i].location);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundColor: getCurrentIndex(context) != i ? Colors.transparent : null,
                          child: e.icon,
                        ),
                        Text(e.name),
                      ],
                    ),
                  ),
                ),
              )
              .values
              .toList(),
        ),
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
