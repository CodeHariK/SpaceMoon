import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:spacemoon/Init/init.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:spacemoon/Init/electrify.dart';

void main() {
  electrify(
    title: 'Spacemoon',
    init: init,
    localizationsDelegates: [
      FirebaseUILocalizations.delegate,
      AppFlowyEditorLocalizations.delegate,
    ],
  );
}
