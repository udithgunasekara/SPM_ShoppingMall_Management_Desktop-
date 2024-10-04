import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/service/database.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/user/lockerDetail.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/user/Locks.dart';

class LockerHome extends StatefulWidget {
  const LockerHome({super.key});

  @override
  State<LockerHome> createState() => _LockerHomeState();
}

class _LockerHomeState extends State<LockerHome> {
  int value = 1;
  int _selectedIndex = 0;
  Stream<QuerySnapshot>? lockerStream;
  Stream<QuerySnapshot>? equippedLockerStream;
  Stream<QuerySnapshot>? transferlocker;
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

  Widget switchPanel(int value) {
    if (value == 1) {
      if (tranferLockId != null) {
        return allLockerDetails(tranferLockId!);
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.0), // Space between text and image
            if (userID != null && userID!.isNotEmpty)
              Container(
                width: double.infinity, // Make the container take the full width of its parent
                height: 250.0, // Set the desired height for the QR code
                child: Center( // Center the QR code within the container
                  child: QrImageView(
                    data: userID!,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                    version: QrVersions.auto,
                    gapless: true,
                  ),
                ),
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
      Navigator.pushReplacementNamed(context, '/lockerManagment');
    }
    if (index == 0) { // If "Profile" is selected
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _showNotifications(BuildContext context, Offset offset, String userId) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        0,
      ),
      items: [
        PopupMenuItem(
          child: StreamBuilder<QuerySnapshot>(
            stream: DatabaseMethods().getaNotification(userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var notifications = snapshot.data!.docs;

              // Sort notifications: unread first, then read
              notifications.sort((a, b) {
                bool isReadA = a['isread'] ?? true;
                bool isReadB = b['isread'] ?? true;
                return isReadA == isReadB ? 0 : isReadA ? 1 : -1;
              });

              if (notifications.isEmpty) {
                return Text('No new notifications.');
              }
              return Container(
                width: 300.0,
                height: 200.0, // Limit the height of the notification popup
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    var notification = notifications[index];
                    bool isRead = notification['isread'] ?? true;

                    return Card(
                      color: isRead ? Colors.white : Colors.lightBlue[100],
                      child: ListTile(
                        title: Text(
                          isRead ? 'Notification' : 'New Notification',
                          style: TextStyle(
                            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                            color: isRead ? Colors.black : Colors.blueAccent,
                          ),
                        ),
                        subtitle: Text(notification['message'] ?? 'No Message'),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    ).then((_) {
      // Mark notifications as read after the menu is closed
      DatabaseMethods().makeNotificationRead(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Center(
            child: Text(
              "Welcome to Locker Picker",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTapUp: (TapUpDetails details) {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                Offset offset = renderBox.localToGlobal(details.globalPosition);
                _showNotifications(context, offset, '$userID'); // Show notifications popup near the icon
              },
              child: Icon(Icons.notifications),
            ),
          ],
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
                  offset: Offset(0, 3), // Changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap the height to fit the content
              children: [
                changeSubHead(), // Space between buttons and image
                SizedBox(height: 16.0), // Optional space above buttons
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
                          value = 1; // Set the value to 1 when pressed
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Ensure the row takes minimum space
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
                    ), // Space between buttons
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
                          value = 0; // Set the value to 0 when pressed
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Ensure the row takes minimum space
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
                ), // End of button row
              ],
            ),
          ),
          Container(child: Expanded(child: switchPanel(value)),),
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