import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moonspace/router/router.dart';
import 'package:spacemoon/Providers/auth.dart';
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/Routes/Auth/auth_routes.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Routes/Special/about.dart';
import 'package:moonspace/pages/error_page.dart';
import 'package:spacemoon/Routes/Special/onboard.dart';

part 'router.g.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeShellNavigatorKey =
      GlobalKey<NavigatorState>();

  //
  static const String routerRestorationScopeId =
      'SpacemoonRouterRestorationScopeId';

  /*-------------------Auth-------------------*/
  static const String login = '/auth/login';
  static const String phone = '/auth/phone';
  static const String sms = '/auth/sms';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String emailLinkSignIn = '/auth/email-link-sign-in';

  /*-------------------Root-------------------*/
  static const String root = '/';
  /*-*/
  static const String account = 'account';
  /*-*/
  static const String settings = 'settings';
  /*-----------------HomeShell-----------------*/
  /*---*/
  static const String allchat = 'chat';
  /*------*/
  static const String chat = ':chatId';
  /*---------*/
  static const String chatInfo = 'info';
  /*---------*/
  // static const String tweet = 'tweet/:tweetId';
  /*---*/
  static const String search = 'search';
  /*---*/
  static const String profile = 'profile';

  /*-----------------Notification-----------------*/
  /*-*/
  static const String notification = 'notification';
  /*-*/
  static const String subscription = 'subscription';

  /*-----------------Special-----------------*/
  static const String onboard = '/onboard';
  static const String about = '/about';
}

//
final ValueNotifier<RoutingConfig> spacemoonRouterConfigNotifier =
    ValueNotifier<RoutingConfig>(
      _generateRoutingConfig(authenticated: false, onboarded: false),
    );

GoRouter spacemoonRouter() => GoRouter.routingConfig(
  navigatorKey: AppRouter.rootNavigatorKey,
  // refreshListenable: GoRouterRefresh(),
  routingConfig: spacemoonRouterConfigNotifier,
  initialLocation: AppRouter.onboard,
  errorPageBuilder: (context, state) =>
      const MaterialPage(child: Error404Page()),
  debugLogDiagnostics: true,
  restorationScopeId: AppRouter.routerRestorationScopeId,
);

RoutingConfig _generateRoutingConfig({
  required bool authenticated,
  required bool onboarded,
}) {
  return RoutingConfig(
    redirectLimit: 100,
    redirect: (context, state) async {
      debugPrint(
        '-> -> -> ${state.uri} auth:$authenticated onboard:$onboarded}',
      );

      if (!onboarded) return AppRouter.onboard;
      if (state.match(AppRouter.onboard)) {
        return authenticated ? AppRouter.root : AppRouter.login;
      }

      if (!authenticated && !state.isAuth) return AppRouter.login;
      if (!authenticated && state.isAuth) return null;
      if (authenticated && state.isAuth) return AppRouter.root;
      if (authenticated && !state.isAuth) return null;

      return null;
    },
    routes: <RouteBase>[
      if (authenticated) ...Home.routes,
      if (!authenticated) ...Auth.routes,
      if (!onboarded) ...Onboard.routes,
      ...About.routes,
    ],
  );
}

// class GoRouterRefresh extends Listenable {
//   static VoidCallback? _listener;
//   @override
//   void addListener(VoidCallback listener) {
//     _listener = listener;
//   }

//   @override
//   void removeListener(VoidCallback listener) {
//     _listener = null;
//   }

//   static void notify() {
//     _listener?.call();
//   }
// }

@Riverpod(keepAlive: true)
Future routerRedirector(Ref ref) async {
  final onboarded = ref.watch(onboardedProvider);
  final user = ref.watch(currentUserProvider).value;
  final userData = ref.watch(currentUserDataProvider).value;

  debugPrint('routerRedirector : ${user?.uid} ${userData?.uid} $onboarded');

  spacemoonRouterConfigNotifier.value = _generateRoutingConfig(
    authenticated:
        user != null &&
        userData != null, // && ((user.emailVerified == true) && verifyEmail),
    onboarded: onboarded,
  );

  // GoRouterRefresh.notify();
}
