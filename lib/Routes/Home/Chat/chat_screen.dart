import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Providers/router.dart';

class ChatRoute extends GoRouteData {
  final String chatId;

  const ChatRoute(this.chatId);

  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatPage(
      chatId: chatId,
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat$chatId'),
      ),
    );
  }
}
