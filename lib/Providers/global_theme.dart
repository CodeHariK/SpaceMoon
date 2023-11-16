// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/scheduler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Providers/pref.dart';

part 'global_theme.g.dart';

enum ThemeType {
  system(Icon(CupertinoIcons.cloud_sun_rain)),
  dark(Icon(CupertinoIcons.moon_stars)),
  light(Icon(CupertinoIcons.sun_min));

  final Icon icon;

  const ThemeType(this.icon);

  static ThemeType from(String? v) {
    v = v ?? ThemeType.system.toString();

    return ThemeType.values.where((e) => e.toString() == v).first;
  }

  Brightness get brightness {
    if (this == ThemeType.dark) {
      return Brightness.dark;
    }
    if (this == ThemeType.light) {
      return Brightness.light;
    }
    return SchedulerBinding.instance.platformDispatcher.platformBrightness;
  }
}

class GlobalAppTheme {
  final ThemeType theme;
  final Color color;

  GlobalAppTheme({
    required this.theme,
    required this.color,
  });

  GlobalAppTheme copyWith({
    ThemeType? theme,
    Color? color,
  }) {
    return GlobalAppTheme(
      theme: theme ?? this.theme,
      color: color ?? this.color,
    );
  }
}

@Riverpod(keepAlive: true)
class GlobalTheme extends _$GlobalTheme {
  @override
  GlobalAppTheme build() {
    ref.watch(prefProvider);
    ThemeType theme = ref.read(prefProvider.notifier).getTheme();
    Color? color = ref.read(prefProvider.notifier).getColor();
    return GlobalAppTheme(
      theme: theme,
      color: color ?? Colors.indigo,
    );
  }

  void setThemeType(ThemeType theme) {
    state = state.copyWith(theme: theme);
    ref.read(prefProvider.notifier).saveTheme(state.theme);
  }

  void setColor(Color color) {
    state = state.copyWith(color: color);
    ref.read(prefProvider.notifier).saveColor(state.color);
  }
}
