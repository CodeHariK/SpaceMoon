import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/painter/wave_clipper.dart';
import 'package:spacemoon/Static/theme.dart';

class ShellData {
  final String? title;
  final String name;
  final List<String> location;
  final Widget icon;

  ShellData({
    this.title,
    required this.name,
    required this.location,
    required this.icon,
  }) : assert(location.isNotEmpty);
}

extension SuperShellData on List<ShellData> {
  String title(BuildContext context) => this[getCurrentIndex(context)].title ?? this[getCurrentIndex(context)].name;

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

  BottomNavigationBar bottomNavigationBar({required BuildContext context, TabController? controller}) =>
      BottomNavigationBar(
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

  CupertinoTabBar cupertinoTabBar({required BuildContext context, TabController? controller}) => CupertinoTabBar(
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

  List<NavigationRailDestination> get navRailDestinations => map(
        (e) => NavigationRailDestination(
          icon: e.icon,
          label: Text(e.name),
        ),
      ).toList();

  List<NavigationDrawerDestination> get navDrawerDestinations => map(
        (e) => NavigationDrawerDestination(
          icon: e.icon,
          label: Text(e.name),
        ),
      ).toList();

  NavigationBar navigationBar({required BuildContext context, TabController? controller}) => NavigationBar(
        selectedIndex: getCurrentIndex(context),
        onDestinationSelected: (v) => controller != null ? controller.animateTo(v) : goToIndex(context, v),
        destinations: navDestinations,
      );

  NavigationDrawer navigationDrawer({
    required BuildContext context,
    TabController? controller,
  }) =>
      NavigationDrawer(
        selectedIndex: getCurrentIndex(context),
        onDestinationSelected: (v) => controller != null ? controller.animateTo(v) : goToIndex(context, v),
        children: navDrawerDestinations,
      );

  NavigationRail navigationRail({
    required BuildContext context,
    TabController? controller,
    bool extended = false,
    NavigationRailLabelType labelType = NavigationRailLabelType.all,
    double groupAlignment = -1,
    double minExtendedWidth = 180,
    double minWidth = 72,
  }) =>
      NavigationRail(
        labelType: extended ? null : labelType,
        extended: extended,
        minExtendedWidth: minExtendedWidth,
        minWidth: minWidth,
        groupAlignment: groupAlignment,
        selectedIndex: getCurrentIndex(context),
        onDestinationSelected: (v) => controller != null ? controller.animateTo(v) : goToIndex(context, v),
        destinations: navRailDestinations,
      );

  Widget googleBar({required BuildContext context, TabController? controller}) => Container(
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

  TabBar tabBar({required BuildContext context, TabController? controller}) => TabBar(
        controller: controller,
        onTap: (v) => controller != null ? controller.animateTo(v) : goToIndex(context, v),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: map(
          (e) => Semantics(
            label: 'Go to ${e.name}',
            button: true,
            enabled: true,
            child: Tab(
              // icon: e.icon,
              text: e.name,
            ),
          ),
        ).toList(),
      );
}
