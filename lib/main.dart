import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:spacemoon/Init/init.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:spacemoon/Init/electrify.dart';

class SpaceMoon {
  static String harikrishnan = 'Hari Krishnan';
  static String title = 'Spacemoon';
  static String domain = 'https://spacemoon.shark.run';
  static String spacemoonGithub = 'https://github.com/codeharik/SpaceMoon';
  static String github = 'https://github.com/codeharik';
  static String sharkrun = 'https://shark.run';
  static String linkedIn = 'https://www.linkedin.com/in/codeharik';
  static String twitter = 'https://www.twitter.com/codeharik';

  static String googleplay = 'https://play.google.com/store/apps/details?id=run.shark.spacemoon';
  static String appstore = 'https://apps.apple.com/us/app/spacemoon/id6469975482';
  static String web = 'spacemoon.shark.run';

  static bool debugUi = false;
  static bool debugMode = kDebugMode && false;
  static bool useEmulator = kDebugMode && false;
  static String computerIp = '10.0.2.2';
  // static String computerIp = '192.168.1.4';

  static String build = 'Build : 0.0.1+9';

  static HttpsCallable fn(String function) => useEmulator
      ? FirebaseFunctions.instance.httpsCallable(function)
      : FirebaseFunctions.instanceFor(region: 'asia-south1').httpsCallable(function);
}

void main() {
  electrify(
    title: SpaceMoon.title,
    init: init,
    localizationsDelegates: [
      FirebaseUILocalizations.delegate,
      AppFlowyEditorLocalizations.delegate,
    ],
  );
}
