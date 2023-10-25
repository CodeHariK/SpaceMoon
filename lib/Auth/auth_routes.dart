import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Auth/fire.dart';
import 'package:spacemoon/Constants/assets.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
part 'auth_routes.g.dart';

class Auth {
  static final routes = $appRoutes;
}

@TypedGoRoute<LoginRoute>(path: LoginRoute.path)
@immutable
class LoginRoute extends GoRouteData {
  static const String path = '/login';

  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        visualDensity: VisualDensity.standard,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
        textButtonTheme: TextButtonThemeData(style: buttonStyle),
        outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
      ),
      title: 'Spacemoon',
      debugShowCheckedModeBanner: false,
      locale: const Locale('en'),
      localizationsDelegates: [
        FirebaseUILocalizations.withDefaultOverrides(const LabelOverrides()),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FirebaseUILocalizations.delegate,
      ],
      home: SignInScreen(
        styles: const {
          EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
        },
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
            child: Text('Welcome to Firebase UI! $actionText.'),
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
      ),
    );
    // return const SnapAuth();
  }
}
