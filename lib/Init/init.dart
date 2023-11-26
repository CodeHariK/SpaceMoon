import 'package:spacemoon/Init/firebase.dart';
import 'package:spacemoon/Init/url_strategy.dart';

Future<void> init() async {
  urlStrategy();
  await initFirebase(useEmulator: false);
}

Future<void> emulatorInit() async {
  urlStrategy();
  await initFirebase(useEmulator: true);
}
