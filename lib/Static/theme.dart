import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonspace/Helper/extensions.dart';

extension AppThemeNumber on num {
  double get a => (this * AppTheme.a).toDouble();
  double get s => (this * AppTheme.s).toDouble();
  double get m => (this * AppTheme.m).toDouble();
  double get c => (this * AppTheme.c).toDouble();
  double get mins => max(this, s).toDouble();
  double get maxs => min(this, s).toDouble();
  double get minc => max(this, c).toDouble();
  double get maxc => min(this, c).toDouble();
}

extension AppThemeRange on (num, num) {
  double get s => ($1 + ($2 - $1) * AppTheme.rs).toDouble();
  double get c => ($1 + ($2 - $1) * AppTheme.rc).toDouble();
}

class AppTheme {
  final Size size;
  final Size maxSize;
  final Size designSize;

  final bool dark;

  static AppTheme currentAppTheme = AppTheme(
    size: const Size(360, 780),
    maxSize: const Size(1366, 1024),
    designSize: const Size(360, 780),
    dark: false,
  );
  static double get w => currentAppTheme.size.width;
  static double get dw => currentAppTheme.designSize.width;
  static double get mw => currentAppTheme.maxSize.width;
  static double get h => currentAppTheme.size.height;
  static double get dh => currentAppTheme.designSize.height;
  static double get mh => currentAppTheme.maxSize.height;

  static num get a => (AppTheme.w / AppTheme.dw) * (AppTheme.h / AppTheme.dh);
  static num get m => min((AppTheme.w / AppTheme.dw), (AppTheme.h / AppTheme.dh));
  static num get s => pow((AppTheme.w / AppTheme.dw) * (AppTheme.h / AppTheme.dh), 1 / 2);
  static num get c => pow((AppTheme.w / AppTheme.dw) * (AppTheme.h / AppTheme.dh), 0.2);
  static num get maxs => pow((AppTheme.mw / AppTheme.dw) * (AppTheme.mh / AppTheme.dh), 1 / 2);
  static num get maxc => pow((AppTheme.mw / AppTheme.dw) * (AppTheme.mh / AppTheme.dh), 0.2);
  static num get rs => min(1, max(0, AppTheme.s - 1) / (AppTheme.maxs - 1));
  static num get rc => min(1, max(0, AppTheme.c - 1) / (AppTheme.maxc - 1));

  static TextTheme get tx => currentAppTheme.textTheme;

  AppTheme({
    required this.size,
    required this.maxSize,
    required this.designSize,
    required this.dark,
  });

  // static TextStyle get poppins => GoogleFonts.poppins();
  static TextStyle get poppins => const TextStyle();

  static Color get seedColor => Colors.purple;
  // bodyMedium: GoogleFonts.merriweather(),
  // displaySmall: GoogleFonts.pacifico(),
  TextTheme get textTheme => TextTheme(
        displayLarge: poppins.copyWith(color: Colors.orange),
        displayMedium: poppins.copyWith(color: const Color.fromARGB(255, 226, 32, 32)),
        displaySmall: poppins.copyWith(color: Colors.teal),
        headlineLarge: GoogleFonts.merriweather(letterSpacing: 4.c, fontSize: 30.c),
        headlineMedium: poppins.copyWith(fontSize: 26.c),
        headlineSmall: poppins.copyWith(fontSize: 22.5.c),
        titleLarge: GoogleFonts.merriweather(letterSpacing: 4.c, fontSize: (17, 22).c),
        titleMedium:
            poppins.copyWith(color: dark ? Colors.white : Colors.black, fontSize: (15, 18).c), //Textfield label
        titleSmall: poppins.copyWith(color: seedColor, fontSize: (13, 16).c),
        bodyLarge: poppins.copyWith(color: dark ? Colors.white : Colors.black, fontSize: (15, 18).c), //Textfield font
        bodyMedium: const TextStyle(),
        bodySmall: const TextStyle(),
        labelLarge: poppins.copyWith(color: Colors.orange),
        labelMedium: poppins.copyWith(color: Colors.blue),
        labelSmall: poppins.copyWith(color: Colors.teal),
      );

  FilledButtonThemeData get filledButton => FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.c)),
          padding: EdgeInsets.all(12.c),
          // textStyle: poppins.copyWith(fontSize: (14, 18).c),
        ),
      );

  ElevatedButtonThemeData get elevatedButton => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.c)),
          padding: EdgeInsets.all(12.c),
          // textStyle: poppins.copyWith(fontSize: (14, 18).c),
        ),
      );

  OutlinedButtonThemeData get outlinedButton => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.c)),
          padding: EdgeInsets.all(12.c),
          textStyle: poppins.copyWith(fontSize: (14, 18).c),
          // foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      );

  TextButtonThemeData get textButton => TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: AppTheme.tx.bodySmall.under,
          padding: EdgeInsets.zero,
        ),
      );

  InputDecorationTheme get inputDecoration => InputDecorationTheme(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: seedColor),
        ),
        // labelStyle: AppTheme.tx.titleMedium,
        // contentPadding: EdgeInsets.all(12.c),
      );

  ColorScheme get colorScheme => ColorScheme.fromSeed(
        brightness: dark ? Brightness.dark : Brightness.light,
        seedColor: seedColor,

        //
        // primary: Colors.yellow, //filledbutton
        // onPrimary: Colors.yellow, //filledbuttonfont
        // primaryContainer: Colors.purple,//filledButton, floatingActionButton
        // onPrimaryContainer: Colors.white, //text font,
        inversePrimary: Colors.cyan,

        //
        // background: Colors.yellow, //Scaffold
        onBackground: const Color.fromARGB(255, 255, 59, 190),

        //
        secondary: Colors.purple,
        onSecondary: Colors.blue,
        // secondaryContainer: Colors.pink, //NavigationRail
        // onSecondaryContainer: Colors.green, //NavigationRail

        //
        // surface: Colors.yellow, //card
        // onSurface: Colors.yellow, //font, underline
        // surfaceTint: const Color.fromARGB(0, 255, 255, 255), //card tint
        // inverseSurface: Colors.red,//Snackbar background
        onInverseSurface: Colors.blue[900],
        // surfaceVariant: Colors.blue,//tabBarDivider
        // onSurfaceVariant: Colors.yellow, //Textfield lable font

        //
        tertiary: Colors.purple,
        onTertiary: Colors.blue,
        tertiaryContainer: Colors.pink,
        onTertiaryContainer: Colors.green,

        //
        // error: Colors.green,
        // onError: Colors.lime,
        // errorContainer: const Color.fromARGB(255, 167, 242, 170),
        // onErrorContainer: const Color.fromARGB(255, 2, 135, 7),

        //
        // outline: Colors.yellow, //textfield border
        // outlineVariant: Colors.green,//Divider
        // shadow: Colors.blue, //Shadow, elevation
        scrim: Colors.orange,
      );

  ThemeData get theme => ThemeData(
        //
        brightness: dark ? Brightness.dark : Brightness.light,
        useMaterial3: true,
        colorScheme: colorScheme,

        //
        // dividerTheme: DividerThemeData(color: seedColor),

        //
        inputDecorationTheme: inputDecoration,

        //
        outlinedButtonTheme: outlinedButton,
        filledButtonTheme: filledButton,
        elevatedButtonTheme: elevatedButton,
        textButtonTheme: textButton,

        //
        textTheme: textTheme,
      );

  @override
  String toString() {
    return 'AppTheme(size: $size, maxSize: $maxSize, designSize: $designSize, dark: $dark)';
  }
}

// @immutable
// class AppThemeWidget extends InheritedWidget {
//   final bool dark;
//   final Size size;
//   final Size maxSize;
//   final Size designSize;

//   const AppThemeWidget({
//     super.key,
//     required this.dark,
//     required this.size,
//     required this.maxSize,
//     required super.child,
//     required this.designSize,
//   });

//   @override
//   bool updateShouldNotify(covariant AppThemeWidget oldWidget) {
//     print('AppTheme Rebuild');
//     AppTheme.currentAppTheme = AppTheme(dark: dark, maxSize: maxSize, designSize: designSize, size: size);
//     return oldWidget.dark != dark || oldWidget.size != size || oldWidget.designSize != designSize;
//   }

//   static AppThemeWidget? maybeOf(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<AppThemeWidget>();
//   }

//   static AppThemeWidget of(BuildContext context) {
//     final AppThemeWidget? result = maybeOf(context);
//     assert(result != null, 'No AppTheme found in context');
//     return result!;
//   }

//   @override
//   InheritedElement createElement() {
//     AppTheme.currentAppTheme = AppTheme(dark: dark, maxSize: maxSize, designSize: designSize, size: size);
//     print('AppTheme Create');

//     return super.createElement();
//   }
// }
