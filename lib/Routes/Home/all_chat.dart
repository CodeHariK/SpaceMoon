import 'package:flutter/material.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';

class AllChatPage extends StatelessWidget {
  const AllChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AllChat'),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                ChatRoute('39dksc').go(context);
              },
              child: Text('Chat')),
        ],
      ),
    );
  }
}
