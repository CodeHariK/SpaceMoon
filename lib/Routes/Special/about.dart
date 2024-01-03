import 'dart:math' as math;
import 'dart:ui';

import 'package:appflowy_editor/appflowy_editor.dart' show safeLaunchUrl;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Helpers/gorouter_ext.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Static/assets.dart';
import 'package:spacemoon/Static/theme.dart';

import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:spacemoon/main.dart';

part 'about.g.dart';

class About {
  static final routes = $appRoutes;
}

@TypedGoRoute<AboutRoute>(path: AppRouter.about)
@immutable
class AboutRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadePage(context, state, const AboutPage());
  }
}

class ShimmmerCurve extends Curve {
  @override
  double transform(double t) {
    return clampDouble(t, 0, 1);
  }
}

class AboutPage extends ConsumerStatefulWidget {
  const AboutPage({super.key, this.onboarded});

  final Function? onboarded;

  @override
  ConsumerState<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends ConsumerState<AboutPage> with SingleTickerProviderStateMixin {
  final duration = const Duration(seconds: 1);
  late final AnimationController animCon;
  DateTime? pressStart;

  @override
  void initState() {
    animCon = AnimationController(vsync: this, duration: duration)
      ..addStatusListener(
        (status) {
          if (animCon.value == 1) {
            if (widget.onboarded != null) {
              widget.onboarded?.call();
            } else {
              safeLaunchUrl(SpaceMoon.spacemoonGithub);
            }
            context.pop();
            animCon.reset();
          }
        },
      );

    super.initState();
  }

  @override
  void dispose() {
    animCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'About Page',
      child: Scaffold(
        floatingActionButton: widget.onboarded == null
            ? null
            : FloatingActionButton(
                onPressed: () {
                  widget.onboarded?.call();
                },
                child: const Icon(
                  Icons.chevron_right_rounded,
                  semanticLabel: 'Continue',
                ),
              ),
        body: GestureDetector(
          onLongPressEnd: (details) {
            if (DateTime.now().millisecondsSinceEpoch - pressStart!.millisecondsSinceEpoch < duration.inMilliseconds) {
              animCon.reverse();
            }
          },
          onLongPressStart: (details) {
            pressStart = DateTime.now();
            animCon.forward();
          },
          onTap: () {
            animCon.animateTo(0.2).whenCompleteOrCancel(() {
              animCon.reverse();
            });
          },
          child: CustomPaint(
            painter: DottedBackgroundPainter(),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Semantics(
                        label: 'Spacemoon logo',
                        child: RainbowLogo(
                          assetPath: widget.onboarded != null ? Asset.spaceMoon : Asset.sharkrun,
                        ),
                      ),

                      //
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text: SpaceMoon.title,
                          style: context.hs,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              safeLaunchUrl(SpaceMoon.web);
                            },
                        ),
                      ),
                      SizedBox(height: (5, 10).c),
                      Text(' Built by', style: context.ts),
                      SizedBox(height: (5, 10).c),
                      Text.rich(
                        TextSpan(
                          text: SpaceMoon.harikrishnan,
                          style: context.tm,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              safeLaunchUrl(SpaceMoon.github);
                            },
                        ),
                      ),
                      SizedBox(height: (5, 10).c),
                      Text.rich(
                        TextSpan(
                          text: '@ shark.run',
                          style: context.tm,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              safeLaunchUrl(SpaceMoon.sharkrun);
                            },
                        ),
                      ),

                      SizedBox(height: (5, 10).c),
                      Text(
                        'Flutter Firebase App Developer',
                        style: context.ts,
                      ),

                      SizedBox(height: (5, 10).c),

                      const SocialButtons(),

                      if (widget.onboarded == null)
                        FutureBuilder(
                          future: FirebaseFirestore.instance.doc('Spacemoon/appinfo').get(),
                          builder: (context, snapshot) {
                            final googleplay = snapshot.data?.data()?['googleplay'] ?? SpaceMoon.googleplay;
                            final appstore = snapshot.data?.data()?['appstore'] ?? SpaceMoon.appstore;

                            return ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Semantics(
                                      label: 'Go to google play',
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            safeLaunchUrl(googleplay);
                                          },
                                          child: Image.asset(Asset.googleplay),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Semantics(
                                      label: 'Go to appstore',
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            safeLaunchUrl(appstore);
                                          },
                                          child: Image.asset(Asset.appstore),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                      SizedBox(height: (10, 20).c),

                      if (widget.onboarded == null)
                        CustomPaint(
                          painter: SolarPathPainter(Size((180, 220).c, (180, 220).c)),
                          child: Sunflower(
                            animCon: animCon,
                            onboard: widget.onboarded != null,
                          ),
                        ),

                      if (SpaceMoon.debugUi) Text(SpaceMoon.build, style: context.tl),
                      SizedBox(height: (10, 20).c),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            safeLaunchUrl(SpaceMoon.github);
          },
          icon: Semantics(
            label: 'Go to github',
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4),
              child: SvgPicture.string(
                githubSvg,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            safeLaunchUrl(SpaceMoon.linkedIn);
          },
          icon: Semantics(
            label: 'Go to LinkedIn',
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.string(
                linkedInSvg,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            safeLaunchUrl(SpaceMoon.twitter);
          },
          icon: Semantics(
            label: 'Go to Twitter',
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.string(
                twitterSvg,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RainbowLogo extends StatelessWidget {
  const RainbowLogo({
    super.key,
    required this.assetPath,
  });

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        SlideEffect(
          begin: Offset(0, .07),
          end: Offset(0, 0),
          duration: Duration(milliseconds: 2000),
          curve: Curves.easeInOut,
        ),
      ],
      onComplete: (controller) {
        controller.repeat(reverse: true);
      },
      child: Animate(
        effects: [
          ShimmerEffect(
            // blendMode: BlendMode.dstATop,
            angle: math.pi / 4,
            size: 2,
            // colors: const [
            //   Color.fromARGB(80, 238, 255, 141),
            //   Color.fromARGB(160, 196, 141, 255),
            //   Color.fromARGB(160, 109, 201, 240),
            //   Color.fromARGB(160, 222, 231, 60),
            //   Color.fromARGB(160, 231, 60, 154),
            //   Color.fromARGB(160, 165, 213, 154),
            //   Color.fromARGB(160, 255, 169, 135),
            //   Color.fromARGB(80, 255, 135, 181),
            // ],
            colors: Colors.primaries.map((e) => e.withAlpha(150)).toList(),
            curve: ShimmmerCurve(),
            duration: const Duration(milliseconds: 5000),
          ),
        ],
        onComplete: (controller) {
          controller.repeat(reverse: true);
        },
        child: SizedBox(height: (270, 400).c, child: Image.asset(assetPath)),
      ),
    );
  }
}

const String githubSvg =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="3 3 24 24"> <path d="M15,3C8.373,3,3,8.373,3,15c0,5.623,3.872,10.328,9.092,11.63C12.036,26.468,12,26.28,12,26.047v-2.051 c-0.487,0-1.303,0-1.508,0c-0.821,0-1.551-0.353-1.905-1.009c-0.393-0.729-0.461-1.844-1.435-2.526 c-0.289-0.227-0.069-0.486,0.264-0.451c0.615,0.174,1.125,0.596,1.605,1.222c0.478,0.627,0.703,0.769,1.596,0.769 c0.433,0,1.081-0.025,1.691-0.121c0.328-0.833,0.895-1.6,1.588-1.962c-3.996-0.411-5.903-2.399-5.903-5.098 c0-1.162,0.495-2.286,1.336-3.233C9.053,10.647,8.706,8.73,9.435,8c1.798,0,2.885,1.166,3.146,1.481C13.477,9.174,14.461,9,15.495,9 c1.036,0,2.024,0.174,2.922,0.483C18.675,9.17,19.763,8,21.565,8c0.732,0.731,0.381,2.656,0.102,3.594 c0.836,0.945,1.328,2.066,1.328,3.226c0,2.697-1.904,4.684-5.894,5.097C18.199,20.49,19,22.1,19,23.313v2.734 c0,0.104-0.023,0.179-0.035,0.268C23.641,24.676,27,20.236,27,15C27,8.373,21.627,3,15,3z"/></svg>';

const String linkedInSvg =
    '<svg xmlns="http://www.w3.org/2000/svg"  viewBox="5 5 38 38"><path fill="#0288D1" d="M42,37c0,2.762-2.238,5-5,5H11c-2.761,0-5-2.238-5-5V11c0-2.762,2.239-5,5-5h26c2.762,0,5,2.238,5,5V37z"/><path fill="#FFF" d="M12 19H17V36H12zM14.485 17h-.028C12.965 17 12 15.888 12 14.499 12 13.08 12.995 12 14.514 12c1.521 0 2.458 1.08 2.486 2.499C17 15.887 16.035 17 14.485 17zM36 36h-5v-9.099c0-2.198-1.225-3.698-3.192-3.698-1.501 0-2.313 1.012-2.707 1.99C24.957 25.543 25 26.511 25 27v9h-5V19h5v2.616C25.721 20.5 26.85 19 29.738 19c3.578 0 6.261 2.25 6.261 7.274L36 36 36 36z"/></svg>';

const String twitterSvg =
    '<svg xmlns="http://www.w3.org/2000/svg"  viewBox="5 2 38 38"><path fill="#03A9F4" d="M42,12.429c-1.323,0.586-2.746,0.977-4.247,1.162c1.526-0.906,2.7-2.351,3.251-4.058c-1.428,0.837-3.01,1.452-4.693,1.776C34.967,9.884,33.05,9,30.926,9c-4.08,0-7.387,3.278-7.387,7.32c0,0.572,0.067,1.129,0.193,1.67c-6.138-0.308-11.582-3.226-15.224-7.654c-0.64,1.082-1,2.349-1,3.686c0,2.541,1.301,4.778,3.285,6.096c-1.211-0.037-2.351-0.374-3.349-0.914c0,0.022,0,0.055,0,0.086c0,3.551,2.547,6.508,5.923,7.181c-0.617,0.169-1.269,0.263-1.941,0.263c-0.477,0-0.942-0.054-1.392-0.135c0.94,2.902,3.667,5.023,6.898,5.086c-2.528,1.96-5.712,3.134-9.174,3.134c-0.598,0-1.183-0.034-1.761-0.104C9.268,36.786,13.152,38,17.321,38c13.585,0,21.017-11.156,21.017-20.834c0-0.317-0.01-0.633-0.025-0.945C39.763,15.197,41.013,13.905,42,12.429"/></svg>';

class DottedBackgroundPainter extends CustomPainter {
  static const double gap = 18.0; // Gap between dots
  static const double radius = 1; // Radius of each dot

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppTheme.darkness ? Colors.white38 : AppTheme.seedColor.withAlpha(80)
      ..strokeWidth = 1.0;

    for (double j = 0; j < size.height; j += gap) {
      final off = (j % (2 * gap) == gap ? gap / 2 : 0);
      for (double i = 0; i < size.width; i += gap) {
        canvas.drawCircle(Offset(i + off, j), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

Color primaryColor = AppTheme.op;
const TargetPlatform platform = TargetPlatform.android;

class SunflowerPainter extends CustomPainter {
  static const tau = math.pi * 2;
  static final invGolden = 1 / ((math.sqrt(5) + 1) / 2);

  final int seeds;
  final double turns;
  final double scaleFactor;
  final double seedRadius;

  SunflowerPainter({
    required this.seeds,
    required this.turns,
    this.scaleFactor = 4,
    this.seedRadius = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerx = size.width / 2;
    final centery = size.height / 2;

    for (var i = 0; i < seeds; i++) {
      final theta = i * tau * turns;
      final r = math.sqrt(i) * scaleFactor;
      final x = centerx + r * math.cos(theta);
      final y = centery - r * math.sin(theta);
      final offset = Offset(x, y);
      if (!size.contains(offset)) {
        continue;
      }
      drawSeed(canvas, x, y);
    }
  }

  @override
  bool shouldRepaint(SunflowerPainter oldDelegate) {
    return oldDelegate.seeds != seeds;
  }

  void drawSeed(Canvas canvas, double x, double y) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.fill
      ..color = primaryColor;
    canvas.drawCircle(Offset(x, y), seedRadius, paint);
  }
}

class Sunflower extends StatefulWidget {
  const Sunflower({
    super.key,
    required this.onboard,
    required this.animCon,
  });

  final bool onboard;
  final AnimationController animCon;

  @override
  State<StatefulWidget> createState() {
    return _SunflowerState();
  }
}

class _SunflowerState extends State<Sunflower> {
  double seeds = 400.0, turns = 0.6281;

  int get seedCount => seeds.floor();

  AnimationController get animCon => widget.animCon;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animCon,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.seedColor.withAlpha(20),
            shape: BoxShape.circle,
          ),
          width: (180, 220).c,
          height: (180, 220).c,
          child: CustomPaint(
            painter: SunflowerPainter(
              seeds: (seedCount * animCon.value).toInt(),
              turns: turns,
              scaleFactor: 2.8 + 1.4 * animCon.value,
            ),
            child: () {
              switch (animCon.value) {
                case 0:
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(widget.onboard ? Asset.sharkrun : Asset.spaceMoon),
                  );
                case 1:
                  return IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.darkness ? Colors.white : Colors.black,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.close,
                        size: 40,
                        color: AppTheme.darkness ? Colors.black : Colors.white,
                      ),
                    ),
                  );
                default:
                  return null;
              }
            }(),
          ),
        );
      },
    );
  }
}

class SolarPathPainter extends CustomPainter {
  List<Offset> points = [];

  Offset movingPoint = const Offset(0, 0);
  double distance = 0;

  late Path path;

  final Size size;

  SolarPathPainter(this.size) {
    createPath();
  }

  void createPath() {
    path = Path()
      ..addArc(
        Rect.fromPoints(
          const Offset(0, 0),
          Offset(size.width, size.height),
        ),
        0,
        2 * math.pi,
      );

    for (double t = 0.0; t <= 1.0; t += 0.1) {
      Tangent? pos = path.computeMetrics().single.getTangentForOffset(t * path.computeMetrics().single.length);
      if (pos?.position != null) {
        points.add(pos!.position);
      }
      movingPoint = points.first;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawPath(canvas);
    drawPoints(canvas);
    drawMovingPoint(canvas);
    updateMovingPoint();
  }

  void drawPath(Canvas canvas) {
    Paint pathPaint = Paint()
      ..color = AppTheme.seedColor.withAlpha(100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, pathPaint);
  }

  void drawPoints(Canvas canvas) {
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      canvas.drawCircle(point, 3.0, Paint()..color = Colors.primaries[i]);
    }
  }

  void drawMovingPoint(Canvas canvas) {
    Paint movingPointPaint = Paint()..color = Colors.blue;

    canvas.drawCircle(movingPoint, 5.0, movingPointPaint);
  }

  void updateMovingPoint() {
    distance += 0.002;
    distance = distance > .999 ? 0.002 : distance;

    Tangent? pos = path.computeMetrics().single.getTangentForOffset(distance * path.computeMetrics().single.length);
    if (pos?.position != null) {
      movingPoint = pos!.position;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
