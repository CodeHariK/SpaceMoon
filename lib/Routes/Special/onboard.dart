import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Providers/pref.dart';
import 'package:spacemoon/Providers/router.dart';

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

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarded = ref.watch(onboardedProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Text(onboarded.toString()),
            TextButton(
              onPressed: () {
                ref.read(onboardedProvider.notifier).set(true);
              },
              child: const Text('Splash'),
            ),
          ],
        ),
      ),
    );
  }
}
