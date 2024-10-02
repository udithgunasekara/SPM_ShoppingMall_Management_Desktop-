import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GiftcardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> claimGiftCard(String notificationId, String giftCardId, BuildContext context) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    // Fetch the notification details including claimDeadline
    DocumentSnapshot notificationSnapshot = await _firestore
        .collection('notifications')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .get();

    if (!notificationSnapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notification not found.")),
      );
      return;
    }

    Map<String, dynamic> notificationData = notificationSnapshot.data() as Map<String, dynamic>;
    DateTime claimDeadline = (notificationData['claimDeadline'] as Timestamp).toDate();

    // Check if the claim deadline has passed
    DateTime currentDate = DateTime.now();
    if (currentDate.isAfter(claimDeadline)) {
      // Notify the user that the deadline has passed
      await _firestore
          .collection('notifications')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .delete();

      // Show a dialog to notify the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Claim Failed"),
            content: const Text("The deadline for claiming this gift card has passed."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    // Add the gift card to the user's claimed giftcards collection
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('giftcards')
        .doc(giftCardId)
        .set({
      'giftCardId': giftCardId,
      'claimedDate': Timestamp.now(),
    });

    // Delete the notification after successfully claiming the gift card
    await _firestore
        .collection('notifications')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .delete();

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gift card claimed successfully!")),
    );
  }
}