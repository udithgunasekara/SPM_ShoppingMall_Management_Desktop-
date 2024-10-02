import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spm_shoppingmall_mobile/auth/firebase_auth_impl/firebase_auth_impl.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/util/user_data_service.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _userDetails;
  final UserDataService _userDataService = UserDataService();
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    final userDetails = await _userDataService.getUserDetails(widget.user!.uid);
    setState(() {
      _userDetails = userDetails;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User signed out')),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      debugPrint('Sign out failed : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        elevation: 16,
        shadowColor: Colors.black,
        // backgroundColor: const Color.fromARGB(255, 2, 255, 137),
        actions: [
          IconButton(
            icon: const Icon(
                Icons.notifications_active_outlined), // Notification icon
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout), // Logout icon
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: _userDetails == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome, ${_userDetails?['name']}!',
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  Text('Email: ${widget.user!.email}',
                      style: const TextStyle(fontSize: 16)),
                  Text('ID: ${widget.user!.uid}',
                      style: const TextStyle(fontSize: 16)),
                  Text('Phone: ${_userDetails?['phone']}',
                      style: const TextStyle(fontSize: 16)),
                  Text('Loyalty Points: ${_userDetails?['loyaltyPoints']}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/billentry');
                    },
                    child: const Text('Add loyalty points'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/giftcards');
                    },
                    child: const Text('your giftcards'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/lockerhome');
                    },
                    child: const Text('locker app'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/ScannerPage');
                    },
                    child: const Text('Scan Product'),
                  ),
                ],
              ),
      ),
    );
  }
}
