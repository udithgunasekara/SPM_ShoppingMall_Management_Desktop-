import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getLockerDetails() async {
    return await FirebaseFirestore.instance.collection("Locker").snapshots();
  }

  Future<String> getImageUrl(String path) async {
    try {
      final Reference storageRef = FirebaseStorage.instance.ref().child(path);
      final String url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      print('Error getting image URL: $e');
      return ''; // Return an empty string or handle as needed
    }
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

  Stream<QuerySnapshot> getEmptyLocksStream(String lockerId) {
    return FirebaseFirestore.instance
        .collection("Locks")
        .where("lockerid", isEqualTo: lockerId)
        .where("isempty", isEqualTo: true)
        .snapshots();
  }

  String _generatePin() {
    final _random = Random();
    return List.generate(6, (index) => _random.nextInt(10)).join();
  }

  Future<void> updateLockDetails(String lockid, String userId, String tranferLockId) async {
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
          'picklockid': tranferLockId
        });
      }

      print("Lock details updated successfully.");
    } catch (e) {
      print("Error updating lock details: $e");
    }
  }

  Future<void> createNotification(String userId, String lockId) async {
    try {
      // Create a new document in the "Notification" collection
      await FirebaseFirestore.instance.collection("TransferLocker").doc().set({
        'isread': false,
        'userid': userId,
        'lockid': lockId,
      });
      
      print("Notification created successfully.");
    } catch (e) {
      print("Error creating notification: $e");
    }
  }

  Future<void> updateTransferLocker(String lockId) async {
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
        "isread": true, // Example field to update, you can add more fields here
      });
      print("Transfer locker updated successfully.");
    } else {
      print("No transfer locker found with the provided lockId.$lockId");
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
}
