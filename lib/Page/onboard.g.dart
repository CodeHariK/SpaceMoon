// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboard.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $onboardRoute,
    ];

RouteBase get $onboardRoute => GoRouteData.$route(
      path: '/onboard',
      parentNavigatorKey: OnboardRoute.$parentNavigatorKey,
      factory: $OnboardRouteExtension._fromState,
    );

extension $OnboardRouteExtension on OnboardRoute {
  static OnboardRoute _fromState(GoRouterState state) => OnboardRoute();

  String get location => GoRouteData.$location(
        '/onboard',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$onboardedHash() => r'dbb444886946d3b874e4869f496eb4f5dc03b9d8';

/// See also [Onboarded].
@ProviderFor(Onboarded)
final onboardedProvider = NotifierProvider<Onboarded, bool>.internal(
  Onboarded.new,
  name: r'onboardedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$onboardedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Onboarded = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
