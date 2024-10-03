import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/widget/giftcard_widget.dart';

class GiftCardAndLoyaltyPage extends StatefulWidget {
  const GiftCardAndLoyaltyPage({super.key});

  @override
  State<GiftCardAndLoyaltyPage> createState() => _GiftCardAndLoyaltyPageState();
}

class _GiftCardAndLoyaltyPageState extends State<GiftCardAndLoyaltyPage> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  List<bool> isSelected = [true, false];

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
      String uniqueid = doc.id;
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
        giftCardData['uniqueid'] = uniqueid; // Add claimed date from user's collection
        detailedGiftCards.add(giftCardData);
      }
    }

    return detailedGiftCards;
  }

  //fetch loyalty cards
  Future<Map<String,dynamic>?> fetchLoyaltyPoints() async {
    final userId = _auth.currentUser?.uid;
    if(userId == null) return null;

    DocumentSnapshot loyaltyDoc = await _firestore
        .collection('users')
        .doc(userId)
        .get();

    if(loyaltyDoc.exists){
      return loyaltyDoc.data() as Map<String,dynamic>;
    }else{
      return null;
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 16,
        shadowColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.black,
          weight: 60,
        ),
        title: Center(
          child: Container(
          padding: EdgeInsets.all(4.0),
          child: ToggleButtons(
            borderRadius: BorderRadius.circular(30.0),
            fillColor: const Color.fromARGB(255, 0, 0, 0),
            selectedColor: const Color.fromARGB(255, 255, 255, 255),
            color: const Color.fromARGB(136, 0, 26, 255),
            borderColor: Colors.transparent,
            selectedBorderColor: Colors.transparent,
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < isSelected.length; i++) {
                  isSelected[i] = i == index;
                  _selectedIndex = index;
                }
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Gift Cards',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected[0] ? FontWeight.bold : FontWeight.normal,
                  ),
                  ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Loyalty Points',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected[0] ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
      body: _selectedIndex == 0 ? buildGiftCardsView() : buildLoyaltyPointsView(),
    );
  }

  // Build the Gift Cards View
  Widget buildGiftCardsView() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchClaimedGiftCards(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No claimed gift cards'));
        }

        List<Map<String, dynamic>> giftcards = snapshot.data!;
        return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'You claimed gift cards:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: giftcards.length,
              itemBuilder: (context, index) {
                final giftcard = giftcards[index];
                return GiftCardWidget(giftCard: giftcard);
              },
            ),
          ),
        ],
      );
      },
    );
  }

  // Build the Loyalty Points View
  Widget buildLoyaltyPointsView() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchLoyaltyPoints(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No loyalty points available'));
        }

        final loyaltyData = snapshot.data!;
        final totalPoints = loyaltyData['loyaltyPoints'] ?? 0;
        final loyaltyId =  _auth.currentUser?.uid ?? 'Unavailable';

        return Center(
          child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your total loyalty points: $totalPoints',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Your loyalty point ID:\n$loyaltyId',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Text(
                "Add more loyalty points by entering your bill number below:",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                  // Add logic to navigate to add bill page
                  Navigator.pushNamed(context, '/billentry');
                },
                  child: const Text(
                    'Add Loyalty Points',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              
            ],
          ),
          ),
        );
      },
    );
  }
  }
