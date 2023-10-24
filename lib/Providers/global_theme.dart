import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_theme.g.dart';

@Riverpod(keepAlive: true)
class GlobalTheme extends _$GlobalTheme {
  @override
  Brightness build() {
    return SchedulerBinding.instance.platformDispatcher.platformBrightness;
  }

  void toggle() {
    state = state == Brightness.dark ? Brightness.light : Brightness.dark;
  }
}
