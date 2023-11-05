import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Error404Page extends StatelessWidget {
  const Error404Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GoRouterState state = GoRouterState.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('${state.uri} does not exist'),
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
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Home'),
                    ),
                    if (error is FlutterErrorDetails)
                      SelectableText(
                        error.exception.toString(),
                        style: const TextStyle(fontSize: 12, color: Colors.purple),
                        textDirection: TextDirection.ltr,
                      ),
                    SelectableText(
                      error.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.amber),
                      textDirection: TextDirection.ltr,
                    ),
                    if (error is FlutterError || error is FlutterErrorDetails)
                      SelectableText(
                        error is FlutterErrorDetails ? error.stack.toString() : error.stackTrace.toString(),
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                        textDirection: TextDirection.ltr,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleError extends StatelessWidget {
  const SimpleError({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: Center(
            child: Column(
              children: [
                const Text('Unknown error'),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
