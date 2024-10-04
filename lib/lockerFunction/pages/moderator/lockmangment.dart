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

  Widget changeSubHead() {
    String message;

    if (value == 1) {
      message = "This screen showed available lockers and count of packages that need to be tranfer to the pick up locker";
    } else{
      message = "This screen showed pickup locker details and tranfer details of specific packages that are transfer in progress";
    }

    return Container(
      width: 300.0,
      height: 180.0, // Set a specific width less than the parent width
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
           if (value == 0) ...[ // Adjust the size of the circle
              Icon(
                Icons.cached_outlined, // QR code icon
                color: Colors.white, // Icon color
                size: 40.0, // Icon size
              ),
            SizedBox(height: 8.0), // Add space between the icon and the text
          ],
          if (value == 1) ...[ // Adjust the size of the circle
              Icon(
                Icons.assistant, // QR code icon
                color: Colors.white, // Icon color
                size: 40.0, // Icon size
              ),
            SizedBox(height: 8.0), // Add space between the icon and the text
          ],
          Text(
            message,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0, // Font size
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0, // Added letter spacing for readability
              height: 1.4, // Adjusted line height for better spacing between lines
            ),
            textAlign: TextAlign.center, // Center the text for better layout
          ),
        ],
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blueAccent,
      title: Center(
        child: Text(
          "Locker Managment",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0, // Font size
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              changeSubHead(),
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