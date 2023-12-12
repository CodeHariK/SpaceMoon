import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spacemoon/Helpers/shell_data.dart';

final GlobalKey<NavigatorState> tabShellNavigatorKey = GlobalKey<NavigatorState>();

class NotificationShell extends StatefulShellRouteData {
  const NotificationShell();

  static final GlobalKey<NavigatorState> $navigatorKey = tabShellNavigatorKey;

  static List<ShellData> data = [
    ShellData(name: 'Notification', location: ['notification'], icon: const Icon(Icons.mode_of_travel)),
    ShellData(name: 'Subscription', location: ['subscription'], icon: const Icon(Icons.face_2_outlined)),
  ];

  @override
  Widget builder(BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
    return navigationShell;
  }

  static Widget $navigatorContainerBuilder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) {
    return NotificationShellPage(
      navigationShell: navigationShell,
      children: children,
    );
  }
}

class NotificationShellPage extends HookConsumerWidget {
  const NotificationShellPage({
    super.key,
    required this.navigationShell,
    required this.children,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabcon = useTabController(initialLength: NotificationShell.data.length, initialIndex: 0);

    void goTo() {
      if (!tabcon.indexIsChanging) {
        navigationShell.goBranch(tabcon.index);
      }
    }

    useEffect(() {
      tabcon.addListener(goTo);

      return () {
        tabcon.removeListener(goTo);
      };
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            NotificationShell.data.tabBar(context, controller: tabcon),
            Expanded(
              child: TabBarView(
                controller: tabcon,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationShellBranchData extends StatefulShellBranchData {
  // static const String $restorationScopeId = 'restorationScopeId';
  const NotificationShellBranchData();
}

class SubscriptionShellBranchData extends StatefulShellBranchData {
  // static const String $restorationScopeId = 'restorationScopeId';
  const SubscriptionShellBranchData();
}

class NotificationsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Notifications();
  }
}

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Notification')),
    );
  }
}

class SubscriptionsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SubscriptionsPage();
  }
}

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Subscription')),
    );
  }
}
