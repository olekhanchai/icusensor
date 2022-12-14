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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDiNwoh9CBMCGKMs6UGiNxsYuefgtNpW2Y',
    appId: '1:1042218634267:web:68f48fb874fa1bfbeafcbe',
    messagingSenderId: '1042218634267',
    projectId: 'icusensor-8b5b4',
    authDomain: 'icusensor-8b5b4.firebaseapp.com',
    storageBucket: 'icusensor-8b5b4.appspot.com',
    measurementId: 'G-EDPMDSQPL7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBIEu5SyR6BrD0F8R2KLiHQ6v_VxneNklE',
    appId: '1:1042218634267:android:b0f8698459486ec1eafcbe',
    messagingSenderId: '1042218634267',
    projectId: 'icusensor-8b5b4',
    storageBucket: 'icusensor-8b5b4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAUhzCwpOmrOMXQbTMs7RSjrcQ6LMwxFH0',
    appId: '1:1042218634267:ios:6069e5c1830bdad6eafcbe',
    messagingSenderId: '1042218634267',
    projectId: 'icusensor-8b5b4',
    storageBucket: 'icusensor-8b5b4.appspot.com',
    iosClientId: '1042218634267-i9u812nrnk9v8iahrejck6ctsoums6r4.apps.googleusercontent.com',
    iosBundleId: 'com.main.icusensor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAUhzCwpOmrOMXQbTMs7RSjrcQ6LMwxFH0',
    appId: '1:1042218634267:ios:6069e5c1830bdad6eafcbe',
    messagingSenderId: '1042218634267',
    projectId: 'icusensor-8b5b4',
    storageBucket: 'icusensor-8b5b4.appspot.com',
    iosClientId: '1042218634267-i9u812nrnk9v8iahrejck6ctsoums6r4.apps.googleusercontent.com',
    iosBundleId: 'com.main.icusensor',
  );
}
