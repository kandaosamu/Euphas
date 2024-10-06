// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBTVds7Z9pf9V5TgQXfmRlZa6nwuMo6quc',
    appId: '1:335631819258:web:3676bcca565936fe760443',
    messagingSenderId: '335631819258',
    projectId: 'euphas-edfba',
    authDomain: 'euphas-edfba.firebaseapp.com',
    storageBucket: 'euphas-edfba.appspot.com',
    measurementId: 'G-GCLK0E6JRM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB-HkcZ2dCzC2jxEPWRQoKlVMWUTYjXAQk',
    appId: '1:335631819258:android:3ff0eb53253b167a760443',
    messagingSenderId: '335631819258',
    projectId: 'euphas-edfba',
    storageBucket: 'euphas-edfba.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAuiS4rVe-tFmGejIzRUD4ddSTo0Xh6lvk',
    appId: '1:335631819258:ios:d123ccb07f173e5f760443',
    messagingSenderId: '335631819258',
    projectId: 'euphas-edfba',
    storageBucket: 'euphas-edfba.appspot.com',
    iosBundleId: 'com.example.euphas',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAuiS4rVe-tFmGejIzRUD4ddSTo0Xh6lvk',
    appId: '1:335631819258:ios:d123ccb07f173e5f760443',
    messagingSenderId: '335631819258',
    projectId: 'euphas-edfba',
    storageBucket: 'euphas-edfba.appspot.com',
    iosBundleId: 'com.example.euphas',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCYGAIUVk7b2ivyekYITftxD2o2qGJO4aQ',
    appId: '1:335631819258:web:aed83fc8f2a93e30760443',
    messagingSenderId: '335631819258',
    projectId: 'euphas-edfba',
    authDomain: 'euphas-edfba.firebaseapp.com',
    storageBucket: 'euphas-edfba.appspot.com',
    measurementId: 'G-DZJJM61C6Z',
  );
}