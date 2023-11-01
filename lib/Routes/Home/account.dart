import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Routes/Auth/auth_routes.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User, PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:spacemoon/Routes/Home/all_chat.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Static/theme.dart';

@immutable
class AccountRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AccountPage();
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ProfileScreen(
        avatar: Container(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            splashFactory: InkSplash.splashFactory,
            onTap: () async {
              callUserUpdate(
                User(
                  photoURL: 'https://avatars.githubusercontent.com/u/144345505?v=4',
                ),
              );
            },
            child: FirebaseAuth.instance.currentUser?.photoURL == null
                ? Icon(
                    CupertinoIcons.person_crop_circle_badge_plus,
                    size: 120.c,
                  )
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
