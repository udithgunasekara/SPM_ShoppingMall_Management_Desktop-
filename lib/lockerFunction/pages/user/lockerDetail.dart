import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/service/database.dart';

Widget allLockerDetail(Stream<QuerySnapshot>? lockerStream, String tranferLockId, String userID) {
  return StreamBuilder<QuerySnapshot>(
    stream: lockerStream,
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Text("Error: ${snapshot.error}");
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Text("No lockers available.");
      }

      return Column(
        children: [
          // Add your text widget here
          Container(
            width: 300.0, // Set a specific width less than the parent width
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "Available Lockers",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0, // Font size
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0, // Added letter spacing for readability
                height: 1.4, // Adjusted line height for better spacing between lines
              ),
              textAlign: TextAlign.center, // Center the text for better layout
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                String lockerId = ds["lockerid"];

                return InkWell(
                  onTap: () {
                    showLocksOfLockerPopup(context, lockerId, tranferLockId, userID);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Location: " + ds["location"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ds["level"] + " floor",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: DatabaseMethods().getEmptyLocksStream(lockerId),
                              builder: (context, AsyncSnapshot<QuerySnapshot> lockSnapshot) {
                                if (lockSnapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                if (lockSnapshot.hasError) {
                                  return Text("Error: ${lockSnapshot.error}");
                                }
                                if (lockSnapshot.hasData) {
                                  int emptyLockCount = lockSnapshot.data!.docs.length;
                                  if (emptyLockCount != 0) {
                                    return Text(
                                      "$emptyLockCount Empty Locks Left",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      "$emptyLockCount Empty Locks Left",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                }
                                return Text(
                                  "No Locks Available",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}


void showLocksOfLockerPopup(BuildContext context, String lockerId, String tranferLockId, String userID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Locks in Locker $lockerId"),
          content: StreamBuilder<QuerySnapshot>(
            stream: DatabaseMethods().getEmptyLocksStream(lockerId),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text("No locks available.");
              }
              return Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot lockData = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text("Lock ID: ${lockData['lockid']}"),
                      subtitle: Text("Status: ${lockData['isempty']}"),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog(context, lockData['lockid'], tranferLockId, userID);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),
                        child: Text(
                          "Pick",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

void _showConfirmationDialog(BuildContext context, String lockId, String tranferLockId, String userID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Action"),
          content:
              Text("Are you sure you want to pick this lock (ID: $lockId)?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () {
                print("Updating lock ID: $lockId");
                DatabaseMethods().updateLockDetails(lockId, userID, tranferLockId);
                DatabaseMethods().updateTransferLocker(tranferLockId);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  