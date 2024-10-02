import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/service/database.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/lockerDetail.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/Locks.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/scanLock.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int value = 1;
  int _selectedIndex = 0;
  Stream<QuerySnapshot>? lockerStream;
  Stream<QuerySnapshot>? equippedLockerStream;
  Stream<QuerySnapshot>? transferlocker;
  Future<String>? imageUrlFuture;
  String? tranferLockId;
  String? userID;

  Future<void> _loadUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loadedUserId = prefs.getString('userID');
    setState(() {
      userID = loadedUserId;
    });
    getOnTheLoad(); // Fetch data after loading user ID
  }

  Future<void> getOnTheLoad() async {
    lockerStream = await DatabaseMethods().getLockerDetails();
    equippedLockerStream = await DatabaseMethods().getEquippedLocker('$userID');
    transferlocker = DatabaseMethods().getTransferLocker('$userID');
    imageUrlFuture = DatabaseMethods().getImageUrl('QR/user.png'); // Example image path in Firebase Storage

    transferlocker?.listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        tranferLockId = snapshot.docs.first.get('lockid');
      } else {
        tranferLockId = null; // Handle if no documents are available
      }
      setState(() {}); // Update UI after fetching lock ID
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadUserID();
  }

  //Display All locker and its details
  Widget allLockerDetails(String tranferLockId) {
    return allLockerDetail(lockerStream, tranferLockId, '$userID');
  }

  //Display Equipped locker and its details
  Widget equippedLockerDetails() {
    return equippedLocks(lockerStream, '$userID');
  }

  switchPanel(int value) {
    if (value == 1) {
      if (tranferLockId != null) {
        return allLockerDetails(tranferLockId!);
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.0), // Space between text and image
            FutureBuilder<String>(
              future: imageUrlFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Display error message and log error
                  print('Error loading image: ${snapshot.error}');
                  return Center(child: Text('Error loading image'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No image available'));
                } else {
                  return Center(
                    child: Image.network(
                      snapshot.data!,
                      height: 250, // Adjust height according to your needs
                      fit: BoxFit.cover,
                    ),
                  );
                }
              },
            ),
            Text(
              "Scan Me",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      }
    } else {
      return equippedLockerDetails();
    }
  }

 

  Widget changeSubHead() {
    String message;

    if (tranferLockId == null && value == 1) {
      message = "Scan the below QR code to store your goods in locker";
    } else if(tranferLockId != null && value == 1) {
      message = "You have received $tranferLockId locker. Pick a pickup locker to transfer your goods";
    } else{
      message = "Warning:This screen shows equipped locks and their passwords. Do not share this information";
    }

    return Container(
      width: 300.0,
      height: 180.0, // Set a specific width less than the parent width
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          // Conditionally show the icon if tranferLockId is not null
          if (tranferLockId != null && value == 1) ...[
            CircleAvatar(
              backgroundColor: Colors.green,
              radius: 20.0, // Adjust the size of the circle
              child: Icon(
                Icons.check, // Check icon
                color: Colors.white, // Icon color
                size: 20.0, // Icon size
              ),
            ),
            SizedBox(height: 8.0), // Add space between the icon and the text
          ],
          if (value == 0) ...[ // Adjust the size of the circle
              Icon(
                Icons.warning, // QR code icon
                color: Colors.white, // Icon color
                size: 40.0, // Icon size
              ),
            SizedBox(height: 8.0), // Add space between the icon and the text
          ],
          // Conditionally show the QR icon if tranferLockId is null
          if (tranferLockId == null && value == 1) ...[ // Adjust the size of the circle
              Icon(
                Icons.qr_code_scanner_rounded, // QR code icon
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

     if (index == 2) { // If "Profile" is selected
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => const ScanLock(), // Navigate to scanLock page
       ),
     );
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to Locker Picker",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0, // Font size
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          
          SizedBox(height: 30.0),
          changeSubHead(), // Space between buttons and image
          SizedBox(height: 50.0), // Space between buttons
          // Row to display buttons horizontally
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    value == 1 ? Colors.black : Colors.white, // Change to black when pressed
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),  // Customize top-left corner
                        bottomLeft: Radius.circular(20.0), // Customize bottom-left corner
                        topRight: Radius.circular(0.0),   // Set top-right corner to zero
                        bottomRight: Radius.circular(0.0), // Set bottom-right corner to zero
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
                  mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum space
                  children: [
                    Icon(
                      Icons.lock_open_outlined,
                      color: value == 1 ? Colors.white : Colors.black, // Icon color based on state
                    ),
                    SizedBox(width: 4.0), // Added space between icon and text
                    Text(
                      "Pick a Locker",
                      style: TextStyle(
                        color: value == 1 ? Colors.white : Colors.black,
                        fontSize: 16.0, // Increased font size
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0, // Added letter spacing
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 0.0), // Space between buttons
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    value == 0 ? Colors.black : Colors.white, // Change to black when pressed
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0.0),  // Customize top-left corner
                        bottomLeft: Radius.circular(0.0), // Customize bottom-left corner
                        topRight: Radius.circular(20.0),   // Set top-right corner to zero
                        bottomRight: Radius.circular(20.0), // Set bottom-right corner to zero
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
                  mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum space
                  children: [
                    Text(
                      "Your Lockers",
                      style: TextStyle(
                        color: value == 0 ? Colors.white : Colors.black,
                        fontSize: 16.0, // Increased font size
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0, // Added letter spacing
                      ),
                    ),
                    SizedBox(width: 4.0), // Added space between text and icon
                    Icon(
                      Icons.lock_outlined,
                      color: value == 0 ? Colors.white : Colors.black, // Icon color based on state
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Container with rounded top corners and full width
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // Changes position of shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.0),
              child: switchPanel(value), // This widget should also be set up correctly
            ),
          ),
        ],
      ),

      // Add Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shopping',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}