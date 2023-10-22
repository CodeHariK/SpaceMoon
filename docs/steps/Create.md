# Creating Project and Configuring Firebase

```bash
flutter create --org run.shark spacemoon
flutterfire configure --project=spacemoonfire
```

## Add to .gitignore

* firebase_options.dart
* google-services.json
* firebase_app_id_file.json
* GoogleService-Info.plist

## Add Firebase Core

```bash
flutter pub add firebase_core, google_fonts, flutter_screenutil
```

## Upgrade Project Defaults For IOS

### Upgrade Podfile Version : `ios/podfile`

```code
platform :ios, '15.0'
```

### Replace all : `ios/Runner.xcodeproj/project.pbxproj`

```code
IPHONEOS_DEPLOYMENT_TARGET = 15.0;
compatibilityVersion = "Xcode 15.0";
```

### Upgrage MinimumOsVerison : `ios/Flutter/AppFrameworkInfo.plist`

```code
<key>MinimumOSVersion</key>
<string>15.0</string>
```

### Change App Name : `ios/Runner/Info.plist`

```code
<key>CFBundleDisplayName</key>
<string>Spacemoon</string>
```

### Open Xcode > TARGETS Runner > General : Change Display Name to `Spacemoon` and add App Category

## Upgrade Project Defaults For Android

### Change App Name and ask Internet Permisson : `android/app/src/main/AndroidManifest.xml`

```code
android:label="Spacemoon"

<uses-permission android:name="android.permission.INTERNET" />
```

### Upgrade MinSdkVersion : `android/app/build.gradle`

```code
minSdkVersion 27
```

### Upgrade Kotlin Version and Gradle Plugin Version : `android/build.gradle`

```code
ext.kotlin_version = '1.9.10'

classpath 'com.android.tools.build:gradle:8.1.2'
classpath 'com.google.gms:google-services:4.4.0'
```

[Latest Kotlin Version](https://kotlinlang.org/docs/releases.html#release-details)

[Latest Gradle plugin](https://developer.android.com/reference/tools/gradle-api)

### Upgrade Gradle Distribution Url : `android/gradle/wrapper/gradle-wrapper.properties`

```code
distributionUrl=https\://services.gradle.org/distributions/gradle-8.4-all.zip
```

[Latest Gradle Distribution Url](https://docs.gradle.org/current/userguide/gradle_wrapper.html)
