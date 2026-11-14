
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
    apiKey: 'AIzaSyD1i6ez2FnWX_ABktHCuMPAgIvBvJQKUPA',
    appId: '1:353061585980:web:4c37b5d40ff6bf86b1af39',
    messagingSenderId: '353061585980',
    projectId: 'mobile-app-e0332',
    authDomain: 'mobile-app-e0332.firebaseapp.com',
    storageBucket: 'mobile-app-e0332.firebasestorage.app',
    measurementId: 'G-3M8570087D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9j-n8_QfON7hUtNN39-so0Zz9WOx1CNU',
    appId: '1:353061585980:android:66253b02da990271b1af39',
    messagingSenderId: '353061585980',
    projectId: 'mobile-app-e0332',
    storageBucket: 'mobile-app-e0332.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNIFn-lSubtnQIzSgqtZ_ctw6FFFqaZeE',
    appId: '1:353061585980:ios:4b6b2b0f5f99b900b1af39',
    messagingSenderId: '353061585980',
    projectId: 'mobile-app-e0332',
    storageBucket: 'mobile-app-e0332.firebasestorage.app',
    iosBundleId: 'com.example.movieAppUpdates',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCNIFn-lSubtnQIzSgqtZ_ctw6FFFqaZeE',
    appId: '1:353061585980:ios:4b6b2b0f5f99b900b1af39',
    messagingSenderId: '353061585980',
    projectId: 'mobile-app-e0332',
    storageBucket: 'mobile-app-e0332.firebasestorage.app',
    iosBundleId: 'com.example.movieAppUpdates',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD1i6ez2FnWX_ABktHCuMPAgIvBvJQKUPA',
    appId: '1:353061585980:web:371107bc03fa63f3b1af39',
    messagingSenderId: '353061585980',
    projectId: 'mobile-app-e0332',
    authDomain: 'mobile-app-e0332.firebaseapp.com',
    storageBucket: 'mobile-app-e0332.firebasestorage.app',
    measurementId: 'G-LXK0ZQBLKW',
  );
}
