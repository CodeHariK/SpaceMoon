import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart';
import 'package:spacemoon/Data/user.pb.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Static/Widget/google_logo.dart';

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
              FirebaseFirestore.instance.doc('counter/count/county/cow').set({
                'Counter': FieldValue.increment(5),
              });
            },
            child: const Text('Counter'),
          ),
          TextButton(
            onPressed: () async {
              FirebaseFirestore.instance.collection('messages').doc('count').set({
                'Counter': 'hello',
              });
            },
            child: const Text('Uppercase'),
          ),
          TextButton(
            onPressed: () async {
              FirebaseStorage.instance.ref('Hello').putData(GoogleLogo.google);
            },
            child: const Text('Storage'),
          ),
          TextButton(
            onPressed: () async {
              print(json.encode(json.encode(User(id: 'Hello').toProto3Json())));
              print(json.encode(User(id: 'Hello').toProto3Json()));
              print(User(id: 'Hello').writeToJson());
              print(User.fromJson(User(id: 'Hello').writeToJson()).toProto3Json());
              print(User(id: 'H', nick: 'Nick').mergeMap(User(id: 'Hello').toMap()!).toMap());
            },
            child: const Text('Check'),
          ),
        ],
      ),
    );
  }
}

extension ProtoParse on GeneratedMessage {
  Map<String, dynamic>? toMap() {
    try {
      return (json.decode(json.encode(toProto3Json())) as Map<String, dynamic>);
    } catch (e) {
      print('Protobuf parsing error');
    }
    return null;
  }

  String stringify() {
    return toMap().toString();
  }

  void log() {
    print(stringify());
  }

  GeneratedMessage mergeMap(Map<String, dynamic> map) {
    return this..mergeFromProto3Json(map, ignoreUnknownFields: true);
  }
}
