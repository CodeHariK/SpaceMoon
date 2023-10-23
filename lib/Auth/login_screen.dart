import 'package:flutter/material.dart';
import 'package:spacemoon/Constants/assets.dart';

import 'dart:convert';

import 'package:spacemoon/Constants/theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.c),
                        child: Text(
                          'Spacemoon',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                      Image.asset(
                        Asset.spaceMoon,
                        width: 200.c,
                        height: 200.c,
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
        width: 320.c,
        padding: EdgeInsets.all(6.c),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //
            FilledButton(
              onPressed: () {},
              child: const Text('Change Theme'),
            ),

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
                decoration: const InputDecoration(
                  label: Text('Password'),
                  border: OutlineInputBorder(),
                ),
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
                    backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                    foregroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.apple,
                        size: 30.c,
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
                      const GoogleLogo(),
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
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [
                    WidgetSpan(
                      child: InkWell(
                        // onTap: () => setState(() => type = type == signIn ? signUp : signIn),
                        child: Text(
                          "Terms",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    ),
                    const TextSpan(text: ', '),
                    WidgetSpan(
                      child: InkWell(
                        // onTap: () => setState(() => type = type == signIn ? signUp : signIn),
                        child: Text(
                          "Privacy Policy",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                decoration: TextDecoration.underline,
                              ),
                        ),
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
                //TODO : Password Reset Screen
                // onTap: () => ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgotten your password?",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                    ),
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
                style: Theme.of(context).textTheme.titleSmall,
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: InkWell(
                      onTap: () => setState(() => type = type == signIn ? signUp : signIn),
                      child: Text(
                        (type == signIn) ? "Sign up  " : "Log in  ",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                      ),
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

@immutable
class AnimatedYHide extends StatelessWidget {
  const AnimatedYHide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    required this.show,
  });

  final Widget child;
  final Duration duration;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: child,
      secondChild: const SizedBox(width: double.infinity),
      crossFadeState: show ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: duration,
    );
  }
}

class AnimatedText extends StatelessWidget {
  const AnimatedText({
    super.key,
    required this.text1,
    required this.text2,
    this.duration = const Duration(milliseconds: 300),
    required this.show,
    this.style,
  });

  final String text1, text2;
  final Duration duration;
  final bool show;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Text(text1, style: style),
      secondChild: Text(text2, style: style),
      crossFadeState: show ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: duration,
    );
  }
}

class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key});

  static const String google =
      "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAAAXNSR0IArs4c6QAABP5JREFUaEPtmF1sFFUUx//nzm7ZhdZ2CwW61SgKUaAkkLKtSRUr1GD9gFqsH4m0Dyom2vIiiQ8m7SAxGh8JvqEQhMYWa8UPKNJ2Fwk2KRUCETHEpH4ANS0t5aNLt925xwyw2HQ77czsNIRk93XO+f/P75x779xZwl3+o7u8fiQB7vQEkxNITiDBDiSXUIINTDjd8Qn8U5y3REilgIlzQZRJUpsGEr1g7iUSJ91D7taso0evJlz5LQFHALqKlma4Xe4qkrICJBZMVBwBIyxxGII/yWntPJQoSEIADFD3qsBGZq7Ru221GGYcVRhvZQePnbaaG4u3DdBdsixLDrnqIFBs11zPY8agELTB39JRZ0fHFsDfTy3zC01pIaKFdkzH5hDR/mzf/Wto717Nqp5lgN7CwrRhT6QdoMVWzcaNl9wc9gyULjjwR8SOnmWAC8WBBmaUG5kxI0wC9ZB8iFg5C3d0EBKzWIpHiVDOQP6o3IPD2ozSeaHQkJ3i9RxLAOdW5T9H4O+MzAi8Cxq/6w/9ctEoRtcA5HYmnIxGU9cmUrwlAFYhes7kNkYvekvHFscAE/PGnLbObWY6+efqvGzlSsrAfe3t183ET3Ism5MYPKCsIdC+cJu/ffj4nOUMuG9nEm3OaelQzSk5G2V6CYUPuBsAvrH2o11pp640zp9LwGwGjudkPpBv5wRxAsUUADdAGUp19TEhPWbKg66eyzsWnsOQe4u/teMbJ4qxo2EKIHIw5RFNyjNxBhr1eTsL55IaihqZr9x8qZqYc60WJ6BtPqRmXZgszxTA4H7leSL6Nu4FBDR7S6IlE5msVAd+APiZyQqJ0xa8orUm88hkeaYArjcr65lpVzwAb/eWaG9OBQATvRiszWicUgAGfzajRHtjSgCA14Oq73NHAO7IEiJ6pbU2o94RAMNNzOirvPbCnL0vGV/C7O4BFigK1vgOOwKgH6PhNFc/AffEBCVTT83VwF8/Dfk/7Kz8ap+RUZHakxqdlvL/S29U4IwI0Qi03wHKGps/4o76j7yf1e0IgC4y+kV2TbpPVg4Uze6V07PBOD7PI/InmoLhEateWgEgrssM7gqqmQ9OVrz+3NQppAfG9sHpaPrP1ZcfD0RZud1VItQee63xAzOGsZjyBlYu/jYQIuCxsXkS2BZSfdVm9EwD6Je5jxYtbfw68lDcZQ4MBlDdWdH4qRlT/e5XpA5sFUDV+PGioE1N7zCjZRpAF8v7ouxZAn1vJMyEnYomN3VUNvUZxRTsLrtX9K99z9u/ZtziJTgYUjNXmine0hKKCS7fte5LEF42NuBBZqoToGaGdpYUCkuJDGIsJtDTkriMQB7l+vygp3tTocKulJgWgzVFUKClxndiygAWNZSneiOynQDL95uxRZHm+XX6edWnjMzK0Z8xoSZY69titnhbE9CTAjvK57IifwRhiRWz8WKZ0e/9d8N5dzj/1BPIqFBVklY0Le2B0cJ5da/OEnJ4NzNWWzGMj2UJ6fo4tau+NqSS4a3WyMM2wA1BBuXtKasCUy0BM62C6Oe9AL99bH1Ts9XcWHxiALdU8hrK0ynC7zBrFUTi4QmLuXnknmCBrWk5fXtCTxp/S5iBcgRgtFFg57rF7EIBWN/kPJMle0i5+ecuQGeHWbaeqmjqMVOcmRjHAcyYOhmTBHCym3a0khOw0zUnc5ITcLKbdrSSE7DTNSdz/gMy7d9ATzNDsgAAAABJRU5ErkJggg==";

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      base64Decode(google),
      semanticLabel: 'Google Login',
      width: 35.c,
      height: 35.c,
    );
  }
}
