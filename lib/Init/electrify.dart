import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:spacemoon/Routes/Special/error_page.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Providers/global_theme.dart';
import 'package:spacemoon/Providers/pref.dart';
import 'package:spacemoon/Providers/router.dart';

void electrify({
  required String title,
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  final List<Locale>? supportedLocales,
  required AsyncCallback init,
}) async {
  runZonedGuarded(
    () async {
      // debugPaintSizeEnabled = true;
      // debugPaintLayerBordersEnabled = true;
      // debugRepaintRainbowEnabled = true;
      // debugPaintBaselinesEnabled = true;
      // debugPaintPointersEnabled = true;
      // debugPrintMarkNeedsLayoutStacks = true;
      // debugPrintMarkNeedsPaintStacks = true;

      //
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations([
        // DeviceOrientation.landscapeLeft,
        // DeviceOrientation.landscapeRight,
        // DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);

      // ErrorWidget.builder = (FlutterErrorDetails details) {
      //   if (kDebugMode) {
      //     return ErrorPage(error: details);
      //   }
      //   return const SizedBox();
      // };

      // This captures errors reported by the Flutter framework.
      FlutterError.onError = (FlutterErrorDetails details) async {
        final dynamic exception = details.exception;
        final StackTrace? stackTrace = details.stack;

        if (kDebugMode) {
          FlutterError.presentError(details);
          debugPrint(exception.toString());
          debugPrintStack(stackTrace: stackTrace);
        } else {
          FirebaseCrashlytics.instance.recordFlutterFatalError(details);

          Zone.current.handleUncaughtError(exception, stackTrace!);
        }
      };

      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        if (kDebugMode) {
          debugPrint(error.toString());
          debugPrintStack(stackTrace: stack);
        } else {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        }
        return true;
      };

      //-----

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
            localizationsDelegates: localizationsDelegates,
            supportedLocales: supportedLocales,
          ),
        ),
      );

      FlutterNativeSplash.remove();
    },
    (error, stack) {
      if (kDebugMode) {
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stack);
      } else {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
    },
  );
}

class SpaceMoonHome extends HookConsumerWidget {
  const SpaceMoonHome({
    super.key,
    required this.title,
    this.localizationsDelegates,
    this.supportedLocales,
  });

  final String title;

  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final List<Locale>? supportedLocales;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnAppLifecycleStateChange((previous, current) {
      lava('$previous -> $current');
    });

    dino('SpaceMoon Rebuild ${MediaQuery.of(context).size} \n');
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

    final globalAppTheme = ref.watch(globalThemeProvider);
    final brightness = globalAppTheme.theme.brightness;
    final appColor = globalAppTheme.color;

    AppTheme.currentAppTheme = AppTheme(
      dark: brightness == Brightness.dark,
      designSize: const Size(360, 780),
      maxSize: const Size(1366, 1024),
      size: MediaQuery.of(context).size,
      appColor: appColor,
    );

    return RootRestorationScope(
      restorationId: AppRouter.spacemoonRestorationScopeId,
      child: MaterialApp.router(
        routerConfig: router,
        title: title,
        scaffoldMessengerKey: AppRouter.scaffoldMessengerKey,
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          ...?localizationsDelegates,
        ],
        theme: AppTheme.currentAppTheme.theme,
        themeAnimationCurve: Curves.ease,
        debugShowCheckedModeBanner: kDebugMode,
        restorationScopeId: AppRouter.appRestorationScopeId,

        // showSemanticsDebugger: true,
        // showPerformanceOverlay: true,

        supportedLocales: AppLocalizations.supportedLocales,

        builder: (context, child) {
          initializeDateFormatting();

          return Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (context) {
                      return CupertinoTheme(
                        key: AppRouter.cupertinoNavigatorKey,
                        data: CupertinoThemeData(
                          brightness: brightness,
                          primaryColor: AppTheme.seedColor,
                        ),
                        child: child ?? const SimpleError(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
