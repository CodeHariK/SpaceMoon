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
import 'package:spacemoon/firebase_options.dart';

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaEnterpriseProvider('recaptcha-v3-site-key'),
    androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
  );

  const GOOGLE_CLIENT_ID = '511540428296-nlvfujnup6d6ef2h3kh05hfkmov6jtqa.apps.googleusercontent.com';

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    PhoneAuthProvider(),
    GoogleProvider(clientId: GOOGLE_CLIENT_ID),
    auth.AppleProvider(),
  ]);

  FirebaseFirestore.instance.settings = const Settings(
    host: 'localhost:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}
