import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Providers/pref.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Routes/Special/about.dart';

part 'onboard.g.dart';

class Onboard {
  static final routes = $appRoutes;
}

@TypedGoRoute<OnboardRoute>(path: AppRouter.onboard)
@immutable
class OnboardRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OnboardingPage();
  }
}

@Riverpod(keepAlive: true)
class Onboarded extends _$Onboarded {
  @override
  bool build() {
    ref.watch(prefProvider);
    return ref.read(prefProvider.notifier).getOnboard();
  }

  void set(bool onboarded) {
    state = onboarded;
    ref.read(prefProvider.notifier).saveOnboard(state);
  }
}

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return AboutPage(
      onboard: () {
        ref.read(onboardedProvider.notifier).set(true);
      },
    );
  }
}
