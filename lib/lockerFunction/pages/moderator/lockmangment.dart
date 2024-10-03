import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/moderator/InTheProgress.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/moderator/LockerDeatilsAndItemCount.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/service/database.dart';

class LockerManagement extends StatefulWidget {
  const LockerManagement({super.key});

  @override
  State<LockerManagement> createState() => _LockerManagementState();
}

class _LockerManagementState extends State<LockerManagement> {
  Stream<QuerySnapshot>? lockerStream;
  int value = 1;

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
  }

  Future<void> getOnTheLoad() async {
    lockerStream = await DatabaseMethods().getLockerDetails();
    setState(() {}); // Notify the UI to update after loading data.
  }

  Widget displayLockerDetailAndItemCount(){
    return lockerDetailAndItemCount(lockerStream);
  }

  Widget displayLInProgressPackage(){
    return packagesInTheProgress();
  }

   Widget switchPanel(int value) {
    if(value == 1){
      return displayLockerDetailAndItemCount();
    }else{
      return displayLInProgressPackage();
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Lockers'),
      backgroundColor: Colors.blueAccent,
    ),
    body: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/scanLock');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code_scanner),
                    SizedBox(width: 8.0),
                    Text(
                      "Scan QR Code",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0), // Spacing between the buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        value == 1 ? Colors.black : Colors.white,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            topRight: Radius.circular(0.0),
                            bottomRight: Radius.circular(0.0),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        value = 1;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "To be transferred",
                          style: TextStyle(
                            color: value == 1 ? Colors.white : Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        value == 0 ? Colors.black : Colors.white,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0.0),
                            bottomLeft: Radius.circular(0.0),
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        value = 0;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "In the progress",
                          style: TextStyle(
                            color: value == 0 ? Colors.white : Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded( // Correct usage of Expanded here
          child: Container(
            child: switchPanel(value),
          ),
        ),
      ],
    ),
  );
}
}