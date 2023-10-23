# App Check : Protect your APIs

[App Check](https://firebase.google.com/products/app-check)

App Check is an additional layer of security that helps protect access to your services by attesting that incoming traffic is coming from your app, and blocking traffic that doesn't have valid credentials. It helps protect your backend from abuse, such as billing fraud, phishing, app impersonation, and data poisoning.

[![App Check](https://i.ytimg.com/vi_webp/LFz8qdF7xg4/sddefault.webp)](https://www.youtube.com/watch?v=LFz8qdF7xg4)
[![App Check](https://i.ytimg.com/vi_webp/TzLON3oVGE0/sddefault.webp)](https://www.youtube.com/watch?v=TzLON3oVGE0)
[![App Check](https://i.ytimg.com/vi_webp/iYA0QYP9ocw/sddefault.webp)](https://www.youtube.com/watch?v=iYA0QYP9ocw)
[![App Check](https://i.ytimg.com/vi_webp/Fjj4fmr2t04/sddefault.webp)](https://www.youtube.com/watch?v=Fjj4fmr2t04)
[![App Check](https://i.ytimg.com/vi_webp/DEV372Kof0g/sddefault.webp)](https://www.youtube.com/watch?v=DEV372Kof0g)

```code
### Enable AppCheck in Firebase Console

### For android : Generate SHA-256 certificate fingerprint
cd android
./gradlew signingReport

### For Apple : Get your team id from Apple Developer account
```

## Flutter

[Flutter App Check](https://firebase.google.com/docs/app-check/flutter/default-providers)

```dart
flutter pub add firebase_app_check
```

```dart
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
        webProvider: ReCaptchaEnterpriseProvider('recaptcha-v3-site-key'),
        // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Safety Net provider
        // 3. Play Integrity provider
        androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
        // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
        // your preferred provider. Choose from:
        // 1. Debug provider
        // 2. Device Check provider
        // 3. App Attest provider
        // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
        appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
    );
}
```

## [Enable App Check enforcement](https://firebase.google.com/docs/app-check/enable-enforcement)

## [Enable App Check enforcement for Cloud Functions](https://firebase.google.com/docs/app-check/cloud-functions#node.js-2nd-gen)

```ts
const { onCall } = require("firebase-functions/v2/https");

exports.yourV2CallableFunction = onCall(
    {
        enforceAppCheck: true, // Reject requests with missing or invalid App Check tokens.

        // Replay protection Note that using replay protection adds a network round trip to token verification, and therefore adds latency to the cloud function call. For this reason, most apps typically enable replay protection only on particularly sensitive endpoints.
        consumeAppCheckToken: true  // Consume the token after verification. 
    },
    (request) => {
        // request.app contains data from App Check, including the app ID.
        // Your function logic follows.
    }
);
```

```dart
FirebaseFunctions.httpsCallable('yourCallableFunction', HttpsCallableOptions(limitedUseAppCheckToken = false));
```

## [Use App Check with the debug provider with Flutter](https://firebase.google.com/docs/app-check/flutter/debug-provider)

After you have registered your app for App Check, your app normally won't run in an emulator or from a continuous integration (CI) environment, since those environments don't qualify as valid devices. If you want to run your app in such an environment during development and testing, you can create a debug build of your app that uses the App Check debug provider instead of a real attestation provider.

Your app will print a local debug token to the debug output when Firebase tries to send a request to the backend. For example:

```console
Firebase App Check Debug Token:
123a4567-b89c-12d3-e456-789012345678
```

In the App Check section of the Firebase console, choose Manage debug tokens from your app's overflow menu. Then, register the debug token you logged in the previous step.

After you register the token, Firebase backend services will accept it as valid.

Because this token allows access to your Firebase resources without a valid device, it is crucial that you keep it private. Don't commit it to a public repository, and if a registered token is ever compromised, revoke it immediately in the Firebase console.

![Debug Token](https://firebase.google.com/static/docs/app-check/manage-debug-tokens.png)

## [Monitor App Check request metrics](https://firebase.google.com/docs/app-check/monitor-metrics)

![Metrics](https://firebase.google.com/static/docs/app-check/app-check-metrics.png)
