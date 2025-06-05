import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:moonspace/electrify.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Routes/Home/notifications.dart';
import 'package:spacemoon/main.dart';
import 'package:moonspace/widgets/animated_snackbar.dart';

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
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      dino('User granted provisional permission');
    } else {
      lava('User declined or has not accepted permission');
    }

    firebaseTokenUpdate();

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    dino(initialMessage?.toMap());

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedAppHandler);
    FirebaseMessaging.onMessage.listen(onMessageHandler);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);

    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
          lava('tokenRefresh : $fcmToken');
          callFCMtokenUpdate(fcmToken);
        })
        .onError((err) {
          lava(err);
        });
  }
}

Function(RemoteMessage)? onMessageOpenedAppHandler(RemoteMessage message) {
  messageHandler(message, false, HandlerType.onMessageOpened);
  return null;
}

Function(RemoteMessage)? onMessageHandler(RemoteMessage message) {
  messageHandler(message, false, HandlerType.onMessage);
  return null;
}

Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
  messageHandler(message, true, HandlerType.background);
}

enum HandlerType { onMessage, onMessageOpened, background }

Future<void> messageHandler(
  RemoteMessage message,
  bool background,
  HandlerType type,
) async {
  if (background) {
    await Firebase.initializeApp();
  }

  try {
    final tweet =
        // Tweet(
        //   uid: message.data['uid'],
        //   room: message.data['room'],
        //   user: message.data['user'],
        // );
        Tweet()..mergeFromProto3Json(message.data);

    if (FirebaseAuth.instance.currentUser?.uid == tweet.user) {
      return;
    }

    NotificationsPage.tweetStream.add(tweet);

    BuildContext? context = AppRouter.rootNavigatorKey.currentContext;
    if (context != null && context.mounted) {
      if (type == HandlerType.onMessageOpened) {
        ChatRoute(chatId: tweet.room).push(context);
      }

      if (type == HandlerType.onMessage) {
        AnimatedSnackbar(
          title: message.notification?.title ?? '',
          content: tweet.mediaType == MediaType.TEXT
              ? (message.notification?.body ?? '')
              : '...',
        ).show(Electric.context, alignment: const Alignment(0.0, -.8));
      }
    }

    dino("$tweet");
  } catch (e) {
    lava('Error $e');
  }
}

void firebaseTokenUpdate() async {
  String? token = await FirebaseMessaging.instance.getToken(
    vapidKey:
        'BEjtF-d72Aa2Jx4x1KCoaPjdH2QRtzXLujB2LjcJH1Arepn2rWqfJaTEby9qznl7SXi_fcO94iWSFUGgoGpMJYU',
  );

  dino('FirebaseTokenUpdate : $token');
  callFCMtokenUpdate(token);
}

void callFCMtokenUpdate(String? fcmToken) async {
  if (fcmToken == null || FirebaseAuth.instance.currentUser == null) {
    return;
  }
  try {
    await SpaceMoon.httpCallable(
      'messaging-callFCMtokenUpdate',
    ).call({Const.fcmToken.name: fcmToken});
  } catch (e) {
    debugPrint('callFCMtokenUpdate Error');
  }
}
