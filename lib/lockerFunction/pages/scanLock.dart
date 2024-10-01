import 'package:flutter/material.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/home.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/service/database.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanLock extends StatefulWidget {
  const ScanLock({super.key});

  @override
  State<ScanLock> createState() => _ScanLockState();
}

class _ScanLockState extends State<ScanLock> {
  String scanResult = '';
  String userID = '';
  final MobileScannerController cameraController = MobileScannerController();

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');  // Retrieve the userID

    setState(() {
      userID = '$userId';  // Update the userID in the state
    });
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: Icon(cameraController.torchEnabled
                ? Icons.flash_on
                : Icons.flash_off),
            color: Colors.white,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => cameraController.switchCamera(), // Switch camera without needing cameraFacing getter
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                final String? barcode = barcodes.isNotEmpty
                    ? barcodes.first.rawValue
                    : null;
                if (barcode != null) {
                  setState(() {
                    scanResult = barcode;
                  });
                  cameraController.stop(); // Stop scanning when QR is detected
                  _showConfirmationDialog(context, barcode);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Scan Result: $scanResult',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String barcode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code Detected'),
          content: Text('Do you want to proceed with this code: $barcode?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                reserveLock(barcode, userID);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(), // Navigate to scanLock page
                  ),
                );
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                cameraController.start(); // Restart scanning on "No"
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}

void reserveLock(String barcode, String userID){
  DatabaseMethods().getEmptyLocksStream("P101").first.then((snapshot) {
    if (snapshot.docs.isNotEmpty) {
      // Retrieve the first lock's lockId
      String lockId = snapshot.docs.first.get('lockid');

      // Now update the lock details with the lockId and barcode
      DatabaseMethods().updateLockDetails(lockId, barcode, '');
      DatabaseMethods().createNotification(userID, lockId);
    } else {
      // Handle case when no empty locks are available
      print("No empty locks available for lockerId");
    }
  }).catchError((error) {
    // Handle any errors
    print("Error retrieving locks: $error");
  });
}