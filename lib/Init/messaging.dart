import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:moonspace/form/mario.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';

Future<void> firebaseMessagingSetup() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
  final apnsToken = await messaging.getAPNSToken();

  dino('ApnsToken : $apnsToken');

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

    firebaseTokenUpdate();

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    dino(initialMessage?.toMap());

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true);

    FirebaseMessaging.onMessageOpenedApp.listen((message) => messageHandler(message, true, 'onMessageOpened'));
    FirebaseMessaging.onMessage.listen((message) => messageHandler(message, true, 'onMessage'));
    FirebaseMessaging.onBackgroundMessage((message) => messageHandler(message, true, 'Background'));

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      lava('tokenRefresh : $fcmToken');
      callFCMtokenUpdate(fcmToken);
    }).onError((err) {
      lava(err);
    });
  }
}

Future<void> messageHandler(RemoteMessage message, bool background, String type) async {
  if (background) {
    await Firebase.initializeApp();
  }

  try {
    final t1 = Tweet()..mergeFromProto3Json(message.data);
    t1.uid = message.data['uid'];
    BuildContext? context = AppRouter.rootNavigatorKey.currentContext;
    if (context != null && context.mounted) {
      // ChatRoute(chatId: t1.room).go(context);
      context = AppRouter.scaffoldMessengerKey.currentContext ?? AppRouter.scaffoldMessengerKey.currentState?.context;
      if (context != null) {
        lava('------- toast');

        AnimatedSnackbar(
          content: 'content',
          title: 'title',
        ).show(
          AppRouter.scaffoldMessengerKey.currentContext!,
          alignment: Alignment.topCenter,
        );

        AppRouter.scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            // content: Animate(
            //   effects: [
            //     AlignEffect(
            //       duration: Duration(seconds: 2),
            //       begin: Alignment.bottomRight,
            //       end: Alignment.topLeft,
            //     ),
            //     FadeEffect(),
            //   ],
            //   child: Container(
            //     height: 100,
            //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
            //     child: Text('HelloHelloHelloHelloHelloHelloHelloHello'),
            //   ),
            // ),
            content: TweenAnimationBuilder(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(seconds: 2),
              builder: (context, value, child) {
                return AnimatedAlign(
                  duration: Duration(seconds: 2),
                  alignment:
                      AlignmentGeometry.lerp(Alignment.bottomCenter, Alignment.centerRight, value) ?? Alignment.center,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Text('Hello Hello Hello Hello Hello Hello Hello Hello'),
                  ),
                );
              },
            ),
          ),
        );

        // toastification.show(
        //   context: context,
        //   title: 'Hello, world!',
        //   autoCloseDuration: const Duration(seconds: 5),
        // );
      } else {
        lava('----- no context');
      }
    }

    dino("$t1");
  } catch (e) {
    lava('Error t1 $e');
  }

  dino(type);
  dino("Handling a background message: ${message.messageId}");
  dino("Handling a background message: ${message.notification?.title}");
  dino("Handling a background message: ${message.notification?.body}");
  dino("Handling a background message: ${message.data}");
  dino("Handling a background message: ${message.senderId}");
  dino("Handling a background message: ${message.messageType}");
}

void firebaseTokenUpdate() async {
  String? token = await FirebaseMessaging.instance.getToken(
    vapidKey: 'BEjtF-d72Aa2Jx4x1KCoaPjdH2QRtzXLujB2LjcJH1Arepn2rWqfJaTEby9qznl7SXi_fcO94iWSFUGgoGpMJYU',
  );

  dino('FirebaseTokenUpdate : $token');
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
