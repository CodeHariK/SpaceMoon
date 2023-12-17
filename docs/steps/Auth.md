# [Get Started with Firebase Authentication on Flutter](https://firebase.google.com/docs/auth/flutter/start)

```code
flutter pub add firebase_ui_auth
flutter pub add firebase_ui_oauth_apple
flutter pub add firebase_ui_oauth_google
flutter pub add firebase_ui_auth
```

## [google_sign_in](https://pub.dev/packages/google_sign_in)

### [Android intergration](https://pub.dev/packages/google_sign_in#android-integration)

### [iOS intergration](https://pub.dev/packages/google_sign_in#ios-integration)

```dart
import 'package:google_sign_in/google_sign_in.dart';
Initialize GoogleSignIn with the scopes you want:

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
```

## [Firebase Ui Auth](https://pub.dev/packages/firebase_ui_auth)
