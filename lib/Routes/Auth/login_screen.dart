import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacemoon/Static/Widget/google_logo.dart';
import 'package:spacemoon/Static/assets.dart';

import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Helpers/extensions.dart';
import 'package:spacemoon/Widget/Animated/animated_text.dart';
import 'package:spacemoon/Widget/Animated/animated_y_hide.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.c),
                        child: Text('Spacemoon', style: context.hl),
                      ),
                      Image.asset(
                        Asset.spaceMoon,
                        width: 160.c,
                        height: 160.c,
                      ),
                    ],
                  ),
                  const SignIn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

typedef AuthType = bool;
AuthType signIn = true;
AuthType signUp = false;

@immutable
class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthType type = signIn;
  late final TextEditingController emailCon;
  late final TextEditingController passwordCon;
  bool obscure = true;
  final Duration duration = const Duration(milliseconds: 300);

  @override
  void initState() {
    emailCon = TextEditingController();
    passwordCon = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailCon.dispose();
    passwordCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: (360, 420).c,
        padding: EdgeInsets.all(8.c),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //
            Padding(
              padding: EdgeInsets.all(8.c),
              child: TextFormField(
                controller: emailCon,
                decoration: const InputDecoration(
                  label: Text('Mobile number or email address'),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {},
              ),
            ),

            AnimatedYHide(
              show: type != signIn,
              child: Padding(
                padding: EdgeInsets.all(8.c),
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Full Name'),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(8.c),
              child: TextFormField(
                decoration: InputDecoration(
                  label: const Text('Password'),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () => setState(() => obscure = !obscure),
                  ),
                ),
                obscureText: obscure,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(8.c),
              child: FilledButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedText(
                      text1: "Log in",
                      text2: "Sign up",
                      show: type == signIn,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10.c),
              child: const Divider(),
            ),

            AnimatedYHide(
              show: type == signIn,
              child: Padding(
                padding: EdgeInsets.all(8.c),
                child: FilledButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: context.b == Brightness.light ? Colors.black : Colors.white,
                    foregroundColor: context.b == Brightness.light ? Colors.white : Colors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.apple,
                        size: 27.c,
                      ),
                      SizedBox(width: 5.c),
                      const Text('Sign in with Apple'),
                    ],
                  ),
                ),
              ),
            ),

            AnimatedYHide(
              show: type == signIn,
              child: Padding(
                padding: EdgeInsets.all(8.c),
                child: FilledButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 238, 238, 238),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GoogleLogo(width: 30.c),
                      SizedBox(width: 10.c),
                      const Text('Continue with Google'),
                    ],
                  ),
                ),
              ),
            ),

            AnimatedYHide(
              show: type == signUp,
              child: RichText(
                text: TextSpan(
                  text: "By signing up, you agree to our ",
                  style: context.ts,
                  children: [
                    WidgetSpan(
                      child: InkWell(
                        // onTap: () => setState(() => type = type == signIn ? signUp : signIn),
                        child: Text("Terms", style: context.tm.under),
                      ),
                    ),
                    const TextSpan(text: ', '),
                    WidgetSpan(
                      child: InkWell(
                        // onTap: () => setState(() => type = type == signIn ? signUp : signIn),
                        child: Text("Privacy Policy", style: context.tm.under),
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),

            //
            SizedBox(height: 10.c),

            AnimatedYHide(
              show: type == signIn,
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Forgotten your password?", style: context.tm.under),
                  ],
                ),
              ),
            ),
            //
            SizedBox(height: 10.c),

            //
            RichText(
              text: TextSpan(
                text: (type == signIn) ? "Don't have an account?  " : "Have an account? ",
                style: context.ts,
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: InkWell(
                      onTap: () => setState(() => type = type == signIn ? signUp : signIn),
                      child: Text((type == signIn) ? "Sign up  " : "Log in  ", style: context.tm.under),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
