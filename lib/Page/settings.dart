import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemoon/Providers/global_theme.dart';
import 'package:spacemoon/Providers/router.dart';

part 'settings.g.dart';

class Settings {
  static final routes = $appRoutes;
}

@TypedGoRoute<SettingsRoute>(path: AppRouter.settings)
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
    ThemeType theme = ref.watch(globalThemeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          CupertinoFormSection.insetGrouped(
            header: Text('Theme'),
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
                  ref.read(globalThemeProvider.notifier).set(v);
                },
                position: PopupMenuPosition.under,
                offset: const Offset(1, -120),
                child: ListTile(
                  visualDensity: VisualDensity.compact,
                  title: const Text('Theme'),
                  subtitle: Text(theme.name),
                  trailing: theme.icon,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
