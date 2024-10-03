import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/moderator/LockerDeatilsAndItemCount.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/service/database.dart';

class LockerManagment extends StatefulWidget {
  const LockerManagment({super.key});

  @override
  State<LockerManagment> createState() => _LockerManagmentState();
}

class _LockerManagmentState extends State<LockerManagment> {
  Stream<QuerySnapshot>? lockerStream;

  Future<void> getOnTheLoad() async {
    lockerStream = await DatabaseMethods().getLockerDetails();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lockers'),
        backgroundColor: Colors.orange, // Matching the button's orange color
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // This could be an icon or a representation of the QR code
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.qr_code, // Icon resembling the QR code
                      size: 100,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 30),
                  // Button styled similarly
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/scanLock');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Changed to backgroundColor
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Scan QR Code",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: lockerDetailAndItemCount(lockerStream), // Locker details displayed here
          ),
        ],
      ),
    );
  }
}