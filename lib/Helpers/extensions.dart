import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const CrossAxisAlignment cStart = CrossAxisAlignment.start;
const CrossAxisAlignment cCenter = CrossAxisAlignment.center;
const CrossAxisAlignment cEnd = CrossAxisAlignment.end;

const MainAxisAlignment mStart = MainAxisAlignment.start;
const MainAxisAlignment mCenter = MainAxisAlignment.center;
const MainAxisAlignment mEnd = MainAxisAlignment.end;
const MainAxisAlignment mAround = MainAxisAlignment.spaceAround;
const MainAxisAlignment mBet = MainAxisAlignment.spaceBetween;
const MainAxisAlignment mEven = MainAxisAlignment.spaceEvenly;

const MainAxisSize mMax = MainAxisSize.max;
const MainAxisSize mMin = MainAxisSize.min;

typedef Ei = EdgeInsets;
typedef Mq = MediaQuery;
typedef Brr = BorderRadius;

extension SuperMediaQueryData on MediaQueryData {
  double get w => size.width;
  double get h => size.height;
  double get ar => size.aspectRatio;
  double get pxr => devicePixelRatio;
  double get tsf => textScaleFactor;
  bool get ver => orientation == Orientation.portrait;
  bool get hor => orientation == Orientation.landscape;
  EdgeInsets get pad => padding;
  EdgeInsets get vi => viewInsets;
  EdgeInsets get vp => viewPadding;
}

extension SuperThemeData on ThemeData {
  //
  ColorScheme get cs => colorScheme;
  Brightness get brightness => colorScheme.brightness;
  //
  Color get csErr => colorScheme.error;
  Color get csErrCon => colorScheme.errorContainer;
  //
  Color get csOut => colorScheme.outline;
  Color get csOutVar => colorScheme.outlineVariant;
  //
  Color get csShadow => colorScheme.shadow;
  Color get csScrim => colorScheme.scrim;
  //
  Color get csSur => colorScheme.surface;
  Color get csOnSur => colorScheme.onSurface;
  Color get csInvSur => colorScheme.inverseSurface;
  Color get csOnInvSur => colorScheme.onInverseSurface;
  Color get csSurTint => colorScheme.surfaceTint;
  Color get csSurVar => colorScheme.surfaceVariant;
  //
  Color get csSec => colorScheme.secondary;
  Color get csSecCon => colorScheme.secondaryContainer;
  Color get csOnSec => colorScheme.onSecondary;
  Color get csOnSecCon => colorScheme.onSecondaryContainer;
  //
  Color get csPri => colorScheme.primary;
  Color get csOnPri => colorScheme.onPrimary;
  Color get csPriCon => colorScheme.primaryContainer;
  Color get csOnPriCon => colorScheme.onPrimaryContainer;
  Color get csInvPri => colorScheme.inversePrimary;
  //
  Color get csBg => colorScheme.background;
  Color get csOnBg => colorScheme.onBackground;
  //
  Color get csTer => colorScheme.tertiary;
  Color get csTerCon => colorScheme.tertiaryContainer;
  Color get csOnTerCon => colorScheme.onTertiaryContainer;
  //
  Color get pri => primaryColor;
  Color get priColDark => primaryColorDark;
  Color get primColLight => primaryColorLight;
  Color get canvas => canvasColor;
  Color get card => cardColor;
  Color get hint => hintColor;
  Color get splash => splashColor;
  Color get shadow => shadowColor;
  Color get indicator => indicatorColor;
  Color get disabled => disabledColor;
  Color get dioalogBg => dialogBackgroundColor;
  Color get scafBg => scaffoldBackgroundColor;
  Color get highlight => highlightColor;
}

class Device {
  static bool get isAndroid => Platform.isAndroid;
  static bool get isIos => Platform.isIOS;
  static bool get isMobile => isAndroid || isIos;
  static bool get isWebMobile => isAndroid || isIos || isWeb;
  static bool get isWindows => Platform.isWindows;
  static bool get isMac => Platform.isMacOS;
  static bool get isPc => isMac || isWindows;
  static bool get isWeb => kIsWeb;
}

extension SuperContext on BuildContext {
  //
  Brightness get b => theme.brightness;

  //
  ThemeData get theme => Theme.of(this);
  CupertinoThemeData get cupertinoTheme => CupertinoThemeData(
        brightness: theme.brightness,
        textTheme: CupertinoTextThemeData(primaryColor: theme.pri),
      );

  TextStyle? get dl => theme.textTheme.displayLarge;
  TextStyle? get dm => theme.textTheme.displayMedium;
  TextStyle? get ds => theme.textTheme.displaySmall;
  //
  TextStyle? get hl => theme.textTheme.headlineLarge;
  TextStyle? get hm => theme.textTheme.headlineMedium;
  TextStyle? get hs => theme.textTheme.headlineSmall;
  //
  TextStyle? get bl => theme.textTheme.bodyLarge;
  TextStyle? get bm => theme.textTheme.bodyMedium;
  TextStyle? get bs => theme.textTheme.bodySmall;
  //
  TextStyle? get ll => theme.textTheme.labelLarge;
  TextStyle? get lm => theme.textTheme.labelMedium;
  TextStyle? get ls => theme.textTheme.labelSmall;
  //
  TextStyle? get tl => theme.textTheme.titleLarge;
  TextStyle? get tm => theme.textTheme.titleMedium;
  TextStyle? get ts => theme.textTheme.titleSmall;

  //
  TargetPlatform get platform => theme.platform;
  TargetPlatform get ios => TargetPlatform.iOS;
  TargetPlatform get android => TargetPlatform.android;

  //
  MediaQueryData get mq => MediaQuery.of(this);
  double get pixelsPerInch => Platform.isAndroid || Platform.isIOS ? 150 : 96;

  bool get keyboardVisible => mq.viewInsets.bottom != 0;

  bool get isLandscape => mq.orientation == Orientation.landscape;

  Size get sizePx => mq.size;

  double get widthPx => sizePx.width;

  double get shortPx => sizePx.shortestSide;

  double get ratioPx => mq.devicePixelRatio;
  double get txScale => mq.textScaleFactor;

  /// Returns same as MediaQuery.of(context).height
  double get heightPx => sizePx.height;

  double get ratioHW => sizePx.height / sizePx.width;

  /// Returns diagonal screen pixels
  double get diagonalPx {
    final Size s = sizePx;
    return sqrt((s.width * s.width) + (s.height * s.height));
  }

  /// Returns pixel size in Inches
  Size get sizeInches {
    final Size pxSize = sizePx;
    return Size(pxSize.width / pixelsPerInch, pxSize.height / pixelsPerInch);
  }

  /// Returns screen width in Inches
  double get widthInches => sizeInches.width;

  /// Returns screen height in Inches
  double get heightInches => sizeInches.height;

  /// Returns screen diagonal in Inches
  double get diagonalInches => diagonalPx / pixelsPerInch;

  /// Returns fraction (0-1) of screen width in pixels
  double widthPct(double fraction) => fraction * widthPx;

  /// Returns fraction (0-1) of screen height in pixels
  double heightPct(double fraction) => fraction * heightPx;

  //
  NavigatorState get nav => Navigator.of(this);
}

extension SuperNavigatorState on NavigatorState {
  Future<T?> rSlidePush<T>(Widget widget) => push<T?>(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var tween = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero);
            var curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic);

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
        ),
      );
  Future<T?> bSlidePush<T>(Widget widget) => push<T?>(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var tween = Tween<Offset>(begin: const Offset(0, 1.0), end: Offset.zero);
            var curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic);

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
        ),
      );
  Future<T?> scalePush<T>(Widget widget) => push<T?>(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
        ),
      );
  Future<T?> mPush<T>(Widget widget) => push<T?>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => widget,
        ),
      );
  Future<T?> cPush<T>(Widget widget) => push<T?>(
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (_) => widget,
        ),
      );
}

extension SuperInt on int {
  Duration get mic => Duration(microseconds: this);
  Duration get mil => Duration(milliseconds: this);
  Duration get sec => Duration(seconds: this);
  Duration get min => Duration(minutes: this);
  Duration get hour => Duration(hours: this);
  Duration get day => Duration(days: this);
}

extension SuperDuration on Duration {
  Duration operator +(Duration d) => Duration(
        microseconds: d.inMicroseconds + inMicroseconds,
        milliseconds: d.inMilliseconds + inMilliseconds,
        seconds: d.inSeconds + inSeconds,
        minutes: d.inMinutes + inMinutes,
        hours: d.inHours + inHours,
        days: d.inDays + inDays,
      );
  Duration operator -(Duration d) => Duration(
        microseconds: inMicroseconds - d.inMicroseconds,
        milliseconds: inMilliseconds - d.inMilliseconds,
        seconds: inSeconds - d.inSeconds,
        minutes: inMinutes - d.inMinutes,
        hours: inHours - d.inHours,
        days: inDays - d.inDays,
      );

  Future<T> delay<T>([Future<T> Function()? computation]) => Future.delayed(this, computation);
}

extension SuperNumber on num {
  TextStyle get ts => TextStyle(fontSize: toDouble());

  SizedBox get sz => SizedBox(height: toDouble(), width: toDouble());

  EdgeInsets get e => EdgeInsets.all(toDouble());
  EdgeInsets get ev => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get eh => EdgeInsets.symmetric(horizontal: toDouble());

  Radius get r => Radius.circular(toDouble());

  BorderRadius get br => BorderRadius.circular(toDouble());

  BorderSide get bs => BorderSide(width: toDouble());

  StadiumBorder get stadium => StadiumBorder(side: bs);
  CircleBorder get circle => CircleBorder(side: bs);
  StarBorder get star => StarBorder(side: bs);
  RoundedRectangleBorder get bRound => RoundedRectangleBorder(side: bs);
  BeveledRectangleBorder get bBev => BeveledRectangleBorder(side: bs);
  OutlineInputBorder get bOut => OutlineInputBorder(borderSide: bs);
  UnderlineInputBorder get bUline => UnderlineInputBorder(borderSide: bs);

  RoundedRectangleBorder get rRound => RoundedRectangleBorder(borderRadius: br);
  BeveledRectangleBorder get rBev => BeveledRectangleBorder(borderRadius: br);
  OutlineInputBorder get rOut => OutlineInputBorder(borderRadius: br);
  UnderlineInputBorder get rUline => UnderlineInputBorder(borderRadius: br);
}

extension SuperRoundedRectangleBorder on RoundedRectangleBorder {
  RoundedRectangleBorder r(num r) => copyWith(borderRadius: r.br);
  RoundedRectangleBorder w(num r) => copyWith(side: r.bs);
}

extension SuperBeveledRectangleBorder on BeveledRectangleBorder {
  BeveledRectangleBorder r(num r) => copyWith(borderRadius: r.br);
  BeveledRectangleBorder w(num r) => copyWith(side: r.bs);
}

extension SuperOutlineInputBorder on OutlineInputBorder {
  OutlineInputBorder r(num r) => copyWith(borderRadius: r.br);
  OutlineInputBorder w(num r) => copyWith(borderSide: r.bs);
  OutlineInputBorder pad(num r) => copyWith(gapPadding: r.toDouble());
}

extension SuperUnderlineInputBorder on UnderlineInputBorder {
  UnderlineInputBorder r(num r) => copyWith(borderRadius: r.br);
  UnderlineInputBorder w(num r) => copyWith(borderSide: r.bs);
}

extension SuperBorder on BorderSide {
  BorderSide w(num v) => copyWith(width: v.toDouble());
  BorderSide c(Color c) => copyWith(color: c);

  Border get border => Border.all(width: width, color: color);
  StadiumBorder get stadium => StadiumBorder(side: this);
  CircleBorder get circle => CircleBorder(side: this);
  RoundedRectangleBorder get round => RoundedRectangleBorder(side: this);
  StarBorder get star => StarBorder(side: this);
  BeveledRectangleBorder get bev => BeveledRectangleBorder(side: this);
  OutlineInputBorder get out => OutlineInputBorder(borderSide: this);
  UnderlineInputBorder get uline => UnderlineInputBorder(borderSide: this);
}

extension SuperNumber2 on (num, num) {
  SizedBox get s => SizedBox(height: $1.toDouble(), width: $2.toDouble());

  EdgeInsets get e => EdgeInsets.symmetric(
        vertical: this.$1.toDouble(),
        horizontal: this.$2.toDouble(),
      );

  Radius get r => Radius.elliptical(
        this.$1.toDouble(),
        this.$2.toDouble(),
      );

  BorderRadius get brh => BorderRadius.horizontal(
        left: this.$1.r,
        right: this.$2.r,
      );

  BorderRadius get brv => BorderRadius.vertical(
        top: this.$1.r,
        bottom: this.$2.r,
      );
}

extension SuperNumber3 on (num l, num t, num r, num b) {
  EdgeInsets get e => EdgeInsets.only(
        left: this.$1.toDouble(),
        top: this.$2.toDouble(),
        right: this.$3.toDouble(),
        bottom: this.$4.toDouble(),
      );

  BorderRadius get br => BorderRadius.only(
        topLeft: this.$1.toDouble().r,
        topRight: this.$2.toDouble().r,
        bottomRight: this.$3.toDouble().r,
        bottomLeft: this.$4.toDouble().r,
      );
}

extension SuperNumber4 on ({num l, num t, num r, num b}) {
  EdgeInsets get e => EdgeInsets.only(
        left: this.l.toDouble(),
        right: this.r.toDouble(),
        top: this.t.toDouble(),
        bottom: this.b.toDouble(),
      );

  BorderRadius get br => BorderRadius.only(
        topLeft: this.l.toDouble().r,
        topRight: this.r.toDouble().r,
        bottomRight: this.t.toDouble().r,
        bottomLeft: this.b.toDouble().r,
      );
}

extension SuperTextStyle on TextStyle? {
  //
  Text text(String text) => Text(text, style: this);

  //
  TextStyle? get normal => this?.copyWith(fontWeight: FontWeight.normal, fontStyle: FontStyle.normal);
  TextStyle? get bold => this?.copyWith(fontWeight: FontWeight.bold);
  TextStyle? get w1 => this?.copyWith(fontWeight: FontWeight.w100);
  TextStyle? get w2 => this?.copyWith(fontWeight: FontWeight.w200);
  TextStyle? get w3 => this?.copyWith(fontWeight: FontWeight.w300);
  TextStyle? get w4 => this?.copyWith(fontWeight: FontWeight.w400);
  TextStyle? get w5 => this?.copyWith(fontWeight: FontWeight.w500);
  TextStyle? get w6 => this?.copyWith(fontWeight: FontWeight.w600);
  TextStyle? get w7 => this?.copyWith(fontWeight: FontWeight.w700);
  TextStyle? get w8 => this?.copyWith(fontWeight: FontWeight.w800);
  TextStyle? get w9 => this?.copyWith(fontWeight: FontWeight.w900);

  //
  TextStyle? get dot => this?.copyWith(decorationStyle: TextDecorationStyle.dotted);
  TextStyle? get dash => this?.copyWith(decorationStyle: TextDecorationStyle.dashed);
  TextStyle? get solid => this?.copyWith(decorationStyle: TextDecorationStyle.solid);
  TextStyle? get doub => this?.copyWith(decorationStyle: TextDecorationStyle.double);
  TextStyle? get wavy => this?.copyWith(decorationStyle: TextDecorationStyle.wavy);

  //
  TextStyle? get none => this?.copyWith(decoration: TextDecoration.none);
  TextStyle? get line => this?.copyWith(decoration: TextDecoration.lineThrough);
  TextStyle? get over => this?.copyWith(decoration: TextDecoration.overline);
  TextStyle? get under => this?.copyWith(decoration: TextDecoration.underline);

  //
  TextStyle? shadow(List<Shadow> shadows) => this?.copyWith(shadows: shadows);

  //
  TextStyle? get even => this?.copyWith(leadingDistribution: TextLeadingDistribution.even);
  TextStyle? get proportional => this?.copyWith(leadingDistribution: TextLeadingDistribution.proportional);

  //
  TextStyle? paintf(Paint paint) => this?.copyWith(foreground: paint);
  TextStyle? paintb(Paint paint) => this?.copyWith(foreground: paint);

  //
  TextStyle? c(Color c) => this?.copyWith(color: c);

  //
  TextStyle? get italic => this?.copyWith(fontStyle: FontStyle.italic);

  //
  TextStyle? get ellipsis => this?.copyWith(overflow: TextOverflow.ellipsis);
  TextStyle? get clip => this?.copyWith(overflow: TextOverflow.clip);
  TextStyle? get fade => this?.copyWith(overflow: TextOverflow.fade);

  //
  TextStyle? ls(num v) => this?.copyWith(letterSpacing: v.toDouble());
  TextStyle? ws(num v) => this?.copyWith(wordSpacing: v.toDouble());
  TextStyle? height(num v) => this?.copyWith(height: v.toDouble());
  TextStyle? dt(num v) => this?.copyWith(decorationThickness: v.toDouble());
  TextStyle? fs(num v) => this?.copyWith(fontSize: v.toDouble());
  TextStyle? fc(Color? c) => this?.copyWith(color: c);
  TextStyle? bc(Color? c) => this?.copyWith(color: c);

  //
  TextStyle? get baseAlpha => this?.copyWith(textBaseline: TextBaseline.alphabetic);
  TextStyle? get baseIdeo => this?.copyWith(textBaseline: TextBaseline.ideographic);
}
