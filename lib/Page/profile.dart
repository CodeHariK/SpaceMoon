import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Auth/auth_routes.dart';
import 'package:spacemoon/Providers/router.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart' hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

part 'profile.g.dart';

class Profile {
  static final routes = $appRoutes;
}

@TypedGoRoute<ProfileRoute>(path: AppRouter.profile)
@immutable
class ProfileRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final platform = Theme.of(context).platform;

    return ProfileScreen(
      appBar: AppBar(),
      actions: [
        SignedOutAction((context) {
          LoginRoute().pushReplacement(context);
          context.pushReplacement(AppRouter.login);
        }),
        AuthStateChangeAction<MFARequired>(
          (context, state) async {
            await startMFAVerification(
              resolver: state.resolver,
              context: context,
            );

            if (context.mounted) ProfileRoute().pushReplacement(context);
          },
        ),
      ],
      actionCodeSettings: ActionCodeSettings(
        url: 'https://spacemoon.shark.run',
        handleCodeInApp: true,
        androidMinimumVersion: '27',
        androidPackageName: 'run.shark.spacemoon',
        iOSBundleId: 'run.shark.spacemoon',
      ),
      showMFATile: kIsWeb || platform == TargetPlatform.iOS || platform == TargetPlatform.android,
      showUnlinkConfirmationDialog: true,
    );
  }
}
