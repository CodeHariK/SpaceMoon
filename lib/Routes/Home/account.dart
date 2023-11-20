import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Routes/Auth/auth_routes.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User, PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:spacemoon/Routes/Home/home.dart';

@immutable
class AccountRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AccountPage();
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(
            onPressed: () {
              HomeRoute().go(context);
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: ProfileScreen(
        avatar: const SizedBox(),
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

              if (context.mounted) AccountRoute().pushReplacement(context);
            },
          ),
        ],
        actionCodeSettings: ActionCodeSettings(
          url: 'https://spacemoonfire.firebaseapp.com',
          handleCodeInApp: true,
          androidMinimumVersion: '27',
          androidPackageName: 'run.shark.spacemoon',
          iOSBundleId: 'run.shark.spacemoon',
        ),
        showMFATile: kIsWeb || platform == TargetPlatform.iOS || platform == TargetPlatform.android,
        showUnlinkConfirmationDialog: true,

        //
        children: [
          Text('Email  ${FirebaseAuth.instance.currentUser?.email}'),
          Text('Phone  ${FirebaseAuth.instance.currentUser?.phoneNumber}'),
        ],
      ),
    );
  }
}
