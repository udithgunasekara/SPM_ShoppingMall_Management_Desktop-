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

    final billDetails =
        await _userDataService.getBillDetails(_billNumberController.text);
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
          _message =
              'Bill amount : $billAmount \n added  $points to your loyalty points';
        });

        //wait for a moment to show the suceess message
        await Future.delayed(const Duration(seconds: 2));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: user)),
          (Route<dynamic> route) => false,
        );

        Navigator.pushNamed(context, '/giftcardandloyalty');

        //navigate back to home page
        /* Future.delayed(const Duration(seconds: 4), () {
          Navigator.pushReplacementNamed(context, '/giftcardandloyalty');
        }); */
      }
    } else {
      setState(() {
        _message = 'Bill not found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Loyalty Points',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        elevation: 16,
        shadowColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.black,
          weight: 60,
        ),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                // Top Section
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.3, // 30% of screen height
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF6A0DAD), Color(0xFF9932CC)],
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.loyalty,
                            size: 60,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Loyalty points will be added to:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${user!.email}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Bottom Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Enter your bill number',
                            prefixIcon: const Icon(Icons.receipt_long),
                          ),
                          controller: _billNumberController,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 8,
                            backgroundColor: const Color(0xFF6A0DAD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
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
                        if (_message != null) ...[
                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: _message!.contains('added')
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              _message!,
                              style: TextStyle(
                                fontSize: 16,
                                color: _message!.contains('added')
                                    ? Colors.green.shade800
                                    : Colors.red.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// title: Text('loyalty  to ${user!.email}'

  /* @override
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
  } */
