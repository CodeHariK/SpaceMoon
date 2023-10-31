import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart';
import 'package:spacemoon/Data/data.pb.dart';
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
      body: Wrap(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('USERS')
                .doc(auth.FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              final u = User().mergeMap<User>(snapshot.data?.data() ?? {});

              return Column(
                children: [
                  Text(u.created.toString()),
                  Text(DateTime.tryParse(u.created).toString()),
                  Text(u.toMap().toString()),
                ],
              );
            },
          ),
          TextButton(
            onPressed: () {
              print(
                List.generate(
                  100,
                  (index) async {
                    final d = DateTime.fromMillisecondsSinceEpoch(1000 * Random().nextInt(1698767140));
                    FirebaseFirestore.instance.collection('dates').add(
                      {
                        'data': d,
                        'utc': d.toUtc().toString(),
                        'iso': d.toIso8601String(),
                        'string': d.toString(),
                      },
                    );
                    return d;
                  },
                ),
              );
            },
            child: Text('Datetime test'),
          ),
          TextButton(
            onPressed: () {
              ChatRoute('39dksc').go(context);
            },
            child: const Text('Chat'),
          ),
          TextButton(
            onPressed: () async {
              final res = await FirebaseFunctions.instance.httpsCallable('sayHello').call(
                    'Sol',
                  );
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
              print(json.encode(json.encode(User(uid: 'Hello').toProto3Json())));
              print(json.encode(User(uid: 'Hello').toProto3Json()));
              print(User(uid: 'Hello').writeToJson());
              print(User.fromJson(User(uid: 'Hello').writeToJson()).toProto3Json());
              print(User(uid: 'H', nick: 'Nick').mergeMap(User(uid: 'Hello').toMap()!).toMap());
            },
            child: const Text('Check'),
          ),
          TextButton(
            onPressed: () async {
              print(
                User(
                  photoURL: 'https://avatars.githubusercontent.com/u/144345505?v=4',
                ).toMap(),
              );
              FirebaseFunctions.instance.httpsCallable('callUserUpdate').call(
                    User(
                      photoURL: 'https://avatars.githubusercontent.com/u/144345505?v=4',
                    ).toMap(),
                  );
            },
            child: const Text('Update Profile'),
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

  T mergeMap<T extends GeneratedMessage>(Map<String, dynamic>? map) {
    return (this as T)..mergeFromProto3Json(map, ignoreUnknownFields: true);
  }
}
