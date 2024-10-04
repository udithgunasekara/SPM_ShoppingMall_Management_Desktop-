import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/service/database.dart';

Widget packagesInTheProgress(){
  return StreamBuilder<QuerySnapshot>(
                stream: DatabaseMethods().getallTransferLocker(),
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
                        pickupLockid: item['tolockid'],
                        password: item['userid'],
                        color: Colors.blue, // Adjust color as per your logic
                      );
                    },
                  );
                },
              );
}

Widget _buildLockerItem({
  required String lockid,
  required String pickupLockid,
  required String password,
  required Color color,
}) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      leading: Container(
        width: 5,
        color: color,
      ),
      title: Text("Transfer To " + pickupLockid),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Password: $password', style: TextStyle(color: Colors.black54)),
          Text('Transfer In Progress', style: TextStyle(color: Colors.green)),
        ],
      ),
      trailing: TextButton(
        onPressed: () {
          DatabaseMethods().releaseTranferLocker(lockid);
        },
        child: Text('Done'),
      ),
    ),
  );
}