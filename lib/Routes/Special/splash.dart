import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:spacemoon/Static/assets.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.light
          ? ThemeData.light()
          : ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: Animate(
            effects: const [
              FadeEffect(),
              ScaleEffect(),
            ],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(Asset.spaceMoon),
                Text('Built by shark.run', style: context.tm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
