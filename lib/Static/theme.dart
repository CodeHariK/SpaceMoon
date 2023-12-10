import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moonspace/helper/extensions/color.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';

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

  final Color appColor;

  static AppTheme currentAppTheme = AppTheme(
    size: const Size(360, 780),
    maxSize: const Size(1366, 1024),
    designSize: const Size(360, 780),
    dark: false,
    appColor: Colors.indigo,
  );

  static bool get darkness => currentAppTheme.dark;
  static Color get background => AppTheme.darkness ? const Color.fromARGB(255, 60, 60, 60) : Colors.white;
  static Color get op => AppTheme.darkness ? Colors.white : const Color.fromARGB(255, 55, 55, 55);
  static Color get card =>
      AppTheme.darkness ? const Color.fromARGB(255, 45, 45, 45) : const Color.fromARGB(255, 248, 248, 248);
  static Color get seedCard => AppTheme.darkness ? seedColor.darken(.6) : seedColor.lighten(.2);

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
    required this.appColor,
  });

  // static TextStyle get poppins => GoogleFonts.poppins();
  static TextStyle get poppins => const TextStyle();

  static Color get seedColor => currentAppTheme.appColor;

  FilledButtonThemeData get filledButtonTheme => FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.c)),
          padding: EdgeInsets.all(12.c),
          // textStyle: poppins.copyWith(fontSize: (14, 18).c),
        ),
      );

  ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.c)),
          padding: EdgeInsets.all(12.c),
          // textStyle: poppins.copyWith(fontSize: (14, 18).c),
        ),
      );

  OutlinedButtonThemeData get outlinedButtonTheme => OutlinedButtonThemeData(
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

  static InputDecorationTheme get inputDecoration => InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: seedColor),
        ),

        // labelStyle: AppTheme.tx.titleMedium,
        // contentPadding: EdgeInsets.all(12.c),
      );

  static InputDecoration get uInputDecoration => InputDecoration(
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        // border: InputBorder.none,
        focusedBorder: 1.bs.c(const Color.fromARGB(50, 103, 103, 103)).uline,
        errorBorder: 1.bs.c(const Color.fromARGB(139, 255, 116, 116)).uline,
        focusedErrorBorder: 1.bs.c(const Color.fromARGB(139, 255, 116, 116)).uline,
      );

  DialogTheme get dialogTheme => DialogTheme(
        shadowColor: seedColor,
        elevation: 2,
        actionsPadding: const EdgeInsets.only(right: 12, bottom: 8),
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide.none,
        ),
      );

  AppBarTheme get appBarTheme => AppBarTheme(
        color: AppTheme.card,
        surfaceTintColor: Colors.white,
      );

  CardTheme get cardTheme => CardTheme(
        color: AppTheme.darkness ? const Color.fromARGB(255, 68, 61, 71) : const Color.fromARGB(255, 250, 239, 255),
        elevation: 0,
      );

  ListTileThemeData get listTileTheme => const ListTileThemeData(
      // tileColor: AppTheme.card,
      // shape: 1.bs.c(AppTheme.seedCard).border,
      );

  ColorScheme get colorScheme => ColorScheme.fromSeed(
        brightness: dark ? Brightness.dark : Brightness.light,
        seedColor: seedColor,

        //
        // primary: Colors.yellow, //filledbutton
        // onPrimary: Colors.yellow, //filledbuttonfont
        // primaryContainer: Colors.purple, //filledButton, floatingActionButton
        // onPrimaryContainer: Colors.white, //text font,
        // inversePrimary: Colors.cyan,

        // background: AppTheme.background, //Scaffold
        // onBackground: const Color.fromARGB(255, 255, 59, 190),

        // secondary: Colors.purple,
        // onSecondary: Colors.blue,
        // secondaryContainer: Colors.pink, //NavigationRail
        // onSecondaryContainer: Colors.green, //NavigationRail

        // surface: Colors.yellow, //card, appbar
        onSurface: AppTheme.op, //font, underline
        // surfaceTint: const Color.fromARGB(0, 255, 255, 255), //card tint
        // inverseSurface: Colors.red, //Snackbar background
        // onInverseSurface: Colors.blue[900],
        // surfaceVariant: Colors.blue, //tabBarDivider
        // onSurfaceVariant: Colors.yellow, //Textfield lable font

        // tertiary: Colors.purple,
        // onTertiary: Colors.blue,
        // tertiaryContainer: Colors.pink,
        // onTertiaryContainer: Colors.green,

        // error: Colors.green,
        // onError: Colors.lime,
        // errorContainer: const Color.fromARGB(255, 167, 242, 170),
        // onErrorContainer: const Color.fromARGB(255, 2, 135, 7),

        // outline: Colors.yellow, //textfield border
        // outlineVariant: Colors.green, //Divider
        // shadow: Colors.blue, //Shadow, elevation
        // scrim: Colors.orange,
      );

  TextTheme get textTheme => TextTheme(
        displayLarge: GoogleFonts.merriweather(letterSpacing: 4.c, fontSize: 42.c),
        displayMedium: GoogleFonts.merriweather(letterSpacing: 4.c, fontSize: 36.c),
        displaySmall: GoogleFonts.merriweather(letterSpacing: 4.c, fontSize: 32.c),
        headlineLarge: GoogleFonts.merriweather(letterSpacing: 4.c, fontSize: (28, 36).c),
        headlineMedium: GoogleFonts.merriweather(letterSpacing: 3.c, fontSize: 24.c),
        headlineSmall: GoogleFonts.merriweather(fontSize: 20.c),
        titleLarge: GoogleFonts.merriweather(letterSpacing: 2.c, fontSize: (18, 20).c),
        titleMedium: GoogleFonts.merriweather(
            letterSpacing: 1.c, color: dark ? Colors.white : Colors.black, fontSize: (15, 18).c), //Textfield label
        titleSmall: poppins.copyWith(fontSize: (15, 18).c),
        bodyLarge: poppins.copyWith(color: dark ? Colors.white : Colors.black, fontSize: (15, 18).c), //Textfield font
        bodyMedium: poppins,
        bodySmall: poppins,
        labelLarge: TextStyle(letterSpacing: .5.c, fontWeight: FontWeight.w400),
        labelMedium: const TextStyle(),
        labelSmall: const TextStyle(),
      );

  ThemeData get theme => ThemeData(
        //
        brightness: dark ? Brightness.dark : Brightness.light,
        useMaterial3: true,
        colorScheme: colorScheme,
        textTheme: textTheme,

        //
        // dividerTheme: DividerThemeData(color: seedColor),

        //
        inputDecorationTheme: inputDecoration,

        scaffoldBackgroundColor: AppTheme.background,
        // splashColor: ,
        appBarTheme: appBarTheme,

        //
        listTileTheme: listTileTheme,

        //
        outlinedButtonTheme: outlinedButtonTheme,
        filledButtonTheme: filledButtonTheme,
        elevatedButtonTheme: elevatedButtonTheme,
        textButtonTheme: textButton,

        //
        dialogTheme: dialogTheme,

        //
        cardTheme: cardTheme,
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
