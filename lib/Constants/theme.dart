import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class AppTheme {
  // static TextStyle get poppins => GoogleFonts.poppins();
  static TextStyle get poppins => const TextStyle();

  static Color get seedColor => const Color.fromARGB(255, 255, 72, 121);

  static TextTheme textTheme({required bool dark}) => TextTheme(
        displayLarge: AppTheme.poppins.copyWith(color: Colors.orange),
        displayMedium: AppTheme.poppins.copyWith(color: Color.fromARGB(255, 226, 32, 32)),
        displaySmall: AppTheme.poppins.copyWith(color: Colors.teal),
        headlineLarge: GoogleFonts.merriweather(letterSpacing: 4.spMin),
        headlineMedium: AppTheme.poppins.copyWith(color: Color.fromARGB(255, 237, 255, 157)),
        headlineSmall: AppTheme.poppins.copyWith(color: Color.fromARGB(255, 211, 123, 255)),
        titleLarge: GoogleFonts.merriweather(letterSpacing: 4.spMin),
        titleMedium: AppTheme.poppins.copyWith(color: dark ? Colors.white : Colors.black),
        titleSmall: AppTheme.poppins.copyWith(color: Color.fromARGB(255, 255, 86, 131)),
        // bodyLarge: AppTheme.poppins.copyWith(color: Colors.purple), //Textfield font
        bodyMedium: AppTheme.poppins.copyWith(color: Color.fromARGB(255, 189, 5, 66)),
        bodySmall: AppTheme.poppins.copyWith(color: Colors.green),
        labelLarge: AppTheme.poppins.copyWith(color: Colors.orange),
        labelMedium: AppTheme.poppins.copyWith(color: Colors.blue),
        labelSmall: AppTheme.poppins.copyWith(color: Colors.teal),
      );

  static FilledButtonThemeData get filledButton => FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0.spMin)),
          backgroundColor: AppTheme.seedColor,
          padding: EdgeInsets.all(12.spMin),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          textStyle: AppTheme.poppins.copyWith(fontSize: 18.spMin),
        ),
      );

  static OutlinedButtonThemeData get outlinedButton => OutlinedButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0.spMin)),
          padding: EdgeInsets.all(12.spMin),
          // foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      );

  static colorScheme({required bool dark}) => ColorScheme.fromSeed(
        brightness: dark ? Brightness.dark : Brightness.light,
        seedColor: AppTheme.seedColor,

        //
        // primary: Colors.yellow, //filledbutton
        // onPrimary: Colors.yellow, //filledbuttonfont
        primaryContainer: Colors.purple,
        onPrimaryContainer: Colors.white, //text font,
        inversePrimary: Colors.cyan,

        //
        // background: Colors.yellow, //Scaffold
        onBackground: const Color.fromARGB(255, 255, 59, 190),

        //
        secondary: Colors.purple,
        onSecondary: Colors.blue,
        secondaryContainer: Colors.pink,
        onSecondaryContainer: Colors.green,

        //
        // surface: Colors.yellow, //card
        // onSurface: Colors.yellow, //font, underline
        surfaceTint: Color.fromARGB(0, 255, 255, 255), //card tint
        inverseSurface: Colors.red,
        onInverseSurface: Colors.blue[900],
        surfaceVariant: Colors.blue,
        // onSurfaceVariant: Colors.yellow, //Textfield lable font

        //
        tertiary: Colors.purple,
        onTertiary: Colors.blue,
        tertiaryContainer: Colors.pink,
        onTertiaryContainer: Colors.green,

        //
        error: Colors.green,
        onError: Colors.lime,
        errorContainer: const Color.fromARGB(255, 167, 242, 170),
        onErrorContainer: Color.fromARGB(255, 2, 135, 7),

        //
        // outline: Colors.yellow, //textfield border
        outlineVariant: Colors.pink,
        // shadow: Colors.blue, //Shadow, elevation
        scrim: Colors.orange,
      );

  static ThemeData theme({required bool dark}) => ThemeData(
        //
        brightness: dark ? Brightness.dark : Brightness.light,
        useMaterial3: true,
        colorScheme: AppTheme.colorScheme(dark: dark),

        //
        dividerTheme: DividerThemeData(color: AppTheme.seedColor),

        //
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.seedColor),
          ),
        ),

        //
        outlinedButtonTheme: AppTheme.outlinedButton,
        filledButtonTheme: AppTheme.filledButton,

        //
        textTheme: AppTheme.textTheme(dark: dark),
      );
}

ThemeData get darkTheme => AppTheme.theme(dark: true);

ThemeData get lightTheme => AppTheme.theme(dark: false);
