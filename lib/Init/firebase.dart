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
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/firebase_options.dart';

const spacemoonStorageBucket = 'spacemoonfire.appspot.com';

Future<void> initFirebase({required bool useEmulator}) async {
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

Future<void> firebaseMessagingSetup() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
  final apnsToken = await messaging.getAPNSToken();

  dino(apnsToken);

  if (apnsToken == null && Platform.isIOS) {
    return;
  }

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
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

    lava('init : $token');
    firebaseTokenUpdate(token);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      dino('Got a message whilst in the foreground!');
      dino('Message data: ${message.data}');

      if (message.notification != null) {
        dino('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      lava('tokenRefresh : $token');
      firebaseTokenUpdate(token);
    }).onError((err) {
      lava(err);
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

void firebaseTokenUpdate(String? token) {
  callUserUpdate(User(fcmToken: token));
  FirebaseMessaging.instance.onTokenRefresh.listen((token) {
    lava('tokenrefresh : $token');
    callUserUpdate(User(fcmToken: token));
  });
}
