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
      appBar: AppBar(),
      body: Column(
        children: [
          DropdownButton<ThemeType>(
            hint: Text(ThemeType.values.where((t) => t == theme).first.name.toUpperCase()),
            items: ThemeType.values
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.name.toUpperCase()),
                  ),
                )
                .toList(),
            onChanged: (ThemeType? v) {
              if (v != null) {
                ref.read(globalThemeProvider.notifier).set(v);
              }
            },
          ),
        ],
      ),
    );
  }
}
