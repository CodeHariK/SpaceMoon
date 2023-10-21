import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void moonspace({
  required String title,
  required Widget home,
  required List<AsyncCallback> initializers,
}) async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  runApp(const Center(child: CircularProgressIndicator()));

  await Future.wait(initializers.map((init) => init()));

  runApp(
    SpaceMoonHome(
      title: title,
      home: home,
    ),
  );
}

class SpaceMoonHome extends StatelessWidget {
  const SpaceMoonHome({
    super.key,
    required this.title,
    required this.home,
  });

  final String title;
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: home,
      debugShowCheckedModeBanner: kDebugMode,
    );
  }
}
