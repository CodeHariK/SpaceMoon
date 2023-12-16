import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension Superl10next on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
  List<Locale> get sloc => AppLocalizations.supportedLocales;
}
