import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userID', 'C001');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      /* title: 'Flutter Firebase auth',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        hintColor: Colors.amber,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.teal,
          shape: RoundedRectangleBorder(),
        ),
      ), */
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home()
      },
    );
  }
}