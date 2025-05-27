import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart' as auth;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:spacemoon/Init/messaging.dart';
import 'package:spacemoon/firebase_options.dart';
import 'package:spacemoon/main.dart';

const spacemoonStorageBucket = 'spacemoonfire.appspot.com';

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance
      .activate(
        webProvider:
            ReCaptchaV3Provider('6LdFDOQoAAAAAK3MXEtCTWtlHuiVrH3r2c_rOafy'),
        androidProvider: SpaceMoon.debugMode
            ? AndroidProvider.debug
            : AndroidProvider.playIntegrity,
        appleProvider:
            SpaceMoon.debugMode ? AppleProvider.debug : AppleProvider.appAttest,
      )
      .onError(
        (error, stackTrace) => lava(error),
      );

  if (Device.isMobile) {
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!SpaceMoon.debugMode);
  }

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    PhoneAuthProvider(),
    GoogleProvider(
        clientId:
            '511540428296-nlvfujnup6d6ef2h3kh05hfkmov6jtqa.apps.googleusercontent.com'),
    if (Device.isIos || Device.isMacOS) auth.AppleProvider(),
  ]);

  await emulator();

  if (!Device.isWeb) {
    await firebaseMessagingSetup();
  }
}

Future<void> emulator() async {
  if (SpaceMoon.useEmulator) {
    try {
      final emulatorHost =
          Device.isAndroid ? SpaceMoon.computerIp : 'localhost';

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
