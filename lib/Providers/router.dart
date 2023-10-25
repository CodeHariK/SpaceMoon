import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Auth/auth_routes.dart';
import 'package:spacemoon/Page/error_page.dart';
import 'package:spacemoon/Page/home.dart';
import 'package:spacemoon/Page/onboard.dart';
import 'package:spacemoon/Providers/auth.dart';

part 'router.g.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
  // static final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();
}

final ValueNotifier<RoutingConfig> myConfig = ValueNotifier<RoutingConfig>(
  _generateRoutingConfig(false),
);

final GoRouter router = GoRouter.routingConfig(
  navigatorKey: AppRouter.rootNavigatorKey,
  routingConfig: myConfig,
  initialLocation: LoginRoute.path,
  errorPageBuilder: (context, state) => MaterialPage(child: ErrorPage(state: state)),
);

RoutingConfig _generateRoutingConfig(bool authenticated) {
  return RoutingConfig(
    redirect: (context, state) {
      log('Redirect ${state.uri}');
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(child: HomePage()),
      ),
      ...Auth.routes,
      ...Onboard.routes,
    ],
  );
}

@Riverpod(keepAlive: true)
Future routerRedirector(RouterRedirectorRef ref) async {
  // final onboarded = ref.watch(onboardedProvider);
  final user = ref.watch(currentUserProvider).value;

  myConfig.value = _generateRoutingConfig(user != null);

  return false;
}
