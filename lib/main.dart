import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/foundation.dart';
import 'package:spacemoon/Init/init.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:spacemoon/Init/electrify.dart';

class SpaceMoon {
  static String title = 'Spacemoon';
}

void main() {
  electrify(
    title: SpaceMoon.title,
    init: kDebugMode ? emulatorInit : init,
    localizationsDelegates: [
      FirebaseUILocalizations.delegate,
      AppFlowyEditorLocalizations.delegate,
    ],
  );
}


// ## Google Play Store Team

//     To add a member to your Google Play Store team, you need to follow these steps:

//     Go to the Google Play Console website and sign in with your account credentials.
//     Click on "Settings" in the left-hand menu.
//     Click on "User accounts & rights" under the "Developer account" section.
//     Click on the "Invite new user" button.
//     Enter the email address of the person you want to add as a team member.
//     Choose the access level you want to give the team member, such as admin or release manager.
//     Click the "Invite" button to send the invitation.
//     The team member will receive an email invitation to join the team, and they will need to accept it to be added to the team. Once they accept the invitation, they will be able to access and manage the Google Play Console for your app.

// ## Ios Team

//     To create an Apple Teams ID, you can follow these steps:

//     Go to the Apple Business Manager website (https://business.apple.com/) and sign in with your Apple ID.

//     Click on "Settings" in the sidebar and then select "Teams" from the dropdown menu.

//     Click on the "Create Team" button in the top-right corner of the page.

//     Enter a name for your team and select a role for yourself (either "Admin" or "Member").

//     If you want to add additional members to your team, click on the "Add Members" button and enter their email addresses. You can also assign roles to these members.

//     Once you have entered all the necessary information, click on the "Create Team" button.

//     You will be taken to a page where you can view your team's information and manage its settings.

//     Note that you will need to have an Apple Business Manager account in order to create an Apple Teams ID. Additionally, your account must be associated with a valid D-U-N-S number and legal entity to create a team.

// ## Ios Usage

//     cd ios
//     pod cache clean --all
//     flutter clean && rm ios/Podfile.lock pubspec.lock && rm -rf ios/Pods ios/Runner.xcworkspace
//     pod deintegrate
//     pod setup
//     pod install
//     pod repo update
//     <!-- brew update -->
//     <!-- brew install cocoapods -->
//     <!-- gem install cocoapods -->
//     pod repo update
//     pod -–version
//     pod install --verbose
//     pod update Firebase

//     ios/podfile
//         platform :ios, '15.0'

//     project.pbxproj
//         IPHONEOS_DEPLOYMENT_TARGET = 15.0;

//     Appframeworkinfo.plist
//         <key>MinimumOSVersion</key>
//         <string>15.0</string>


//     https://docs.flutter.dev/deployment/ios#review-xcode-project-settings

//     flutter build ipa

// ## Android Version

//     **Change AndroidSdkVersion in build.gradle and local.properties and enable multidex
//     https://youtu.be/5oUE25tj5aQ?list=PLCOnzDflrUceRLfHEkl-u2ipjsre6ZwjV&t=643
//     **ManifestPlaceholders

//     local.properties : mode, minsdk, compilesdk, targetsdk, version
//     localProperties.getProperty('flutter.compileSdkVersion').toInteger()

//     flutter.minSdkVersion=26
//     flutter.targetSdkVersion=28
//     flutter.compileSdkVersion=33
//     flutter.buildMode=debug
//     flutter.versionName=1.0.0
//     flutter.versionCode=1

//     https://docs.flutter.dev/deployment/android

//     https://developer.android.com/reference/tools/gradle-api
//     https://developer.android.com/build/releases/gradle-plugin
//     https://kotlinlang.org/docs/releases.html#release-details
//     https://mvnrepository.com/artifact/com.android.tools.build/gradle?repo=google


//     build.gradle
//         ext.kotlin_version = '1.9.10'
    
//         classpath 'com.android.tools.build:gradle:8.1.1'

//     gradle wrapper
//         distributionUrl = https\://services.gradle.org/distributions/gradle-8.4-bin.zip

// ## Firebase Gitignore

//     ./android/app/google-services.json
//     ./lib/firebase_options.dart
//     ./ios/Runner/GoogleService-Info.plist

// ## Intl

//     l10n.yaml in root
//         arb-dir: lib/l10n
//         template-arb-file: app_en.arb
//         output-localization-file: loki.dart
//         output-class: Loki

//     l10n folder in lib
//         app_en.arb

//     flutter gen-l10n

//     flutter_localizations:
//         sdk: flutter

//     flutter
//         generate : true

//     import 'package:flutter_gen/gen_l10n/loki.dart';
//     localizationsDelegates: Loki.localizationsDelegates,
//     supportedLocales: Loki.supportedLocales,

//     ios : add to info.plist

//     <key>CFBundleLocalizations</key>
//     <array>
//      <string>en</string>
//      <string>sv</string>
//     </array>

// ## Google Codelabs

//     https://codelabs.developers.google.com/?product=firebase%2Cflutter

// ## Firebase Appcheck

//     https://www.youtube.com/watch?v=K1XU2y0YVtU
//     https://www.youtube.com/watch?v=DEV372Kof0g
//     https://www.youtube.com/watch?v=TzLON3oVGE0

//     https://firebase.google.com/learn/pathways/firebase-app-check

//     https://firebase.google.com/codelabs/app-attest

//     FirebaseAppcheck playintegrity apptest

//     build.gradle bom

//     https://www.google.com/recaptcha/about/
//     https://www.a2hosting.com/kb/security/obtaining-google-recaptcha-site-key-and-secret-key/

// ## Firebase Security Rules

//     https://firebase.google.com/codelabs/firebase-rules

//     https://www.youtube.com/watch?v=VDulvfBpzZE
//     https://www.youtube.com/watch?v=8Mzb9zmnbJs

// ## FireAuth

//     https://pub.dev/packages/google_sign_in
//     https://pub.dev/packages/sign_in_with_apple
//     https://pub.dev/packages/flutter_facebook_auth

//     Anonymous Auth & Linking
//     https://www.youtube.com/watch?v=6jGNSFdHHXc

//     https://youtu.be/vtGCteFYs4M?list=PL6yRaaP0WPkUf-ff1OX99DVSL1cynLHxO&t=14879

//     https://firebase.google.com/docs/auth/android/google-signin
//     https://firebase.google.com/docs/auth/android/facebook-login
//     https://firebase.google.com/docs/auth/android/apple

//     https://firebase.google.com/docs/auth/ios/google-signin
//     https://firebase.google.com/docs/auth/ios/facebook-login
//     https://firebase.google.com/docs/auth/ios/apple

//     https://firebase.google.com/docs/auth/flutter/federated-auth

//     https://www.chqbook.com/facebook-data-deletion-instructions-url/

//     https://www.youtube.com/watch?v=IzyOdKm0bWE
//     https://www.youtube.com/watch?v=HyiNbqLOCQ8&t=63s
//     https://www.youtube.com/watch?v=q-9lx7aSWcc&t=705s
//     https://www.youtube.com/watch?v=-OK7VG7Cl8I

//     firebase console sha

//     https://developers.google.com/android/guides/client-auth?authuser=0&hl=en
//     cmd.exe
//     cd android
//     gradlew.bat
//     gradlew.bat signingReport

//     gcp api enable
//     ios integration

// ## Build Runner

//     flutter pub run build_runner build --delete-conflicting-outputs

// ## Permission Handler

//     https://pub.dev/packages/permission_handler


// ## Firebase Remote Config

//     https://www.youtube.com/watch?v=vWJ8wDzeEg0&pp=ygUNcmVtb3RlIGNvbmZpZw%3D%3D
//     https://www.youtube.com/watch?v=23T9SGLcDsM
//     https://www.youtube.com/watch?v=pcnnbjAAIkI&pp=ygUNcmVtb3RlIGNvbmZpZw%3D%3D
//     https://www.youtube.com/watch?v=0DBRiMWy28Y&pp=ygUNcmVtb3RlIGNvbmZpZw%3D%3D
//     https://www.youtube.com/watch?v=iVHRy_uVtm0&ab_channel=Fireship

// ## RevenueCat - InAppPurchase

//     https://medium.com/flutter-community/in-app-purchases-with-flutter-a-comprehensive-step-by-step-tutorial-b96065d79a21

//     https://medium.com/flutter-community/how-to-set-up-in-app-purchases-in-apple-connect-and-google-play-console-28cc2456af3b

//     https://developer.android.com/google/play/billing
//     https://developer.apple.com/in-app-purchase/

//     https://pub.dev/packages/in_app_purchase
//     https://codelabs.developers.google.com/codelabs/flutter-in-app-purchases#3
//     https://blog.codemagic.io/understanding-in-app-purchase-apis-in-flutter/

//     https://github.com/RevenueCat/purchases-flutter/tree/main/revenuecat_examples
//     https://extensions.dev/extensions/revenuecat/firestore-revenuecat-purchases

//     https://www.revenuecat.com/docs
//     https://www.revenuecat.com/docs/firebase-integration
//     https://www.revenuecat.com/docs/android-products
//     https://www.revenuecat.com/docs/ios-products

//     https://www.youtube.com/watch?v=31mM8ozGyE8
//     https://www.youtube.com/watch?v=WechH9jx41w

//     https://www.youtube.com/watch?v=TrkiSZ2mnlo
//     https://www.youtube.com/watch?v=h-jOMh2KXTA

// ## Google Maps

//     * https://github.com/flutter/samples/tree/main/place_tracker

//     Google Maps : Enable Google Map SDK for each platform : Billing account
//     google_maps_flutter

//     https://codelabs.developers.google.com/?product=googlemapsplatform

//     https://codelabs.developers.google.com/codelabs/google-maps-in-flutter#0

//     https://developers.google.com/maps/gmp-get-started

//     https://github.com/flutter/plugins/tree/main/packages/google_maps_flutter/google_maps_flutter/example/lib

//     https://pub.dev/packages/google_maps_flutter

//     Map 
//         https://www.youtube.com/watch?v=LnZyorDeLmQ
//         https://www.youtube.com/watch?v=MrnA6vpTXik
//         https://www.youtube.com/watch?v=tfFByL7F-00
//         https://www.youtube.com/watch?v=hgIVDqDCFbk
//         https://www.youtube.com/watch?v=mVI_PiB7fyw
//         https://www.youtube.com/watch?v=B9hsWOCXb_o
//         https://www.youtube.com/watch?v=zLxoVC6jUPw
//         https://www.youtube.com/watch?v=R4PxkSYQmec

//     Places Api autocomplete
//         https://www.youtube.com/watch?v=3CO8pGw7fzY
//         https://www.youtube.com/watch?v=9rHHD1IwvkE
//         https://www.youtube.com/watch?v=QyeBcwET-Ww
//         https://www.youtube.com/watch?v=GejRaGkkQYQ
//         https://www.youtube.com/playlist?list=PL_D-RntzgLvbhv28GXs0bO8wu84_mnyWV

//     https://pub.dev/packages/geolocator
//     https://pub.dev/packages/geocoding
//     https://www.youtube.com/watch?v=PDriZznSzVI
//     https://www.digitalocean.com/community/tutorials/flutter-geolocator-plugin#prerequisites

//     https://pub.dev/packages/location
//     https://blog.logrocket.com/geolocation-geocoding-flutter/

// ## Splash - Icons

//     https://pub.dev/packages/flutter_native_splash
//     https://pub.dev/packages/flutter_launcher_icons
//     https://pub.dev/packages/flutter_app_badger

//     https://docs.flutter.dev/development/ui/advanced/splash-screen
//     https://developer.android.com/develop/ui/views/launch/splash-screen

// ## Quick Action

//     https://pub.dev/packages/quick_actions
//     https://www.youtube.com/watch?v=sqw-taR2_Ww

// ## Webview

//     https://codelabs.developers.google.com/codelabs/flutter-webview#0
//     https://www.youtube.com/watch?v=FrqGGw9DYfs
//     https://www.youtube.com/watch?v=LyAwnwvbBKM
//     https://www.youtube.com/watch?v=SyDo0GqBVYU
//     https://www.youtube.com/watch?v=5R3ehXV-oog

// ## WebRtc

//            : https://pub.dev/packages/flutter_webrtc
//     Twilio : https://pub.dev/packages/twilio_programmable_video
//     Agora  : https://pub.dev/packages/agora_rtc_engine
//     Livekit: https://pub.dev/packages/livekit_client
//     Vonage : https://github.com/Vonage-Community/sample-video-flutter-app

// ## Deep Linking + Intents

//     https://pub.dev/packages/uni_links
//     https://pub.dev/packages/receive_sharing_intent
//     https://pub.dev/packages/share_plus
//     https://pub.dev/packages/external_app_launcher

//     https://developer.android.com/training/app-links/verify-android-applinks

//     https://docs.flutter.dev/development/ui/navigation/deep-linking

//     https://docs.flutter.dev/cookbook/navigation/set-up-app-links
//     https://docs.flutter.dev/cookbook/navigation/set-up-universal-links

//     https://medium.com/flutter-community/deep-links-and-flutter-applications-how-to-handle-them-properly-8c9865af9283

//     # https://well-known.dev/resources/assetlinks/

//     # https://www.youtube.com/watch?v=6lHBw3F4cWs&ab_channel=GoogleChromeDevelopers
//     # https://www.youtube.com/watch?v=3bAQPnxLd4c&ab_channel=GoogleChromeDevelopers
//     https://www.youtube.com/watch?v=7JDFjeMvxos&ab_channel=Fireship
//     https://developer.chrome.com/docs/android/trusted-web-activity/android-for-web-devs/

//     # https://developers.google.com/digital-asset-links/v1/getting-started
//     # https://developers.google.com/digital-asset-links/tools/generator


//     * https://www.youtube.com/watch?v=6RxuDcs6jVw

//     * https://www.youtube.com/watch?v=KNAb2XL7k2g
    
//     https://www.youtube.com/watch?v=gpS723VPuBM

//     https://blog.logrocket.com/understanding-deep-linking-flutter-uni-links/

//     * https://www.youtube.com/watch?v=1qFIg-lz4Ys&list=PLWz5rJ2EKKc-hZMZIfAUMBDR7kPC1m7HU
//     https://developer.android.com/guide/components/intents-filters
//     https://play.google.com/console/about/deeplinks/
//     https://developer.android.com/training/app-links
//     https://developer.android.com/training/basics/intents/filters.html
//     https://developer.android.com/studio/write/app-link-indexing#testindent

//     https://www.youtube.com/watch?v=GeyvIbBS7s8&list=PLOU2XLYxmsIIKmZTma7hvZ-0-vMGunDQi
//     https://www.youtube.com/playlist?list=PLWz5rJ2EKKc-hZMZIfAUMBDR7kPC1m7HU
//     https://developer.android.com/training/app-links
//     https://support.google.com/googleplay/android-developer/answer/12463044?hl=en#zippy=%2Capp-picker

//     https://developer.apple.com/ios/universal-links/
//     https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html
//     https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app

//     Swift
//     https://youtu.be/OyzFPrVIlQ8


// ## Firebase Analytics

//     https://www.youtube.com/watch?v=8iZpH7O6zXo&list=PLl-K7zZEsYLkV1DCmC8Vj9Wl9hjVI2AJm&index=1&ab_channel=Firebase
//     https://www.youtube.com/playlist?list=PLl-K7zZEsYLlfMZ9isO6Hfnyw040N3uT5
//     https://www.youtube.com/watch?v=c66gQzNNHuA&ab_channel=Firebase
//     https://www.youtube.com/watch?v=2F2XhgMt8Dg
//     https://www.youtube.com/watch?v=-tPHRj64zTM&ab_channel=Firebase
//     https://youtu.be/ouZkadjMn94?list=PL-BW8gXncImPcEARbty0CIoqji6yGQ9b0
//     https://www.youtube.com/watch?v=pP044hR6zNQ&ab_channel=Firebase
//     https://www.youtube.com/watch?v=P51dI2y7QHA&ab_channel=Firebase
//     https://www.youtube.com/watch?v=DPWlIhiV2Jw&pp=ygUmZ2V0dGluZyBzdGFydGVkIHdpdGggYW5hbHl0aWNzIGFuZHJvaWQ%3D
//     https://www.youtube.com/watch?v=VPLkd_aqKwU&ab_channel=Firebase
//     https://www.youtube.com/watch?v=2F2XhgMt8Dg&pp=ygUsZmlyZWJhc2UgZGV2ZWxvcGVyIGd1aWRlIHRvIGdvb2dsZSBhbmFseXRpY3M%3D
//     https://www.youtube.com/watch?v=tyPvJBVkhrI&pp=ygUhaW1wcm92ZSB1c2VyIGFjcXVpc2F0aW9uIGNhbXBhaW5z

// ## Firebase Crashlytics

//     https://pub.dev/packages/firebase_crashlytics/example

//     https://www.youtube.com/watch?v=cIFLFpKTy7c
//     https://www.youtube.com/watch?v=aIqy-Ulu4Gw
//     https://www.youtube.com/watch?v=1wBpX0iFl5E

// ## Firebase AB Testing

//     https://www.youtube.com/watch?v=ph-gNsKX2oA&list=PLl-K7zZEsYLnt1-3lFiY89YtAFQzLZo-O&ab_channel=Firebase
