import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Auth/auth_routes.dart';
import 'package:spacemoon/Constants/theme.dart';
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
    return const ProfilePage();
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    return ProfileScreen(
      appBar: AppBar(),
      avatar: Container(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          splashFactory: InkSplash.splashFactory,
          onTap: () async {
            log('hello');
            await FirebaseAuth.instance.currentUser
                ?.updatePhotoURL('https://avatars.githubusercontent.com/u/144345505?v=4');
          },
          child: FirebaseAuth.instance.currentUser?.photoURL == null
              ? const Icon(CupertinoIcons.person_crop_circle_badge_plus)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(250),
                  child: Image.network(
                    FirebaseAuth.instance.currentUser!.photoURL!,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
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
    );
  }
}
