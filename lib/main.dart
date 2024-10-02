import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spm_shoppingmall_mobile/auth/login_page.dart';
import 'package:spm_shoppingmall_mobile/auth/signup_page.dart';
import 'package:spm_shoppingmall_mobile/common/home_page.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/pages/bill_entry_page.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/pages/claimed_giftcard_page.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/pages/notification_page.dart';
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
      initialRoute: '/login',
      routes: {
        '/lockerhome': (context) => const Home(),
        '/login' : (context) => const LoginPage(),
        '/signup' : (context) => const SignupPage(),
        '/home' : (context) => HomePage(user: FirebaseAuth.instance.currentUser),
        '/billentry' : (context) => const BillEntryPage(),
        '/notifications': (context) => NotificationsPage(),
        '/giftcards': (context) => const ClaimedGiftCardsPage(),
      },
    );
  }
}
