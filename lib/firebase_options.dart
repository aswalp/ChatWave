// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCdshD7gaXCf_ur8quunEPq3La-IM6_vlk',
    appId: '1:43416043867:android:69d2f5c303092155049a7e',
    messagingSenderId: '43416043867',
    projectId: 'chat-app-19690',
    storageBucket: 'chat-app-19690.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0R_RqAPSfPzgsk92WR77dJ1J-mVFuwXc',
    appId: '1:43416043867:ios:d2cea1b898fdf659049a7e',
    messagingSenderId: '43416043867',
    projectId: 'chat-app-19690',
    storageBucket: 'chat-app-19690.appspot.com',
    androidClientId: '43416043867-m3trivd7id4bqcebmlmo1j6uecshemkp.apps.googleusercontent.com',
    iosClientId: '43416043867-omals5pqlnkm2sdip336ld3g3sf6qr9o.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatapp',
  );
}
