import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/service/giftcard_service.dart';

class NotificationsPage extends StatefulWidget {

  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  List <Map<String,dynamic>> _notificaitons = [];
  bool _isloading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future <void> fetchNotifications() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return ;

    QuerySnapshot notificationsSnapshot = await _firestore
        .collection('notifications')
        .doc(userId)
        .collection('notifications')
        .where('claimed', isEqualTo: false) // Only fetch unclaimed gift cards
        .get();

    List<Map<String, dynamic>> notifications = notificationsSnapshot.docs
        .map((doc) => {
              'notificationId': doc.id,
              'message': doc['message'],
              'giftCardId': doc['giftCardId'],
              'claimDeadline': (doc['claimDeadline'] as Timestamp).toDate(),
            })
        .toList();


    setState(() {
      _notificaitons = notifications;
      _isloading = false;
    });
    
  }

  Future <void> claimNotification(String notificationId, String giftCardId) async {
    //call the service to claim the gift card
    await GiftcardService().claimGiftCard(notificationId, giftCardId, context);

    //remove the claimed notification from the list and update ui

    setState(() {
      _notificaitons.removeWhere(
        (notification) => notification['notificationId'] == notificationId
        );
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
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
      body: _isloading
          ? const Center(child: CircularProgressIndicator(),)
          :_notificaitons.isEmpty
            ?const Center(child: Text('No new Notifications'),)
            : ListView.builder(
                itemCount: _notificaitons.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context,index) {
                  final notification = _notificaitons[index];
                  return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12) //rounded corner
                    ),
                elevation: 5, //shadow depth
                color: const Color.fromARGB(255, 245, 231, 255),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //message text
                      Text(
                        notification['message'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),                       
                      ),
                      const SizedBox(height: 8,),

                      //claim deadline text
                      Text(
                        'Claim before : ${notification['claimDeadline']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.redAccent
                        ),

                      ),
                      const SizedBox(height: 12,),
                      //claim button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26)
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: () async {
                            await claimNotification(
                              notification['notificationId'],
                              notification['giftCardId'],
                            );
                          },
                          child: const Text(
                            'Claim',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                ),
              );
                }
              )

    );
  }
}