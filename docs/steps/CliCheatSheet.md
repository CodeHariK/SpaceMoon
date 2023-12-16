# Cli

## [Flutter](https://docs.flutter.dev/reference/flutter-cli)

```code
### To create a flutter project
flutter create --org ext.domain app_name

### Add a dependency to pubspec.yaml.
flutter pub add <dependency>

### Run and build a Flutter Project
flutter run
flutter build

### Run Build Runner
dart run build_runner watch --delete-conflicting-outputs

### Generate localizations for the Flutter project
flutter gen-l10n <DIRECTORY>

### Delete the build/ and .dart_tool/ directories
flutter clean

### Devices and Screenshot
flutter devices
flutter screenshot

### Doctor and Upgrade
flutter doctor
flutter upgrade

### Upgrade
flutter pub get
flutter pub outdated
flutter pub upgrade
```

## IOS

### If ios build is not working

```code
cd ios
pod cache clean --all
flutter clean && rm ios/Podfile.lock pubspec.lock && rm -rf ios/Pods ios/Runner.xcworkspace
pod deintegrate
pod setup
pod install --verbose
pod repo update
pod -–version
pod update

### Update Brew
brew update
brew upgrade

### Install CocoaPods
brew install cocoapods
```

## Android

### [App Signing](https://developers.google.com/android/guides/client-auth)

```code
cd android

### Gradle version
./gradlew -v

### Gradle's Signing Report
./gradlew signingReport

```

## [Firebase](https://firebase.google.com/docs/cli)

```code

### Install
npm install -g firebase-tools

### Login
firebase login

### Initialize a Firebase project
firebase init

### Project List
firebase projects:list

### Deploy to a Firebase project
firebase deploy
firebase deploy -m "Deploying the best new feature ever."
firebase deploy --only hosting,storage

### Deploy specific functions
firebase deploy --only functions:function1,functions:function2
firebase deploy --only functions:groupA
firebase deploy --only functions:groupA.function1,groupB.function4

### Delete functions
firebase functions:delete FUNCTION-1_NAME
```

## [Android CMD Tools](https://developer.android.com/tools/adb)

```code

adb kill-server

adb start-server

adb devices

# Connect wirelessly with a device after an initial USB connection
adb tcpip 5555 && adb connect device_ip_address:5555

adb shell pm uninstall com.example.MyApp

adb shell pm verify-app-links --re-verify PACKAGE_NAME

adb shell pm get-app-links PACKAGE_NAME

adb shell am start -W -a android.intent.action.VIEW -d "spacemoon:///chat/jFFarHOjNQzwaDXyS2OS" run.shark.spacemoon

adb shell am start -a android.intent.action.VIEW \
    -c android.intent.category.BROWSABLE \
    -d "http://domain.name:optional_port"

```

## Ios CMD

```code

xcrun simctl list devices

xcrun simctl delete unavailable

xcrun simctl openurl booted spacemoon:///chat

```

## FlutterFire

```code
dart pub global activate flutterfire_cli

flutterfire configure
```
