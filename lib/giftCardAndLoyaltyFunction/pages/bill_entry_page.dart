import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spm_shoppingmall_mobile/common/home_page.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/util/user_data_service.dart';

class BillEntryPage extends StatefulWidget {
  const BillEntryPage({super.key});

  @override
  State<BillEntryPage> createState() => _BillEntryPageState();
}

class _BillEntryPageState extends State<BillEntryPage> {

  final TextEditingController _billNumberController = TextEditingController();
  final UserDataService _userDataService = UserDataService();
  String? _message;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> _checkbill() async {
    if (user == null) return;

    final billDetails = await _userDataService.getBillDetails(_billNumberController.text);
    if (billDetails != null) {
      bool isClaimed = billDetails['claimed'] ?? false;

      if (isClaimed) {
        setState(() {
          _message = 'Bill already claimed';
        });
      } else {
        double billAmount = billDetails['amount']?.toDouble() ?? 0;

        //update loyalty points and set claimed to true
        var points = await _userDataService.updateLoyaltyPoints(
            user!.uid, billAmount, _billNumberController.text);

        setState(() {
          _message = 'Bill amount : $billAmount \n added  $points to your loyalty points';
        });

        //navigate back to home page
        Future.delayed(const Duration(seconds: 4), () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage(user: user)),
              (Route<dynamic> route) => false);
        });
      }
    } else {
      setState(() {
        _message = 'Bill not found';
      });
    }
  }
// title: Text('loyalty  to ${user!.email}'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Loyalty points',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        elevation: 16,
        shadowColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 0, 0, 0),
          weight: 60,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Text(
              'loyalty points will be added \n to your ${user!.email}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your bill number to add loyalty points'),
              controller: _billNumberController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: _checkbill,
                  child: const Text(
                    'Check Bill',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (_message != null) ...[
              const SizedBox(height: 20),
              Text(
                _message!,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}