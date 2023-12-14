import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:spacemoon/Providers/global_theme.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Routes/Home/account.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Routes/Special/about.dart';
import 'package:spacemoon/Routes/Special/onboard.dart';

@immutable
class SettingsRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const MaterialPage(
      child: SettingsPage(),
    );
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GlobalAppTheme globalAppTheme = ref.watch(globalThemeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CupertinoFormSection.insetGrouped(
              header: const Text('Theme'),
              children: [
                PopupMenuButton<ThemeType>(
                  itemBuilder: (context) {
                    return ThemeType.values
                        .map<PopupMenuEntry<ThemeType>>(
                          (e) => PopupMenuItem(
                            value: e,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text(e.name.toUpperCase()), e.icon],
                            ),
                          ),
                        )
                        .toList();
                  },
                  onSelected: (v) {
                    ref.read(globalThemeProvider.notifier).setThemeType(v);
                  },
                  position: PopupMenuPosition.under,
                  offset: const Offset(1, -120),
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    title: Text('Theme', style: context.tm),
                    subtitle: Text(globalAppTheme.theme.name),
                    trailing: globalAppTheme.theme.icon,
                  ),
                ),

                //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: Colors.primaries
                          .map(
                            (c) => InkWell(
                              onTap: () {
                                ref.read(globalThemeProvider.notifier).setColor(c);
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: c,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              ],
            ),
            CupertinoListTile.notched(
              onTap: () {
                AccountRoute().push(context);
              },
              leading: const Icon(Icons.chevron_right_rounded),
              title: Text('Account Management', style: context.tm),
            ),
            const Divider(),
            CupertinoListTile.notched(
              onTap: () {
                showLicensePage(context: context);
              },
              leading: const Icon(Icons.chevron_right_rounded),
              title: Text('License', style: context.tm),
            ),
            CupertinoListTile.notched(
              onTap: () {
                AboutRoute().push(context);
              },
              leading: const Icon(Icons.chevron_right_rounded),
              title: Text('Developer Info', style: context.tm),
            ),
            const Spacer(),
            CupertinoListTile.notched(
              onTap: () {
                safeLaunchUrl('https://spacemoon.shark.run/privacy_policy.html');
              },
              title: Text('Privacy Policy', style: context.tm),
              leading: const Icon(Icons.chevron_right_rounded),
            ),
            CupertinoListTile.notched(
              onTap: () {
                context.cPush(const AttibutionPage());
              },
              leading: const Icon(Icons.chevron_right_rounded),
              title: Text('Attribution', style: context.tm),
            ),
            if (kDebugMode)
              CupertinoListTile.notched(
                onTap: () {
                  ref.read(onboardedProvider.notifier).set(false);
                },
                title: Text('Onboard false', style: context.tm),
              ),
            if (kDebugMode)
              CupertinoListTile.notched(
                onTap: () {
                  FirebaseMessaging.instance.deleteToken();
                },
                title: Text('Firebase Messaging Token delete', style: context.tm),
              ),
          ],
        ),
      ),
    );
  }
}

class AttibutionPage extends StatelessWidget {
  const AttibutionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attribution')),
      body: const Column(
        children: [
          ListTile(
            title: Text('Unsplash'),
            subtitle: Text('For their wonderful api'),
          ),
        ],
      ),
    );
  }
}
