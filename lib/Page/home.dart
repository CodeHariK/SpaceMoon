import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Page/onboard.dart';
import 'package:spacemoon/Page/profile.dart';
import 'package:spacemoon/Page/settings.dart';
import 'package:spacemoon/Providers/router.dart';

part 'home.g.dart';

class Home {
  static final routes = $appRoutes;
}

@TypedGoRoute<HomeRoute>(path: AppRouter.home)
@immutable
class HomeRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              ProfileRoute().push(context);
            },
            child: const Text('Profile'),
          ),
          TextButton(
            onPressed: () {
              OnboardRoute().push(context);
            },
            child: const Text('Onboard'),
          ),
          TextButton(
            onPressed: () {
              SettingsRoute().push(context);
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
