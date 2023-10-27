import 'package:flutter/cupertino.dart';
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

@Riverpod(keepAlive: true)
class GlobalTheme extends _$GlobalTheme {
  @override
  ThemeType build() {
    ref.watch(prefProvider);
    ThemeType theme = ref.read(prefProvider.notifier).getTheme();
    return theme;
  }

  void set(ThemeType theme) {
    state = theme;
    ref.read(prefProvider.notifier).saveTheme(state);
  }
}
