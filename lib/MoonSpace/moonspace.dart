import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:spacemoon/Constants/theme.dart';

void moonspace({
  required String title,
  required Widget home,
  required AsyncCallback init,
}) async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // debugPaintSizeEnabled = true;

  runApp(const Center(child: CircularProgressIndicator()));

  await init();

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
    debugPrint('SpaceMoon Rebuild \n');
    return AppThemeWidget(
      dark: false,
      designSize: const Size(360, 780),
      maxSize: const Size(1000, 1000),
      size: MediaQuery.of(context).size,
      child: Builder(builder: (context) {
        return MaterialApp(
          title: title,
          theme: AppTheme.currentAppTheme.theme,
          home: home,
          debugShowCheckedModeBanner: kDebugMode,
        );
      }),
    );
  }
}
