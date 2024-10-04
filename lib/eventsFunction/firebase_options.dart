// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: _apiKey,
      appId: _appId,
      messagingSenderId: _messagingSenderId,
      projectId: _projectId,
      storageBucket: _storageBucket,
      databaseURL: _databaseURL,
    );
  }

  static const String _apiKey = 'AIzaSyAOdZK9Watg-RRlEWKTbVxfZeWBKfRn6VE';
  static const String _appId =
      '1:37818713548:android:00c892d51705d154994969'; // Replace with the app ID you are targeting.
  static const String _messagingSenderId = '37818713548';
  static const String _projectId = 'shopping-mall-application';
  static const String _storageBucket = 'shopping-mall-application.appspot.com';
  static const String _databaseURL =
      'https://shopping-mall-application-default-rtdb.asia-southeast1.firebasedatabase.app';
}
