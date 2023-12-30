<p align="center">
  <img src="./assets/images/SpaceMoon.svg" border-radius:300px;" />
</p>
<h1 align="center">SpaceMoon</h1>

# Connecting Universes

[<img src="docs/images/googleplay.webp" width='168' height='50'>](https://play.google.com/store/apps/details?id=run.shark.spacemoon)
[<img src="docs/images/appstore.png" width='168' height='50'>](https://apps.apple.com/us/app/spacemoon/id6469975482)
[<img src="./assets/images/SpaceMoon.svg" width='70' height='70'>](https://spacemoon.shark.run)

[Figma File](https://www.figma.com/file/f9r4LYaKrL5d97A1bEi1Lt/Spacemoon?type=design&node-id=0%3A1&mode=design&t=Ji6lHXDfgJnUdlG3-1)

[![iPhone](docs/images/iPhone15max.png)](https://www.figma.com/file/f9r4LYaKrL5d97A1bEi1Lt/Spacemoon?type=design&node-id=0%3A1&mode=design&t=Ji6lHXDfgJnUdlG3-1)

## How to build

```dart
flutterfire configure
dart run build_runner watch --delete-conflicting-outputs
flutter pub upgrade

Generate Flutter l10n
  flutter gen-l10n

For local emulator cloud function, configure appcheck debug token in Firebase console.
For android local emulator, change computerIp in firebase.dart to your computer ip address.
Enable useEmulator in main.dart

Enable debugMode in main.dart for appcheck token

To disable cloud function region comment out (  region: 'asia-south1'  ) in all cloud functions.

To disable appcheck enforcemnt comment out (enforceAppCheck: true) in all cloud functions.

Running Cloud function Emulator:
  firebase emulators:start

Building Cloud Functions
  cd functions
  npm run build:watch

Generating Proto files
  cd proto
  npx buf generate lib
```

## Documentation

- [x] [Cli Cheat Sheet](./docs/steps/CliCheatSheet.md)

- [x] [Creating Project and Configuring Firebase](./docs/steps/Create.md)

- [x] [Creating Apple Certificates, Identifiers & Profiles](./docs/steps/AppleAppStore.md)
- [x] [Playstore](./docs/steps/GooglePlayStore.md)

- [x] [Protocol Buffers](./docs/steps/ProtocolBuffer.md)
- [x] [Firebase Auth : Email, Google, Apple](./docs/steps/Auth.md)
- [x] [Firebase App Check](./docs/steps/AppCheck.md)
- [x] [Deep linking](./docs/steps/DeepLinking.md)
- [x] [Firebase Messaging](./docs/steps/FirebaseMessaging.md)
- [x] [Firebase Cloud Firestore](./docs/steps/CloudFirestore.md)
- [x] [Splash Screen Icons](./docs/steps/SplashScreenIcons.md)
- [x] [Security Rules](./docs/steps/SecurityRules.md)
- [x] [App Security](./docs/steps/AppSecurity.md)
- [x] [Permissions](./docs/steps/Permissions.md)
- [x] [Firebase Crashlytics](https://firebase.google.com/docs/crashlytics)
- [x] [Riverpod StateManagement](./docs/steps/StateManagement.md)
- [x] [Gorouter](https://pub.dev/packages/go_router)
- [x] [DevTools](./docs/steps/DevTools.md)

- [x] [Jetpack Compose](./docs/steps/JetpackCompose.md)
- [x] [Google Cloud Fuctions Go](./docs/steps/GoogleCloudFuctionsGo.md)

- [x] [Flutter architectural overview](https://docs.flutter.dev/resources/architectural-overview)
- [x] [Inside Flutter](https://docs.flutter.dev/resources/inside-flutter)
- [x] [Understanding constraints](https://docs.flutter.dev/ui/layout/constraints)

## [Schema](proto/lib/data.proto)

![Spacemoon](./spacemoon.drawio.svg)

## Cloud Functions

### Auth User

- [x] Create User : [onUserCreate](functions/src/users.ts#10)
- [x] Update User : [callUserUpdate](functions/src/users.ts#L35)
- [x] Delete User : [deleteAuthUser](functions/src/users.ts#L67)

### Chat Room

- [x] Create Chat Room : [callCreateRoom](functions/src/room.ts#L12)
- [x] Update Room Info : [updateRoomInfo](functions/src/room.ts#L130)
- [x] Delete Room : [deleteRoom](functions/src/room.ts#L81)

### Chat Room User

- [x] Upgrade Access To Room : [upgradeAccessToRoom](functions/src/roomuser.ts#L95)
- [x] Update RoomUser Time : [updateRoomUserTime](functions/src/roomuser.ts#L43)
- [x] Delete RoomUser : [deleteRoomUser](functions/src/roomuser.ts#L85)

### Tweet

- [x] Send Tweet : [sendTweet](functions/src/tweet.ts#L10)
- [x] Update Tweet : [updateTweet](functions/src/tweet.ts#L53)
- [x] Delete Tweet : [sendTweet](functions/src/tweet.ts#L96)

### Messaging

- [x] Tweet to Topic : [tweetToTopic](functions/src/messaging.ts#L108)
- [x] Save FCM Token : [callFCMtokenUpdate](functions/src/messaging.ts#L183)
- [x] Subscribe to Topic : [callSubscribeFromTopic](functions/src/messaging.ts#L54)
- [x] Unsubscribe to Topic : [callUnsubscribeFromTopic](functions/src/messaging.ts#L42)
- [x] Toggle Topic Subsription : [toggleTopicSubsription](functions/src/messaging.ts#L66)
- [x] Update FCM Token : [callFCMtokenUpdate](functions/src/messaging.ts#L183)
- [x] Delete FCM Token : [deleteFCMToken](functions/src/messaging.ts#L177 )
- [x] Schedule Prune Tokens : [pruneTokens](functions/src/messaging.ts#L211)

### Image Resize

- [x] Generate Thumbnail : [pruneTokens](functions/src/image.ts#L11)
