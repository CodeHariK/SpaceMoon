import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:lottie/lottie.dart';
import 'package:moonspace/pages/error_page.dart';
import 'package:spacemoon/Init/firebase.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:moonspace/electrify.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Static/assets.dart';
import 'package:spacemoon/l10n/app_localizations.dart';

class SpaceMoon {
  static String harikrishnan = 'Hari Krishnan';
  static String title = 'Spacemoon';
  static String domain = 'https://spacemoon.shark.run';
  static String spacemoonGithub = 'https://github.com/codeharik/SpaceMoon';
  static String github = 'https://github.com/codeharik';
  static String sharkrun = 'https://shark.run';
  static String linkedIn = 'https://www.linkedin.com/in/codeharik';
  static String twitter = 'https://www.twitter.com/codeharik';

  static String googleplay =
      'https://play.google.com/store/apps/details?id=run.shark.spacemoon';
  static String appstore =
      'https://apps.apple.com/us/app/spacemoon/id6469975482';
  static String web = 'spacemoon.shark.run';

  static bool debugUi = false;
  static bool debugMode = kDebugMode && true;
  static bool useEmulator = kDebugMode && false;
  static String computerIp = '10.0.2.2';
  // static String computerIp = '192.168.1.4';

  static String build = 'Build : 0.0.1+11';

  static HttpsCallable httpCallable(String function) => useEmulator
      ? FirebaseFunctions.instance.httpsCallable(function)
      : FirebaseFunctions.instanceFor(
          region: 'asia-south1',
        ).httpsCallable(function);
}

void main() {
  electrify(
    title: SpaceMoon.title,
    init: () async {
      usePathUrlStrategy();
      await initFirebase();
    },

    localizationsDelegates: [
      ...AppLocalizations.localizationsDelegates,
      FleatherLocalizations.delegate,
      FirebaseUILocalizations.delegate,
    ],
    supportedLocales: [
      ...AppLocalizations.supportedLocales,
      ...FleatherLocalizations.supportedLocales,
    ],

    electricKey: AppRouter.ElectricNavigatorKey,

    router: spacemoonRouter,

    providerInit: (providerContainer) {
      providerContainer.listen(routerRedirectorProvider, (prev, next) {});
    },

    before: (widgetsBinding) {
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    },
    after: () {
      FlutterNativeSplash.remove();
    },

    errorChild: Error404Page(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(32.0),
        child: Lottie.asset(Asset.lNotFound, reverse: false, repeat: true),
      ),
    ),

    recordFlutterFatalError: (details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    },
    recordError: (Object error, StackTrace stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },

    debugUi: SpaceMoon.debugUi,
  );
}
