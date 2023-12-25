import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:photo_view/photo_view.dart';
import 'package:spacemoon/Helpers/gorouter_ext.dart';
import 'package:spacemoon/Providers/global_theme.dart';
import 'package:spacemoon/Providers/router.dart';
import 'package:spacemoon/Routes/Home/account.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Routes/Special/about.dart';
import 'package:spacemoon/Routes/Special/onboard.dart';
import 'package:spacemoon/main.dart';

@immutable
class SettingsRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadePage(
      context,
      state,
      const SettingsPage(),
    );
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GlobalAppTheme globalAppTheme = ref.watch(globalThemeProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings', style: context.tl),
        // leading: BackButton(
        //     style: const ButtonStyle(iconSize: MaterialStatePropertyAll(24)), onPressed: () => context.pop()),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: CupertinoFormSection(
            children: [
              CupertinoFormSection.insetGrouped(
                // header: Text('', style: context.tl),
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
                  ),
                ],
              ),
              CupertinoFormSection.insetGrouped(
                header: Text('About', style: context.bl),
                children: [
                  CupertinoListTile.notched(
                    onTap: () {
                      AccountRoute().push(context);
                    },
                    leading: const Icon(Icons.chevron_right_rounded),
                    title: Text('Account Management', style: context.tm),
                  ),
                  CupertinoListTile.notched(
                    onTap: () {
                      context.fPush(const FeedbackPage());
                    },
                    leading: const Icon(Icons.chevron_right_rounded),
                    trailing: FilledButton(
                      onPressed: () {
                        BetterFeedback.of(context).show(
                          (UserFeedback feedback) {
                            FirebaseStorage.instance.ref('feedback/${DateTime.now().toIso8601String()}').putData(
                                  feedback.screenshot,
                                  SettableMetadata(
                                    contentType: 'feedback/png',
                                    customMetadata: {
                                      'feedback': feedback.text,
                                    },
                                  ),
                                );
                          },
                        );
                      },
                      child: const Text('Send Feedback'),
                    ),
                    title: Text('Feedback', style: context.tm),
                  ),
                  CupertinoListTile.notched(
                    onTap: () {
                      AboutRoute().push(context);
                    },
                    leading: const Icon(Icons.chevron_right_rounded),
                    title: Text('Developer Info', style: context.tm),
                  ),
                ],
              ),
              CupertinoFormSection.insetGrouped(
                header: Text('Legals', style: context.bl),
                children: [
                  CupertinoListTile.notched(
                    onTap: () {
                      showLicensePage(context: context);
                    },
                    leading: const Icon(Icons.chevron_right_rounded),
                    title: Text('License', style: context.tm),
                  ),
                  CupertinoListTile.notched(
                    onTap: () {
                      safeLaunchUrl('https://spacemoonfire.web.app/privacy/policy.html');
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
            ],
          ),
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
      body: Column(
        children: [
          ListTile(
            title: const Text('Unsplash'),
            subtitle: const Text('For their wonderful api'),
            onTap: () {
              safeLaunchUrl('https://unsplash.com/');
            },
          ),
          ListTile(
            title: const Text('Google Play'),
            subtitle: const Text('Google Play and the Google Play logo are trademarks of Google LLC.'),
            onTap: () {
              safeLaunchUrl(SpaceMoon.googleplay);
            },
          ),
        ],
      ),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: FutureBuilder(
        future: FirebaseStorage.instance.ref('feedback').list(const ListOptions(maxResults: 10)),
        builder: (context, snapshot) {
          if (snapshot.data == null) return const Text('Empty');

          return ListView.builder(
            itemCount: snapshot.data?.items.length,
            itemBuilder: (context, index) {
              final item = snapshot.data?.items[index];

              return FutureBuilder(
                key: ObjectKey(item),
                future: item?.getMetadata(),
                builder: (context, feedbackSnap) {
                  return ListTile(
                    title: Text(feedbackSnap.data?.customMetadata?['feedback'] ?? '-'),
                    subtitle: Text(item?.name ?? '-'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await item?.delete();
                        setState(() {});
                      },
                    ),
                    onTap: () {
                      context.cPush(
                        FutureBuilder(
                          future: item?.getDownloadURL(),
                          builder: (context, imgSnap) {
                            return Scaffold(
                              appBar: AppBar(
                                title: Text(feedbackSnap.data?.customMetadata?['feedback'] ?? '-'),
                                actions: [Text(item?.name ?? '-')],
                              ),
                              body: (imgSnap.data == null)
                                  ? const Placeholder()
                                  : PhotoView(imageProvider: Image.network(imgSnap.data ?? '').image),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
