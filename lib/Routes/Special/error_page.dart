import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:spacemoon/Static/assets.dart';

class Error404Page extends StatelessWidget {
  const Error404Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // GoRouterState state = GoRouterState.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text('${state.uri} does not exist'),
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(32.0),
              child: Lottie.asset(
                Asset.lNotFound,
                reverse: false,
                repeat: true,
              ),
            ),
            ElevatedButton(onPressed: () => context.go('/'), child: const Text('Go to home')),
          ],
        ),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    required this.error,
  });

  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      child: SelectableText(
        (error is FlutterErrorDetails) ? error.exception.toString() : error.toString(),
        style: const TextStyle(color: Colors.purple),
        textDirection: TextDirection.ltr,
      ),

      // SelectableText(
      //   error.toString(),
      //   style: const TextStyle(color: Colors.amber),
      //   textDirection: TextDirection.ltr,
      // ),
      // if (error is FlutterError || error is FlutterErrorDetails)
      //   SelectableText(
      //     error is FlutterErrorDetails ? error.stack.toString() : error.stackTrace.toString(),
      //     style: const TextStyle(color: Colors.red),
      //     textDirection: TextDirection.ltr,
      //   ),
    );
  }
}
