import 'package:firebase_auth/firebase_auth.dart' hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Static/assets.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Routes/Home/account.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/main.dart';

part 'auth_routes.g.dart';

class Auth {
  static final routes = $appRoutes;
}

@TypedGoRoute<LoginRoute>(path: AppRouter.login)
@immutable
class LoginRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SignInScreen(
      styles: const {EmailFormStyle(signInButtonVariant: ButtonVariant.filled)},
      headerBuilder: headerImage(Asset.spaceMoon),
      sideBuilder: sideImage(Asset.spaceMoon),
      subtitleBuilder: (context, action) {
        final actionText = switch (action) {
          AuthAction.signIn => 'Please sign in to continue.',
          AuthAction.signUp => 'Please create an account to continue',
          _ => throw Exception('Invalid action: $action'),
        };

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('Welcome to ${SpaceMoon.title}! $actionText.'),
        );
      },
      footerBuilder: (context, action) {
        final actionText = switch (action) {
          AuthAction.signIn => 'signing in',
          AuthAction.signUp => 'registering',
          _ => throw Exception('Invalid action: $action'),
        };

        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'By $actionText, you agree to our terms and conditions.',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        );
      },
      actions: [
        VerifyPhoneAction((context, _) {
          PhoneRoute().push(context);
        }),
        ForgotPasswordAction((context, email) {
          ForgotPasswordRoute(email: email).push(context);
        }),
        EmailLinkSignInAction((context) {
          EmailLinkRoute().push(context);
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
        // AuthStateChangeAction((context, AuthState state) {
        //   final user = switch (state) {
        //     SignedIn(user: final user) => user,
        //     CredentialLinked(user: final user) => user,
        //     UserCreated(credential: final cred) => cred.user,
        //     _ => null,
        //   };

        //   switch (user) {
        //     case User(emailVerified: true):
        //       AccountRoute().pushReplacement(context);
        //     // case User(emailVerified: false, email: final String _):
        //     //   VerifyEmailRoute().push(context);
        //   }
        // }),
      ],
    );
  }
}

@TypedGoRoute<PhoneRoute>(path: AppRouter.phone)
@immutable
class PhoneRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PhoneInputScreen(
      actions: [
        SMSCodeRequestedAction((context, AuthAction? action, Object flowKey, String phone) {
          SmsRoute(
            $extra: SmsObject(
              action: action,
              flowKey: flowKey,
              phone: phone,
            ),
          ).pushReplacement(context);
        }),
      ],
      headerBuilder: headerIcon(Icons.phone),
      sideBuilder: sideIcon(Icons.phone),
    );
  }
}

class SmsObject {
  final AuthAction? action;
  final Object flowKey;
  final String phone;

  SmsObject({
    required this.action,
    required this.flowKey,
    required this.phone,
  });
}

@TypedGoRoute<SmsRoute>(path: AppRouter.sms)
@immutable
class SmsRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  final SmsObject $extra;

  const SmsRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SMSCodeInputScreen(
      // actions: [
      //   AuthStateChangeAction<SignedIn>((context, state) {
      //     context.go('/');
      //   }),
      // ],
      flowKey: $extra.flowKey,
      action: $extra.action,
      headerBuilder: headerIcon(Icons.sms_outlined),
      sideBuilder: sideIcon(Icons.sms_outlined),
    );
  }
}

@TypedGoRoute<ForgotPasswordRoute>(path: AppRouter.forgotPassword)
@immutable
class ForgotPasswordRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  final String? email;

  const ForgotPasswordRoute({required this.email});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ForgotPasswordScreen(
      email: email,
      headerMaxExtent: 200,
      headerBuilder: headerIcon(Icons.lock),
      sideBuilder: sideIcon(Icons.lock),
    );
  }
}

// @TypedGoRoute<VerifyEmailRoute>(path: AppRouter.verifyEmail)
// @immutable
// class VerifyEmailRoute extends GoRouteData {
//   static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

//   @override
//   Widget build(BuildContext context, GoRouterState state) {
//     return EmailVerificationScreen(
//       headerBuilder: headerIcon(Icons.verified),
//       sideBuilder: sideIcon(Icons.verified),
//       actionCodeSettings: ActionCodeSettings(
//         url: 'https://spacemoonfire.firebaseapp.com',
//         handleCodeInApp: true,
//         androidMinimumVersion: '27',
//         androidPackageName: 'run.shark.spacemoon',
//         iOSBundleId: 'run.shark.spacemoon',
//       ),
//       actions: [
//         EmailVerifiedAction(() {
//           AccountRoute().pushReplacement(context);
//         }),
//         AuthCancelledAction((context) {
//           FirebaseUIAuth.signOut(context: context);
//           HomeRoute().pushReplacement(context);
//         }),
//       ],
//     );
//   }
// }

@TypedGoRoute<EmailLinkRoute>(path: AppRouter.emailLinkSignIn)
@immutable
class EmailLinkRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EmailLinkSignInScreen(
      // actions: [
      //   AuthStateChangeAction<SignedIn>((context, state) {
      //     HomeRoute().pushReplacement(context);
      //   }),
      // ],
      headerMaxExtent: 200,
      headerBuilder: headerIcon(Icons.link),
      sideBuilder: sideIcon(Icons.link),
    );
  }
}

HeaderBuilder headerImage(String assetName) {
  return (context, constraints, _) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Image.asset(assetName),
    );
  };
}

HeaderBuilder headerIcon(IconData icon) {
  return (context, constraints, shrinkOffset) {
    return Padding(
      padding: const EdgeInsets.all(20).copyWith(top: 40),
      child: Icon(
        icon,
        color: Colors.blue,
        size: constraints.maxWidth / 4 * (1 - shrinkOffset),
      ),
    );
  };
}

SideBuilder sideImage(String assetName) {
  return (context, constraints) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(constraints.maxWidth / 4),
        child: Image.asset(assetName),
      ),
    );
  };
}

SideBuilder sideIcon(IconData icon) {
  return (context, constraints) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Icon(
        icon,
        color: Colors.blue,
        size: constraints.maxWidth / 3,
      ),
    );
  };
}
