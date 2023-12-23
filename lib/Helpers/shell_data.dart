import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/painter/wave_clipper.dart';
import 'package:spacemoon/Static/theme.dart';

class ShellData {
  final String name;
  final List<String> location;
  final Widget icon;

  ShellData({
    required this.name,
    required this.location,
    required this.icon,
  }) : assert(location.isNotEmpty);
}

extension SuperShellData on List<ShellData> {
  String title(BuildContext context) => this[getCurrentIndex(context)].name;

  int getCurrentIndex(BuildContext context) {
    try {
      final String location = GoRouterState.of(context).uri.toString();
      final i = indexWhere(
        (shelldata) {
          return -1 !=
              shelldata.location.indexWhere((element) {
                return location.contains(element);
              });
        },
      );
      return i == -1 ? 0 : i;
    } catch (e) {
      log('Error : $e');
    }
    return 0;
  }

  void goToIndex(BuildContext context, int v) => context.goNamed(this[v].location.first);

  BottomNavigationBar bottomNavigationBar(BuildContext context, {TabController? controller}) => BottomNavigationBar(
        currentIndex: getCurrentIndex(context),
        onTap: (v) => controller != null ? controller.animateTo(v) : goToIndex(context, v),
        items: map(
          (e) => BottomNavigationBarItem(
            icon: e.icon,
            label: e.name,
          ),
        ).toList(),
        type: BottomNavigationBarType.fixed,
      );

  CupertinoTabBar cupertinoTabBar(BuildContext context, {TabController? controller}) => CupertinoTabBar(
        currentIndex: getCurrentIndex(context),
        onTap: (v) => controller != null ? controller.animateTo(v) : goToIndex(context, v),
        items: map(
          (e) => BottomNavigationBarItem(
            icon: e.icon,
            label: e.name,
          ),
        ).toList(),
      );

  List<NavigationDestination> get navDestinations => map(
        (e) => NavigationDestination(
          icon: e.icon,
          label: e.name,
        ),
      ).toList();

  NavigationBar navigationBar(BuildContext context, {TabController? controller}) => NavigationBar(
        selectedIndex: getCurrentIndex(context),
        onDestinationSelected: (v) => controller != null ? controller.animateTo(v) : goToIndex(context, v),
        destinations: map(
          (e) => NavigationDestination(
            icon: e.icon,
            label: e.name,
          ),
        ).toList(),
      );

  Widget googleBar(BuildContext context, {TabController? controller}) => Container(
        color: Colors.transparent,
        margin: context.mq.pad.copyWith(top: 0, left: 16, right: 16),
        child: PhysicalShape(
          color: AppTheme.card,
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          clipper: const WaveClipper(
            numXDiv: 16,
          ),
          child: SizedBox(
            height: 78,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: asMap()
                  .map(
                    (v, e) => MapEntry(
                      v,
                      InkWell(
                        onTap: () => controller != null ? controller.animateTo(v) : goToIndex(context, v),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              backgroundColor: getCurrentIndex(context) != v ? Colors.transparent : null,
                              child: e.icon,
                            ),
                            // Text(e.name, style: context.ls),
                          ],
                        ),
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          ),
        ),
      );

  TabBar tabBar(BuildContext context, {TabController? controller}) => TabBar(
        controller: controller,
        onTap: (v) => controller != null ? controller.animateTo(v) : goToIndex(context, v),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: map(
          (e) => Tab(
            // icon: e.icon,
            text: e.name,
          ),
        ).toList(),
      );
}
