import 'package:spacemoon/Auth/login_screen.dart';
import 'package:spacemoon/Init/firebase.dart';
import 'package:spacemoon/MoonSpace/moonspace.dart';

void main() {
  moonspace(
    title: 'Spacemoon',
    home: const LoginScreen(),
    init: initFirebase,
  );
}
