import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //fetch user details from Firestore
  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
       debugPrint('Error fetching user details: $e');
      return null;
    }
  }

  //fetch bill details from firestore
  Future<Map<String,dynamic>?> getBillDetails(String billNo) async{
    try{
      DocumentSnapshot doc = await _firestore.collection('bills').doc(billNo).get();
      return doc.data() as Map<String,dynamic>?;
    }catch(e){
      debugPrint('Error fetching bill details: $e');
      return null;
    }
  }

  //update user loyalty points
  Future<int> updateLoyaltyPoints(String uid, double amount , String billNumber) async{
    try{
      DocumentReference userRef = _firestore.collection('users').doc(uid);

      // Calculate loyalty points: 1 point for every 10 dollars
      int pointsToAdd = (amount / 10).floor();

      //user transaction to safely update points and claimed status
      await _firestore.runTransaction((transaction) async{
        DocumentSnapshot userSnapshot = await transaction.get(userRef);
        
        //calculate updated loyalty points
        int currentPoints = userSnapshot['loyaltyPoints']??0;
        int updatedPoints = currentPoints + pointsToAdd;

        //update user loyalty points
        transaction.update(userRef, {'loyaltyPoints': updatedPoints});

        //mark bill as claimed
        DocumentReference billRef = _firestore.collection('bills').doc(billNumber);
        transaction.update(billRef, {'claimed': true});
      });
      
      return pointsToAdd;
      
    }catch(e){
      debugPrint('Error updating loyalty points: $e');
      return 0; // Return a default value in case of error
    }
  }
}