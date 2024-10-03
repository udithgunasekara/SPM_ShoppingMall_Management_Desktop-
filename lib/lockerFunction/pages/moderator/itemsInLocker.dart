import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/service/database.dart';

class ItemsInLocker extends StatefulWidget {
  final String lockerID;

  const ItemsInLocker({super.key, required this.lockerID});

  @override
  State<ItemsInLocker> createState() => _ItemsInLockerState();
}

class _ItemsInLockerState extends State<ItemsInLocker> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locker Items'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button action
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Locker Info Section - Dynamic Data from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: DatabaseMethods().getLockerByLockerIdStream(widget.lockerID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Locker information not found.'));
                }

                var lockerData = snapshot.data!.docs.first;

                return Container(
                  padding: EdgeInsets.all(16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Change to center alignment
                    children: [
                      Text(
                        'Locker ID',
                        style: TextStyle(color: Colors.black54, fontSize: 18.0),
                        textAlign: TextAlign.center, // Center the text
                      ),
                      Text(
                        lockerData['lockerid'], // Display locker ID from Firestore
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                        textAlign: TextAlign.center, // Center the text
                      ),
                      SizedBox(height: 8),
                      Text(
                        lockerData['level'] + ' floor '+ lockerData['location'], // Display locker location dynamically
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),
                        textAlign: TextAlign.center, // Center the text
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 24),
            Text(
              'Items in Locker',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Locker items list from Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: DatabaseMethods().getEquippedLocksStream(widget.lockerID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No items found in this locker.'));
                  }

                  // Retrieve the items from Firestore snapshot
                  var items = snapshot.data!.docs;

                  

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      return _buildLockerItem(
                        lockid: item['lockid'],
                        pickupLockid: item['transferto'],
                        password: item['password'],
                        userId: item['userid'],
                        color: Colors.blue, // Adjust color as per your logic
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display each locker item
  Widget _buildLockerItem({
  required String lockid,
  required String pickupLockid,
  required String password,
  required String userId,
  required Color color,
}) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: Container(
        width: 5,
        color: color,
      ),
      title: Text(lockid),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Password: $password', style: TextStyle(color: Colors.black54)),
          Text('Need to be transferred to $pickupLockid'),
        ],
      ),
      trailing: TextButton(
        onPressed: () {
          DatabaseMethods().updatestatusOfTransferLocker(lockid, pickupLockid, userId);
        },
        child: Text('Done'),
      ),
    ),
  );
}

}