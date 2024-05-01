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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZpUSDOVTaP8-TXtzk1d3bm8Ccimo7l0E',
    appId: '1:1087361013683:android:9132af3428a9027b625dc6',
    messagingSenderId: '1087361013683',
    projectId: 'educationapp-5f2da',
    storageBucket: 'educationapp-5f2da.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMUW1T5LQp3sV7xGxiMgB2yUnFlOahZQQ',
    appId: '1:1087361013683:ios:f2303a70bf3ecb51625dc6',
    messagingSenderId: '1087361013683',
    projectId: 'educationapp-5f2da',
    storageBucket: 'educationapp-5f2da.appspot.com',
    iosBundleId: 'com.example.uniberry2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMUW1T5LQp3sV7xGxiMgB2yUnFlOahZQQ',
    appId: '1:1087361013683:ios:f2303a70bf3ecb51625dc6',
    messagingSenderId: '1087361013683',
    projectId: 'educationapp-5f2da',
    storageBucket: 'educationapp-5f2da.appspot.com',
    iosBundleId: 'com.example.uniberry2',
  );
}
