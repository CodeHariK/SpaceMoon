# Create App in Playstore

* [Build and release an Android app](https://docs.flutter.dev/deployment/android)
* [Sign your app](https://developer.android.com/studio/publish/app-signing)

* [Use Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756)

* [Best practice for your store listing](https://support.google.com/googleplay/android-developer/answer/13393723)

``` android

### https://docs.flutter.dev/add-to-app/android/project-setup
ndk {
    abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86_64'
}


def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}


signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}
buildTypes {
    release {
        // signingConfig signingConfigs.debug
        signingConfig signingConfigs.release

        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile(
                'proguard-android-optimize.txt'),
                'proguard-rules.pro' 
    }
}


dependencies {
    implementation 'com.google.android.play:integrity:1.3.0'
}


```
