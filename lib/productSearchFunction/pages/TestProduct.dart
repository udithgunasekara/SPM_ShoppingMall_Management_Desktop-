import 'package:flutter/material.dart';
import 'productpage.dart'; // Import the ProductPage

class TestProduct extends StatefulWidget {
  const TestProduct({super.key});

  @override
  State<TestProduct> createState() => _TestProductState();
}

class _TestProductState extends State<TestProduct> {
  final TextEditingController _idController =
      TextEditingController(); // Controller for the input field

  @override
  void dispose() {
    _idController
        .dispose(); // Dispose of the controller when the widget is disposed
    super.dispose();
  }

  void _submit() {
    final productId = _idController.text.trim(); // Get the entered product ID
    if (productId.isNotEmpty) {
      // Navigate to the ProductPage and pass the entered product ID
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductPage(docId: productId),
        ),
      );
    } else {
      // Show a simple alert if the input field is empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please enter a valid product ID.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Product ID'),
        backgroundColor: Colors.brown[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Product ID:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller:
                  _idController, // Attach the controller to the input field
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter product ID here',
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed:
                    _submit, // Call the submit method when the button is pressed
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  backgroundColor: Colors.black, // Button color
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
