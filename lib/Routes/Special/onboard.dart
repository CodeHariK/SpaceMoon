import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Providers/pref.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Static/assets.dart';

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
  final purple = const Color.fromARGB(255, 107, 46, 107);
  final yellow = const Color.fromARGB(255, 224, 224, 184);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purple,
      body: SafeArea(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(Asset.spaceMoon),
            ),
            TextButton(
              child: const Text('Continue'),
              onPressed: () {
                ref.read(onboardedProvider.notifier).set(true);
              },
            ),
            const Spacer(),
            IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: yellow),
              iconSize: 32,
              onPressed: () {},
              icon: const Icon(Icons.arrow_right_alt),
            ),
          ],
        ),
      ),
    );
  }
}
