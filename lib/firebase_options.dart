import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    print("defaultTargetPlatform $defaultTargetPlatform");
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTTgJR-CGgblbSwl6Aq1GKvEzIrtB06zg',
    appId: '1:394385289303:android:b93ef04f813142daf47312',
    messagingSenderId: '394385289303',
    projectId: 'tshopperapp',
    storageBucket: 'tshopperapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBmGzYezic3vM4scQTIv4Cy_GLSJbnQtb0',
    appId: '1:394385289303:ios:b65a3e873cdc79eef47312',
    messagingSenderId: '394385289303',
    projectId: 'tshopperapp',
    iosBundleId: 'com.todogroup.tshopperApp',
    storageBucket: 'tshopperapp.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBmGzYezic3vM4scQTIv4Cy_GLSJbnQtb0',
    appId: '1:394385289303:ios:b65a3e873cdc79eef47312',
    messagingSenderId: '394385289303',
    projectId: 'tshopperapp',
    storageBucket: 'tshopperapp.firebasestorage.app',
    iosBundleId: 'com.todogroup.tshopperApp',
  );
}
