import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/widget/giftcard_widget.dart';

class ClaimedGiftCardsPage extends StatefulWidget {
  const ClaimedGiftCardsPage({super.key});

  @override
  State<ClaimedGiftCardsPage> createState() => _ClaimedGiftCardsPageState();
}

class _ClaimedGiftCardsPageState extends State<ClaimedGiftCardsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> fetchClaimedGiftCards() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    // Fetch claimed gift cards from the user's giftcards collection
    QuerySnapshot giftCardsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('giftcards')
        .get();

    // List to store detailed gift card information
    List<Map<String, dynamic>> detailedGiftCards = [];

    for (var doc in giftCardsSnapshot.docs) {
      String giftCardId = doc['giftCardId'];
      DateTime claimedDate = doc['claimedDate'].toDate();

      // Fetch gift card details from the main giftcard collection using giftCardId
      DocumentSnapshot giftCardDoc = await _firestore
          .collection('giftcard')
          .doc(giftCardId)
          .get();

      if (giftCardDoc.exists) {
        // Add the gift card details along with claimed date
        Map<String, dynamic> giftCardData = giftCardDoc.data() as Map<String, dynamic>;
        giftCardData['claimedDate'] = claimedDate; // Add claimed date from user's collection
        giftCardData['id'] = giftCardId; // Add claimed date from user's collection
        detailedGiftCards.add(giftCardData);
      }
    }

    return detailedGiftCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Claimed Giftcards',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        elevation: 16,
        shadowColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 0, 0, 0),
          weight: 60,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchClaimedGiftCards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No claimed gift cards'));
          }

          List<Map<String, dynamic>> giftcards = snapshot.data!;

          return ListView.builder(
            itemCount: giftcards.length,
            itemBuilder: (context, index) {
              final giftcard = giftcards[index];
              return GiftCardWidget(giftCard: giftcard);
            },
          );
        },
      ),
    );
  }
}