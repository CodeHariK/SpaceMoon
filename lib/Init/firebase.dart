import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:spacemoon/Init/messaging.dart';
import 'package:spacemoon/firebase_options.dart';

const spacemoonStorageBucket = 'spacemoonfire.appspot.com';

Future<void> initFirebase({required bool useEmulator}) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kReleaseMode) {
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('6LdFDOQoAAAAAK3MXEtCTWtlHuiVrH3r2c_rOafy'),
      androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
      appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
    );
  }

  const GOOGLE_CLIENT_ID = '511540428296-nlvfujnup6d6ef2h3kh05hfkmov6jtqa.apps.googleusercontent.com';

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    PhoneAuthProvider(),
    GoogleProvider(clientId: GOOGLE_CLIENT_ID),
    auth.AppleProvider(),
  ]);

  if (useEmulator) {
    await emulator();
  }

  await firebaseMessagingSetup();
}

Future<void> emulator() async {
  if (kDebugMode) {
    try {
      final emulatorHost = defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost';

      FirebaseFirestore.instance.settings = Settings(
        host: '$emulatorHost:8080',
        sslEnabled: false,
        persistenceEnabled: false,
      );

      await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
      FirebaseFunctions.instance.useFunctionsEmulator(emulatorHost, 5001);
      await FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);
      FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
    } catch (e, s) {
      lava(e);
      lava(s);
    }
  }
}
