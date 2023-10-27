import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Auth/auth_routes.dart';
import 'package:spacemoon/Page/error_page.dart';
import 'package:spacemoon/Page/home.dart';
import 'package:spacemoon/Page/onboard.dart';
import 'package:spacemoon/Page/profile.dart';
import 'package:spacemoon/Page/settings.dart';
import 'package:spacemoon/Providers/auth.dart';

part 'router.g.dart';

extension ValidateRouterState on GoRouterState {
  bool get isAuth => uri.path.contains('/auth');
  bool match(String path) => uri.path == path;
}

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
  // static final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

  //Auth
  static const String login = '/auth/login';
  static const String phone = '/auth/phone';
  static const String sms = '/auth/sms';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String emailLinkSignIn = '/auth/email-link-sign-in';

  //
  static const String home = '/';

  //
  static const String profile = '/profile';

  //
  static const String onboard = '/onboard';

  //
  static const String settings = '/settings';
}

final ValueNotifier<RoutingConfig> myConfig = ValueNotifier<RoutingConfig>(const RoutingConfig(routes: []));

final GoRouter router = GoRouter.routingConfig(
  navigatorKey: AppRouter.rootNavigatorKey,
  routingConfig: myConfig,
  initialLocation: AppRouter.onboard,
  errorPageBuilder: (context, state) => MaterialPage(child: ErrorPage(state: state)),
  debugLogDiagnostics: true,
);

RoutingConfig _generateRoutingConfig({required bool authenticated, required bool onboarded}) {
  return RoutingConfig(
    redirectLimit: 5,
    redirect: (context, state) {
      log('Redirect ${state.uri} auth:$authenticated onboard:$onboarded}');

      if (!onboarded) return AppRouter.onboard;
      if (state.match(AppRouter.onboard)) return authenticated ? AppRouter.home : AppRouter.login;

      if (!authenticated && !state.isAuth) return AppRouter.login;
      if (!authenticated && state.isAuth) return null;
      if (authenticated && state.isAuth) return AppRouter.home;
      if (authenticated && !state.isAuth) return null;

      return null;
    },
    routes: <RouteBase>[
      if (authenticated) ...Home.routes,
      if (authenticated) ...Profile.routes,
      if (authenticated) ...Settings.routes,
      if (!authenticated) ...Auth.routes,
      if (!onboarded) ...Onboard.routes,
    ],
  );
}

@Riverpod(keepAlive: true)
Future routerRedirector(RouterRedirectorRef ref) async {
  final onboarded = ref.watch(onboardedProvider);
  final user = ref.watch(currentUserProvider).value;

  log(user?.uid ?? '-');

  myConfig.value = _generateRoutingConfig(
    authenticated: user != null, // && ((user.emailVerified == true) && verifyEmail),
    onboarded: onboarded,
  );

  return false;
}
