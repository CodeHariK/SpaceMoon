import 'package:spacemoon/Init/firebase.dart';
import 'package:spacemoon/Init/url_strategy.dart';

Future<void> init() async {
  urlStrategy();
  await initFirebase();
}
