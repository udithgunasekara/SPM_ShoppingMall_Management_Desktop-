import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  // Image URL
  Future<String>? imageUrlFuture;

  String? tranferLockId;

  getOnTheLoad() async {
    lockerStream = await DatabaseMethods().getLockerDetails();
    equippedLockerStream = await DatabaseMethods().getEquippedLocker("C001");
    transferlocker = DatabaseMethods().getTransferLocker("C001");
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

  String? getFirstLockId() {
    return tranferLockId;
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  //Display All locker and its details
  Widget allLockerDetails(String tranferLockId) {
    return allLockerDetail(lockerStream, tranferLockId);
  }

  //Display Equipped locker and its details
  Widget equippedLockerDetails() {
    return equippedLocks(lockerStream);
  }

  switchPanel(int value) {
  if (value == 1) {
    if (tranferLockId != null) {
      return allLockerDetails(tranferLockId!);
    } else {
      return Center(
        child: Text(
          "Scan QR to unlock a locker",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  } else {
    return equippedLockerDetails();
  }
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
              "Scan QR to unlock a locker ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Display the image below the "Pick a Locker" text
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
          SizedBox(height: 10.0), // Space between buttons and image

          // Display equipped locks block
          SizedBox(height: 10.0), // Space between buttons
          // Row to display buttons horizontally
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    value == 1
                        ? Colors.black // Change to black when pressed
                        : Colors.white, // Default green color
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
                    Text(
                      " Pick a Locker",
                      style: TextStyle(
                        color: value == 1 ? Colors.white : Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 0.0), // Space between buttons
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    value == 0
                        ? Colors.black // Change to black when pressed
                        : Colors.white, // Default green color
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
                      "your lockers ",
                      style: TextStyle(
                        color: value == 0 ? Colors.white : Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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