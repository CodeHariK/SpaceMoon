import 'package:flutter/material.dart';
import 'package:moonspace/moonspace.dart';
import 'package:spacemoon/initializers/firebase.dart';

void main() {
  moonspace(
    title: 'Spacemoon',
    home: const MyHomePage(),
    initializers: [
      initFirebase,
    ],
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
