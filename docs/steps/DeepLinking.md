# [Deep Linking](https://docs.flutter.dev/ui/navigation/deep-linking)

[![Deep linking in Flutter](https://i.ytimg.com/vi_webp/KNAb2XL7k2g/sddefault.webp)](https://www.youtube.com/watch?v=KNAb2XL7k2g)

[![Deep linking in Flutter](https://i.ytimg.com/vi_webp/6RxuDcs6jVw/sddefault.webp)](https://www.youtube.com/watch?v=6RxuDcs6jVw)

* [Set up app links for Android](https://docs.flutter.dev/cookbook/navigation/set-up-app-links)

* [Set up universal links for iOS](https://docs.flutter.dev/cookbook/navigation/set-up-universal-links)

* [Handling Android App Links](https://developer.android.com/training/app-links)

* [Intents and intent filters](https://developer.android.com/guide/components/intents-filters)

* [Create Deep Links to App Content](https://developer.android.com/training/app-links/deep-linking)

* [Verify Android App Links](https://developer.android.com/training/app-links/verify-android-applinks)

```android
> AndroidManifest

<meta-data android:name="flutter_deeplinking_enabled" android:value="true" />
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="http" android:host="spacemoon.shark.run" />
    <data android:scheme="https" />
</intent-filter>

<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="spacemoon" android:host="" />
</intent-filter>

---
adb shell am start -W -a android.intent.action.VIEW -d "spacemoon:///chat/id" run.shark.spacemoon

adb shell am start -a android.intent.action.VIEW \
    -c android.intent.category.BROWSABLE \
    -d "http://domain.name:optional_port"

adb shell 'am start -a android.intent.action.VIEW \
    -c android.intent.category.BROWSABLE \
    -d "http://spacemoon.shark.run/chat/id"'     run.shark.spacemoon

spacemoon:///chat/id/
```

```ios
> Info.plist

  <dict>
   <key>CFBundleTypeRole</key>
   <string>Viewer</string>
   <key>CFBundleURLName</key>
   <string></string>
   <key>CFBundleURLSchemes</key>
   <array>
    <string>spacemoon</string>
   </array>
  </dict>

  <key>FlutterDeepLinkingEnabled</key>
  <true/>


> Runner.entitlements

 <array>
  <string>applinks:spacemoon.shark.run</string>
 </array>

---
xcrun simctl openurl booted spacemoon:///chat

spacemoon:///chat/id/

xcrun simctl openurl booted https:spacemoon.shark.run/chat/id
```

* [Defining a custom URL scheme for your app](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app)

* [Digital Asset Links VALIDATOR](https://developers.google.com/digital-asset-links/tools/generator)
* [APPLE APP SITE ASSOCIATION (AASA) VALIDATOR](https://branch.io/resources/aasa-validator/)
