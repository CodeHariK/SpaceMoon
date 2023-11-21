import 'dart:ui';

import 'package:moonspace/helper/extensions/color.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacemoon/Providers/global_theme.dart';

part 'pref.g.dart';

@Riverpod(keepAlive: true)
class Pref extends _$Pref {
  SharedPreferences? get _pref => state.value;

  @override
  Future<SharedPreferences> build() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref;
  }

  //Theme
  static const String _theme = 'theme';
  Future<void> saveTheme(ThemeType theme) async => await _pref?.setString(_theme, theme.toString());
  ThemeType getTheme() => ThemeType.from(_pref?.getString(_theme));

  //Color
  static const String _color = 'color';
  Future<void> saveColor(Color color) async => await _pref?.setString(_color, color.hexCode);
  Color? getColor() => _pref?.getString(_color)?.tryToColor();

  //Onboard
  static const String _onboard = 'onboard';
  Future<void> saveOnboard(bool onboard) async => await _pref?.setBool(_onboard, onboard);
  bool getOnboard() => _pref?.getBool(_onboard) ?? false;
}
