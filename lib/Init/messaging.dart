import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:spacemoon/Gen/data.pbenum.dart';

Future<void> firebaseMessagingSetup() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
  final apnsToken = await messaging.getAPNSToken();

  dino(apnsToken);

  if (apnsToken == null && Device.isIos) {
    return;
  }

  if (Device.isMobile) {
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

    // lava('init : $token');
    // firebaseTokenUpdate(token);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      dino('Got a message whilst in the foreground!');
      dino('Message data: ${message.data}');

      if (message.notification != null) {
        dino('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      lava('tokenRefresh : $fcmToken');
      callFCMtokenUpdate(fcmToken);
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

void firebaseTokenUpdate() async {
  String? token = await FirebaseMessaging.instance.getToken(
    vapidKey: 'BFjqeePbCMx5kxv-bTVBte9_maDaqJ6wjydfReBGHaIWJR3Oz54H26XnCXjuXpdF38zCUKkvcbHndNKzvYEf1uQ',
  );
  dino('firebaseTokenUpdate : $token');
  callFCMtokenUpdate(token);
}

void callFCMtokenUpdate(String? fcmToken) async {
  if (fcmToken == null || FirebaseAuth.instance.currentUser == null) {
    return;
  }
  try {
    await FirebaseFunctions.instance.httpsCallable('callFCMtokenUpdate').call({
      Const.fcmToken.name: fcmToken,
    });
  } catch (e) {
    debugPrint('callFCMtokenUpdate Failed');
  }
}
