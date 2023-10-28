import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Providers/global_theme.dart';
import 'package:spacemoon/Providers/pref.dart';
import 'package:spacemoon/Providers/router.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

void moonspace({
  required String title,
  required AsyncCallback init,
}) async {
  // debugPaintSizeEnabled = true;

  //
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // ignore: missing_provider_scope
  // runApp(const SplashPage());

  final container = ProviderContainer();

  container.listen(prefProvider, (prev, next) {});

  await init();

  container.listen(routerRedirectorProvider, (prev, next) {});

  await Future.delayed(const Duration(milliseconds: 100));

  runApp(
    ProviderScope(
      parent: container,
      child: SpaceMoonHome(
        title: title,
      ),
    ),
  );
}

class SpaceMoonHome extends ConsumerWidget {
  const SpaceMoonHome({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('SpaceMoon Rebuild ${MediaQuery.of(context).size} \n');
    // return AppThemeWidget(
    //   dark: false,
    //   designSize: const Size(430, 932),
    //   maxSize: const Size(1366, 1024),
    //   size: MediaQuery.of(context).size,
    //   child: Builder(builder: (context) {
    //     return MaterialApp(
    //       title: title,
    //       theme: AppTheme.currentAppTheme.theme,
    //       debugShowCheckedModeBanner: kDebugMode,
    //     );
    //   }),
    // );

    final brightness = ref.watch(globalThemeProvider).brightness;

    AppTheme.currentAppTheme = AppTheme(
      dark: brightness == Brightness.dark,
      designSize: const Size(360, 780),
      maxSize: const Size(1366, 1024),
      size: MediaQuery.of(context).size,
    );

    return Builder(builder: (context) {
      return MaterialApp.router(
        routerConfig: router,
        title: title,
        locale: const Locale('en'),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FirebaseUILocalizations.delegate,
        ],
        theme: AppTheme.currentAppTheme.theme,
        debugShowCheckedModeBanner: kDebugMode,
      );
    });
  }
}
