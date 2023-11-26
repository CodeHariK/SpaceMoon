import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/foundation.dart';
import 'package:spacemoon/Init/init.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:spacemoon/Init/electrify.dart';

class SpaceMoon {
  static String title = 'Spacemoon';
}

void main() {
  electrify(
    title: SpaceMoon.title,
    init: kDebugMode ? emulatorInit : init,
    localizationsDelegates: [
      FirebaseUILocalizations.delegate,
      AppFlowyEditorLocalizations.delegate,
    ],
  );
}
