import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/widgets/shimmer_boxes.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/Routes/Auth/auth_routes.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User, PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Static/theme.dart';

void callUserUpdate(User user) {
  FirebaseFunctions.instance.httpsCallable('callUserUpdate').call(user.toMap());
}

@immutable
class AccountRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AccountPage();
  }
}

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    final user = ref.watch(currentUserDataProvider);

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
        avatar: user.when(
          data: (data) {
            return AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  splashFactory: InkSplash.splashFactory,
                  onTap: () async {
                    // final photo = await saveFirePickCropImage(
                    //   '${data?.uid}/profile',
                    //   crop: true,
                    // );
                    // photo?.task.then((url) async {
                    //   final u = await url.ref.getDownloadURL();
                    //   callUserUpdate(User(photoURL: u));
                    // });
                  },
                  child: data?.photoURL == null || data?.photoURL.isEmpty == true
                      ? Icon(
                          CupertinoIcons.person_crop_circle_badge_plus,
                          size: 120.c,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(250),
                          child: CustomCacheImage(
                            imageUrl: thumbImage(data!.photoURL),
                          ),
                        ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => const SizedBox.shrink(),
          loading: () => const AspectRatio(aspectRatio: 1, child: Center(child: CircularProgressIndicator())),
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

String thumbImage(String u) {
  final uri = Uri.parse(u);
  final base = '${uri.path.split('/').lastOrNull?.split('%2F').lastOrNull}';
  return u.replaceFirst(base, 'thumb_$base');
}
