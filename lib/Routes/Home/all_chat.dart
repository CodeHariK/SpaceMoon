import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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
            child: const Text('Chat'),
          ),
          TextButton(
            onPressed: () async {
              final res = await FirebaseFunctions.instance.httpsCallable('sayHello').call();
              print(res.data.toString());
            },
            child: const Text('SayHello'),
          ),
          TextButton(
            onPressed: () async {
              FirebaseFirestore.instance.collection('counter').doc('count').set({
                'Counter': FieldValue.increment(1),
              });
            },
            child: const Text('Counter'),
          ),
        ],
      ),
    );
  }
}
