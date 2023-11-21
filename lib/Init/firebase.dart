import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Routes/Home/profile.dart';
import 'package:spacemoon/firebase_options.dart';

const spacemoonStorageBucket = 'spacemoonfire.appspot.com';

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('6LdFDOQoAAAAAK3MXEtCTWtlHuiVrH3r2c_rOafy'),
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

  if (!Platform.isAndroid) {
    await emulator();
  }

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      dino('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      dino('User granted provisional permission');
    } else {
      lava('User declined or has not accepted permission');
    }

    String? token = await messaging.getToken(
      vapidKey: 'BFjqeePbCMx5kxv-bTVBte9_maDaqJ6wjydfReBGHaIWJR3Oz54H26XnCXjuXpdF38zCUKkvcbHndNKzvYEf1uQ',
    );

    lava('$token');
    callUserUpdate(User(fcmToken: token));
    messaging.onTokenRefresh.listen((token) {
      callUserUpdate(User(fcmToken: token));
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      dino('Got a message whilst in the foreground!');
      dino('Message data: ${message.data}');

      if (message.notification != null) {
        dino('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  dino("Handling a background message: ${message.messageId}");
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
