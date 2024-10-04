import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:spm_shoppingmall_mobile/productSearchFunction/pages/productPage.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  void initState() {
    super.initState();
    startBarcodeScan(); // Automatically start scanning when the page opens
  }

  // Method to start the barcode scanning process
  Future<void> startBarcodeScan() async {
    try {
      String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", // Color for the scanning line
        "Cancel", // Button text to cancel the scan
        true, // Whether to show a flash icon
        ScanMode.BARCODE, // Scan mode for barcode
      );

      if (barcodeResult == "-1") {
        // Navigate to home if the user cancels the scan
        Navigator.pushNamed(context, '/home');
        return;
      }

      if (barcodeResult != "-1") {
        // Move to ProductPage with the scanned barcode
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(docId: barcodeResult),
          ),
        );
      }
    } catch (e) {
      // Handle any error during the scan process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to scan barcode: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barcode Scanner"),
        backgroundColor: Colors.brown[400],
      ),
      body: Center(
        child:
            const CircularProgressIndicator(), // Show a loading indicator while scanning
      ),
    );
  }
}
