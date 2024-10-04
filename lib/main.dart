import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spm_shoppingmall_mobile/auth/login_page.dart';
import 'package:spm_shoppingmall_mobile/auth/signup_page.dart';
import 'package:spm_shoppingmall_mobile/eventsFunction/screens/home_screen.dart'; // Updated to use HomeScreen
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/pages/bill_entry_page.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/pages/claimed_giftcard_page.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/pages/loyalty_giftcard_page.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/pages/notification_page.dart';
import 'package:spm_shoppingmall_mobile/productSearchFunction/pages/scannerPage.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/moderator/lockmangment.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/user/lockerHome.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/moderator/scanLock.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/lockerhome': (context) => const LockerHome(),
        '/scanLock': (context) => const ScanLock(),
        '/lockerManagment': (context) => const LockerManagement(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        // Updated to use HomeScreen instead of HomePage
        '/home': (context) {
          // You might want to check if the user is logged in here
          final user = FirebaseAuth.instance.currentUser;
          return HomeScreen(); // No need to pass user if HomeScreen fetches it itself
        },
        '/billentry': (context) => const BillEntryPage(),
        '/notifications': (context) => NotificationsPage(),
        '/giftcards': (context) => const ClaimedGiftCardsPage(),
        '/giftcardandloyalty': (context) => const GiftCardAndLoyaltyPage(),
        '/ScannerPage': (context) => const ScannerPage(),
      },
    );
  }
}
