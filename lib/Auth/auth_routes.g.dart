// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $loginRoute,
      $phoneRoute,
      $smsRoute,
      $forgotPasswordRoute,
      $verifyEmailRoute,
      $emailLinkRoute,
    ];

RouteBase get $loginRoute => GoRouteData.$route(
      path: '/auth/login',
      parentNavigatorKey: LoginRoute.$parentNavigatorKey,
      factory: $LoginRouteExtension._fromState,
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute();

  String get location => GoRouteData.$location(
        '/auth/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $phoneRoute => GoRouteData.$route(
      path: '/auth/phone',
      parentNavigatorKey: PhoneRoute.$parentNavigatorKey,
      factory: $PhoneRouteExtension._fromState,
    );

extension $PhoneRouteExtension on PhoneRoute {
  static PhoneRoute _fromState(GoRouterState state) => PhoneRoute();

  String get location => GoRouteData.$location(
        '/auth/phone',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $smsRoute => GoRouteData.$route(
      path: '/auth/sms',
      parentNavigatorKey: SmsRoute.$parentNavigatorKey,
      factory: $SmsRouteExtension._fromState,
    );

extension $SmsRouteExtension on SmsRoute {
  static SmsRoute _fromState(GoRouterState state) => SmsRoute(
        $extra: state.extra as SmsObject,
      );

  String get location => GoRouteData.$location(
        '/auth/sms',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $forgotPasswordRoute => GoRouteData.$route(
      path: '/auth/forgot-password',
      parentNavigatorKey: ForgotPasswordRoute.$parentNavigatorKey,
      factory: $ForgotPasswordRouteExtension._fromState,
    );

extension $ForgotPasswordRouteExtension on ForgotPasswordRoute {
  static ForgotPasswordRoute _fromState(GoRouterState state) =>
      ForgotPasswordRoute(
        email: state.uri.queryParameters['email'],
      );

  String get location => GoRouteData.$location(
        '/auth/forgot-password',
        queryParams: {
          if (email != null) 'email': email,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $verifyEmailRoute => GoRouteData.$route(
      path: '/auth/verify-email',
      parentNavigatorKey: VerifyEmailRoute.$parentNavigatorKey,
      factory: $VerifyEmailRouteExtension._fromState,
    );

extension $VerifyEmailRouteExtension on VerifyEmailRoute {
  static VerifyEmailRoute _fromState(GoRouterState state) => VerifyEmailRoute();

  String get location => GoRouteData.$location(
        '/auth/verify-email',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $emailLinkRoute => GoRouteData.$route(
      path: '/auth/email-link-sign-in',
      parentNavigatorKey: EmailLinkRoute.$parentNavigatorKey,
      factory: $EmailLinkRouteExtension._fromState,
    );

extension $EmailLinkRouteExtension on EmailLinkRoute {
  static EmailLinkRoute _fromState(GoRouterState state) => EmailLinkRoute();

  String get location => GoRouteData.$location(
        '/auth/email-link-sign-in',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
