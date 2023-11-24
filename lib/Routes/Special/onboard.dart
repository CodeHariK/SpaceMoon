import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Providers/pref.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Routes/Special/about.dart';
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

  final pageCon = PageController();

  @override
  void initState() {
    pageCon.addListener(() {
      if ((pageCon.page ?? 0) >= 2.2) {
        ref.read(onboardedProvider.notifier).set(true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    pageCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: PageView(
                physics: const ClampingScrollPhysics(),
                controller: pageCon,
                children: [
                  OnboardPage(
                    purple: purple,
                    text: 'Dream big',
                    image: Asset.dream,
                  ),
                  OnboardPage(
                    purple: purple,
                    text: 'Organize tasks',
                    image: Asset.team,
                  ),
                  OnboardPage(
                    purple: purple,
                    text: 'Share your world',
                    image: Asset.story,
                  ),
                  const Scaffold(backgroundColor: Colors.white),
                ],
              ),
            ),
            IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: Colors.transparent),
              onPressed: () {
                pageCon.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: AnimatedBuilder(
                animation: pageCon,
                builder: (context, child) {
                  final value = (pageCon.page ?? 0) / 3 + 0.2;
                  return SizedBox(
                    width: 170,
                    height: 170,
                    child: CustomPaint(
                      painter: SunflowerPainter(
                        seeds: (400 * value).toInt(),
                        turns: 0.6281,
                        scaleFactor: 3 + 1.6 * value,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class OnboardPage extends StatelessWidget {
  const OnboardPage({
    super.key,
    required this.purple,
    required this.text,
    required this.image,
  });

  final Color purple;
  final String text;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        SlideEffect(
          duration: Duration(milliseconds: 600),
          begin: Offset(0, 0.03),
          end: Offset(0, 0),
        ),
        FadeEffect(),
        ShimmerEffect(),
        SaturateEffect(),
        FlipEffect(begin: .05, end: 0),
      ],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              text,
              style: context.hl.c(purple).bold.height(1.4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
