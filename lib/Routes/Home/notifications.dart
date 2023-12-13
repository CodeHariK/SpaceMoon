import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Helpers/gorouter_ext.dart';
import 'package:spacemoon/Helpers/shell_data.dart';
import 'package:spacemoon/Helpers/tab_shell.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Routes/Home/all_chat.dart';

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

class NotificationsPage extends HookWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = useState(0);

    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            state.value++;
          },
          child: Text('Notification ${state.value}'),
        ),
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
