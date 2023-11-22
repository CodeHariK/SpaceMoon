import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
          child: Column(
            children: [
              Image.asset(Asset.spaceMoon),
              const Spacer(),
              Text('Built by shark.run', style: context.tm),
            ],
          ),
        ),
      ),
    );
  }
}
