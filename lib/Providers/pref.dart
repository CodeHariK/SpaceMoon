import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacemoon/Providers/global_theme.dart';

part 'pref.g.dart';

@Riverpod(keepAlive: true)
class Pref extends _$Pref {
  SharedPreferences? get _pref => state.value;

  @override
  Future<SharedPreferences> build() async {
    log('Pref Init');
    SharedPreferences pref = await SharedPreferences.getInstance();
    log('Pref');

    return pref;
  }

  //Theme
  static const String _theme = 'theme';
  Future<void> saveTheme(ThemeType theme) async => await _pref?.setString(_theme, theme.toString());
  ThemeType getTheme() => ThemeType.from(_pref?.getString(_theme));

  //Onboard
  static const String _onboard = 'onboard';
  Future<void> saveOnboard(bool onboard) async => await _pref?.setBool(_onboard, onboard);
  bool getOnboard() => _pref?.getBool(_onboard) ?? false;
}
