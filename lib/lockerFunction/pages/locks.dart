import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/service/database.dart';

Widget equippedLocks(Stream<QuerySnapshot>? equippedLockersStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: equippedLockersStream,
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

      // List to hold lockers that have locks
      List<DocumentSnapshot> lockersWithLocks = [];

      return FutureBuilder<void>(
        future: Future.wait(snapshot.data!.docs.map((ds) async {
          // Fetch locks for the current locker
          QuerySnapshot lockSnapshot = await DatabaseMethods().getEquippedLockers("C001", ds["lockerid"]).first;
          
          if (lockSnapshot.docs.isNotEmpty) {
            // If there are locks, add the locker to the list
            lockersWithLocks.add(ds);
          }
        })),
        builder: (context, AsyncSnapshot<void> lockSnapshot) {
          if (lockSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (lockSnapshot.hasError) {
            return Text("Error: ${lockSnapshot.error}");
          }
          if (lockersWithLocks.isEmpty) {
            return Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "you have not equppied lock",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
          }

          return ListView.builder(
            itemCount: lockersWithLocks.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = lockersWithLocks[index];

              return Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Location: ${ds["location"]}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Level: ${ds["level"]}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        FutureBuilder<QuerySnapshot>(
                          future: DatabaseMethods().getEquippedLockers("C001", ds["lockerid"]).first,
                          builder: (context, AsyncSnapshot<QuerySnapshot> lockSnapshot) {
                            if (lockSnapshot.connectionState == ConnectionState.waiting) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (lockSnapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text("Error: ${lockSnapshot.error}"),
                              );
                            }
                            if (lockSnapshot.hasData) {
                              if (lockSnapshot.data!.docs.isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: lockSnapshot.data!.docs.map((lockDoc) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Text(
                                        "Lock ID: ${lockDoc["lockid"]} \t\t\t\t\t\t\t\t password: ${lockDoc["password"]}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ), 
                                      ),
                                    );
                                  }).toList(),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "No empty locks available",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                );
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "No locks available",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}