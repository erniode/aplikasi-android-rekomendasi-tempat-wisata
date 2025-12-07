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
    apiKey: 'AIzaSyAxaojeyK579CotCetw2ZxvWo0Wd9aWzSw',
    appId: '1:535393974744:web:82da6249b0d81ee71fdaad',
    messagingSenderId: '535393974744',
    projectId: 'sistemrekomendasiwisatamaluku',
    authDomain: 'sistemrekomendasiwisatamaluku.firebaseapp.com',
    databaseURL:
        'https://sistemrekomendasiwisatamaluku-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'sistemrekomendasiwisatamaluku.firebasestorage.app',
    measurementId: 'G-THP4XQTE7K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBReRPpzfKFMG36LuVCLrZIJTS_aFEAnOo',
    appId: '1:535393974744:android:022a577a90bed3631fdaad',
    messagingSenderId: '535393974744',
    projectId: 'sistemrekomendasiwisatamaluku',
    databaseURL:
        'https://sistemrekomendasiwisatamaluku-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'sistemrekomendasiwisatamaluku.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBw4JjjaB69FIOLO-P1MaylXpVBRGC3CbE',
    appId: '1:535393974744:ios:99cfb701b3d1f1951fdaad',
    messagingSenderId: '535393974744',
    projectId: 'sistemrekomendasiwisatamaluku',
    databaseURL:
        'https://sistemrekomendasiwisatamaluku-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'sistemrekomendasiwisatamaluku.firebasestorage.app',
    iosBundleId: 'com.example.sistemRekomendasiWisataMaluku',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBw4JjjaB69FIOLO-P1MaylXpVBRGC3CbE',
    appId: '1:535393974744:ios:99cfb701b3d1f1951fdaad',
    messagingSenderId: '535393974744',
    projectId: 'sistemrekomendasiwisatamaluku',
    databaseURL:
        'https://sistemrekomendasiwisatamaluku-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'sistemrekomendasiwisatamaluku.firebasestorage.app',
    iosBundleId: 'com.example.sistemRekomendasiWisataMaluku',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAxaojeyK579CotCetw2ZxvWo0Wd9aWzSw',
    appId: '1:535393974744:web:777c65bd0c7cc66e1fdaad',
    messagingSenderId: '535393974744',
    projectId: 'sistemrekomendasiwisatamaluku',
    authDomain: 'sistemrekomendasiwisatamaluku.firebaseapp.com',
    databaseURL:
        'https://sistemrekomendasiwisatamaluku-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'sistemrekomendasiwisatamaluku.firebasestorage.app',
    measurementId: 'G-T6TBJRSFX6',
  );
}
