// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC-qdezckG7CfZ4-7LqB3q9eApNCmncG8I',
    appId: '1:597138724216:web:76015b0cd6df62738a248d',
    messagingSenderId: '597138724216',
    projectId: 'mynotes-4c352',
    authDomain: 'mynotes-4c352.firebaseapp.com',
    storageBucket: 'mynotes-4c352.appspot.com',
    measurementId: 'G-CWRZD8T28T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDixrh2aP9DFq8KAmCfyZyDPsuvR2TsXLM',
    appId: '1:597138724216:android:ebfaa123d858ad278a248d',
    messagingSenderId: '597138724216',
    projectId: 'mynotes-4c352',
    storageBucket: 'mynotes-4c352.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMp_t8IdpFzkQaOv06YfQT0hDbY69IAoE',
    appId: '1:597138724216:ios:f7618f25d0bf8f658a248d',
    messagingSenderId: '597138724216',
    projectId: 'mynotes-4c352',
    storageBucket: 'mynotes-4c352.appspot.com',
    iosClientId: '597138724216-bumgeonqas9ja7tgb1sp5qfp5q53qve8.apps.googleusercontent.com',
    iosBundleId: 'com.mynotes.app',
  );
}
