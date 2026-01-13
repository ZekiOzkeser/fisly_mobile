import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/widgets.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not supported for web in this project.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDPzGkSKC3YIC8T2UsRcAEPty24E8PrWFs',
    appId: '1:959021808734:android:b856aafb732670d8b6c8cf',
    messagingSenderId: '959021808734',
    projectId: 'fislymobile',
    storageBucket: 'fislymobile.firebasestorage.app',
    // androidPackageName: 'com.fisly.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBrRk4y4DBWGhgzuty6wJeQcc_Tzv6DX9E',
    appId: '1:959021808734:ios:2fd51eab9239d5a6b6c8cf',
    messagingSenderId: '959021808734',
    projectId: 'fislymobile',
    storageBucket: 'fislymobile.firebasestorage.app',
    iosBundleId: 'com.fisly.app',
  );
}
