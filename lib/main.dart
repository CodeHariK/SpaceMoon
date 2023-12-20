import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:spacemoon/Init/init.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:spacemoon/Init/electrify.dart';

class SpaceMoon {
  static String title = 'Spacemoon';
  static bool useEmulator = false;
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
