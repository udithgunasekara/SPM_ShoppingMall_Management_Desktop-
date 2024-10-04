import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spm_shoppingmall_mobile/auth/login_page.dart';
import 'package:spm_shoppingmall_mobile/auth/signup_page.dart';
import 'package:spm_shoppingmall_mobile/common/home_page.dart';
import 'package:spm_shoppingmall_mobile/eventsFunction/screens/favorites_screen.dart';
import 'package:spm_shoppingmall_mobile/eventsFunction/screens/home_screen.dart'; // Updated to use HomeScreen
import 'package:spm_shoppingmall_mobile/eventsFunction/screens/settings_screen.dart';
import 'package:spm_shoppingmall_mobile/eventsFunction/widgets/navbar.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/pages/bill_entry_page.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/pages/claimed_giftcard_page.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/pages/loyalty_giftcard_page.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/pages/notification_page.dart';
import 'package:spm_shoppingmall_mobile/productSearchFunction/pages/scannerPage.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/moderator/lockmangment.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/user/lockerHome.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/moderator/scanLock.dart';
import 'package:spm_shoppingmall_mobile/productSearchFunction/pages/wishList.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        '/home': (context) => MyHomePage(),
        '/billentry': (context) => const BillEntryPage(),
        '/notifications': (context) => NotificationsPage(),
        '/giftcards': (context) => const ClaimedGiftCardsPage(),
        '/giftcardandloyalty': (context) => const GiftCardAndLoyaltyPage(),
        '/ScannerPage': (context) => const ScannerPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(user: FirebaseAuth.instance.currentUser,),
    Wishlist(),
    ScannerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
     ),
  );
}
}