import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getLockerDetails() async {
    return await FirebaseFirestore.instance.collection("Locker").snapshots();
  }

  Future<Stream<QuerySnapshot>> getEquippedLocker(String userId) async {
    return await FirebaseFirestore.instance
        .collection("Locks")
        .where("userid", isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getEquippedLockers(String userId, String lockerId) {
    return FirebaseFirestore.instance
        .collection("Locks")
        .where("userid", isEqualTo: userId)
        .where("lockerid", isEqualTo: lockerId)
        .snapshots();
  }

  Stream<QuerySnapshot> getLockerId(String lockId) {
    return FirebaseFirestore.instance
        .collection("Locks")
        .where("lockid", isEqualTo: lockId)
        .snapshots();
  }

  Stream<QuerySnapshot> getEmptyLocksStream(String lockerId) {
    return FirebaseFirestore.instance
        .collection("Locks")
        .where("lockerid", isEqualTo: lockerId)
        .where("isempty", isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getEquippedLocksStream(String lockerId) {
    return FirebaseFirestore.instance
        .collection("Locks")
        .where("lockerid", isEqualTo: lockerId)
        .where("isempty", isEqualTo: false)
        .where("transferto", isNull: false)
        .where("transferfrom", isNull: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getLockerByLockerIdStream(String lockerId) {
    return FirebaseFirestore.instance
        .collection("Locker")
        .where("lockerid", isEqualTo: lockerId)
        .snapshots();
  }



  String _generatePin() {
    final _random = Random();
    return List.generate(6, (index) => _random.nextInt(10)).join();
  }

  Future<void> updateLockDetails(String lockid, String userId, String? tranferLockId) async {
    String pin = _generatePin();

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Locks")
          .where('lockid', isEqualTo: lockid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No document found with lockid $lockid.");
        return;
      }
      for (DocumentSnapshot document in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection("Locks")
            .doc(document.id)
            .update({
          'userid': userId,
          'isempty': false,
          'password': pin,
          'transferfrom': tranferLockId,
        });
      }

      print("Lock details updated successfully.");
    } catch (e) {
      print("Error updating lock details: $e");
    }
  }

  Future<void> updatePickupLockDetails(String lockid, String? tranferLockId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Locks")
          .where('lockid', isEqualTo: lockid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No document found with lockid $lockid.");
        return;
      }
      for (DocumentSnapshot document in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection("Locks")
            .doc(document.id)
            .update({
          'transferto': tranferLockId,
        });
      }

      print("Lock details updated successfully.");
    } catch (e) {
      print("Error updating lock details: $e");
    }
  }

  Future<void> releaseTranferLocker(String lockid) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Locks")
          .where('lockid', isEqualTo: lockid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No document found with lockid $lockid.");
        return;
      }
      for (DocumentSnapshot document in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection("Locks")
            .doc(document.id)
            .update({
          'userid': null,
          'isempty': true,
          'password': null,
          'transferfrom': null,
          'transferto': null,
        });
      }

      print("Lock details updated successfully.");
    } catch (e) {
      print("Error updating lock details: $e");
    }
  }

  Future<void> createTransferLocker(String userId, String lockId) async {
    try {
      // Create a new document in the "Notification" collection
      await FirebaseFirestore.instance.collection("TransferLocker").doc().set({
        'isread': false,
        'userid': userId,
        'lockid': lockId,
        'tolockid': null,
        'inprogress': false,
      });
      
      print("Notification created successfully.");
    } catch (e) {
      print("Error creating notification: $e");
    }
  }

  Future<void> updateTransferLocker(String lockId, String tolockId) async {
  try {
    // Query the collection to find documents where lockid matches the given value
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("TransferLocker")
        .where("lockid", isEqualTo: lockId)
        .where("isread", isEqualTo: false)
        .get();

    // Check if any documents were found
    if (snapshot.docs.isNotEmpty) {
      // Update the first matching document (assuming lockid is unique)
      await snapshot.docs.first.reference.update({
        "isread": true,
        "tolockid": tolockId,
      });
      print("Transfer locker updated successfully.");
    } else {
      print("No transfer locker found with the provided lockId.$lockId");
    }
  } catch (e) {
    print("Error updating transfer locker: $e");
  }
}

Future<void> updatestatusOfTransferLocker(String lockId, String tolockId, String userId) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("TransferLocker")
        .where("lockid", isEqualTo: lockId)
        .where("userid", isEqualTo: userId)
        .where("tolockid", isEqualTo: tolockId)
        .get();

    // Check if any documents were found
    if (snapshot.docs.isNotEmpty) {
      // Update the first matching document (assuming lockid is unique)
      await snapshot.docs.first.reference.update({
        "inprogress": true,
      });
      print("Transfer locker updated successfully.");
    } else {
      print("No transfer locker found with the provided lockId.$tolockId");
    }
  } catch (e) {
    print("Error updating transfer locker: $e");
  }
}



  Stream<QuerySnapshot> getTransferLocker(String userId) {
    return FirebaseFirestore.instance
        .collection("TransferLocker")
        .where("userid", isEqualTo: userId)
        .where("isread", isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getallTransferLocker() {
    return FirebaseFirestore.instance
        .collection("TransferLocker")
        .where("inprogress", isEqualTo: true)
        .snapshots();
  }

  Future<void> createNotification(String userId, String message, ) async {
    try {
      // Create a new document in the "Notification" collection
      await FirebaseFirestore.instance.collection("Notification").doc().set({
        'isread': false,
        'receiver': userId,
        'message': message,
      });
      
      print("Notification created successfully.");
    } catch (e) {
      print("Error creating notification: $e");
    }
  }

  Stream<QuerySnapshot> getaNotification(String userId) {
    return FirebaseFirestore.instance
        .collection("Notification")
        .where('receiver', isEqualTo: userId)
        .snapshots();
  }

  Future<void> makeNotificationRead(String userID) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Notification")
        .where("isread", isEqualTo: false)
        .where("receiver", isEqualTo: userID)
        .get();

    // Check if any documents were found
    if (snapshot.docs.isNotEmpty) {
      // Iterate through all matching documents and update each one
      for (var doc in snapshot.docs) {
        await doc.reference.update({
          "isread": true,
        });
      }
      print("All notifications updated successfully.");
    } else {
      print("No notifications found with the provided userID: $userID");
    }
  } catch (e) {
    print("Error updating notifications: $e");
  }
}

}
