
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign in with email and password
  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return 'Incorrect password';
      } else if (e.code == 'user-not-found') {
        return 'No user found with this email';
      }else if (e.code == 'invalid-credential') {
        return 'It seems you don\'t have account please sign up';
      } else {
        return e.code;
      }
    } catch (e) {
      return e.toString();
    }
  }

  //sign Up with email and password
  Future<String?> signUpWithEmailAndPassword(
      String email, String password, String name, String phone) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      //save additional details in firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'phone': phone,
          'email': email,
          'loyaltyPoints': 0,
          'role': 'user',
        });
      }
      return null; //no errors
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Email is already in use by another account';
      } else if (e.code == 'weak-password') {
        return 'The password provided is too weak';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  //sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign out failed : $e');
    }
  }
}