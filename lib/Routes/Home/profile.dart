import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/Helper/debug_functions.dart';
import 'package:spacemoon/Providers/auth.dart';

class ProfileRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfilePage();
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final user = ref.watch(currentUserProvider).value;
              return FutureBuilder(
                future: user?.getIdToken(),
                builder: (context, snapshot) {
                  final refreshToken = snapshot.data;
                  return SelectableText((beautifyMap(jwtParse(refreshToken))).toString());
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

Map<String, dynamic>? jwtParse(String? refreshToken) {
  final jwt = refreshToken?.split('.');
  if (jwt != null && jwt.length > 1) {
    String token = jwt[1];
    int l = 4 - (token.length % 4);
    token += List.generate(l, (index) => '=').join();
    final decoded = base64.decode(token);
    token = utf8.decode(decoded);
    return json.decode(token) as Map<String, dynamic>;
  }
  return null;
}
