import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBCRt9uKN_wqHg2TUf_T-S2Nis5QUoH6B4',
    appId: '1:672910458772:web:b31efae09bec2610331981',
    messagingSenderId: '672910458772',
    projectId: 'budgetbuddy-c428a',
    authDomain: 'budgetbuddy-c428a.firebaseapp.com',
    storageBucket: 'budgetbuddy-c428a.firebasestorage.app',
    measurementId: 'G-XWF0NPVWBL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxzscEtzftxYgkf4jgf_OfvYxpKKmMoWo',
    appId: '1:672910458772:android:32868ea6d9472f97331981',
    messagingSenderId: '672910458772',
    projectId: 'budgetbuddy-c428a',
    storageBucket: 'budgetbuddy-c428a.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBCRt9uKN_wqHg2TUf_T-S2Nis5QUoH6B4',
    appId: '1:672910458772:web:390a29e5050ee1e1331981',
    messagingSenderId: '672910458772',
    projectId: 'budgetbuddy-c428a',
    authDomain: 'budgetbuddy-c428a.firebaseapp.com',
    storageBucket: 'budgetbuddy-c428a.firebasestorage.app',
    measurementId: 'G-HBGXVR369N',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCcTjTUlDtqL4vkk0mo3Q1XlbOQ9l_RyDI',
    appId: '1:672910458772:ios:d6ef61988dd38b07331981',
    messagingSenderId: '672910458772',
    projectId: 'budgetbuddy-c428a',
    storageBucket: 'budgetbuddy-c428a.firebasestorage.app',
    iosBundleId: 'com.example.budgetbuddy',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCcTjTUlDtqL4vkk0mo3Q1XlbOQ9l_RyDI',
    appId: '1:672910458772:ios:d6ef61988dd38b07331981',
    messagingSenderId: '672910458772',
    projectId: 'budgetbuddy-c428a',
    storageBucket: 'budgetbuddy-c428a.firebasestorage.app',
    iosBundleId: 'com.example.budgetbuddy',
  );
}
