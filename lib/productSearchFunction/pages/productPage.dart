import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import 'package:spm_shoppingmall_mobile/productSearchFunction/pages/wishList.dart';

import '../services/firestore.dart';

class ProductPage extends StatefulWidget {
  final String docId;

  const ProductPage({required this.docId, super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final FirestoreService firestoreService = FirestoreService();
  final CollectionReference productStore =
      FirebaseFirestore.instance.collection('Store Products');

  Map<String, dynamic>? productData;
  bool isLoading = true;
  String selectedSize = '';
  String selectedColor = '';

  @override
  void initState() {
    super.initState();
    fetchProductData();
  }

  Future<void> fetchProductData() async {
    try {
      DocumentSnapshot doc = await productStore.doc(widget.docId).get();
      setState(() {
        productData = doc.data() as Map<String, dynamic>;
        isLoading = false;
        if (productData!['sizes'].isNotEmpty) {
          selectedSize = productData!['sizes'][0];
        }
        if (productData!['color'].isNotEmpty) {
          selectedColor = productData!['color'][0];
        }
      });
    } catch (e) {}
  }

  Future<void> handleAddToCart() async {
    // Implement add to cart functionality
    await firestoreService.addToWishlist(widget.docId); // Add to wishlist
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Wishlist(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to Wishist')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Center(
          child: Text(
            'Product Details',
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.w400),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : productData == null
              ? const Center(child: Text('Product not found!'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Carousel
                      FlutterCarousel(
                        options: CarouselOptions(
                          height: 500.0,
                          showIndicator: true,
                          slideIndicator: const CircularSlideIndicator(
                            slideIndicatorOptions: SlideIndicatorOptions(
                              itemSpacing: 10,
                              indicatorRadius: 5,
                              currentIndicatorColor:
                                  Color.fromARGB(255, 255, 255, 255),
                              indicatorBackgroundColor:
                                  Color.fromARGB(255, 102, 0, 150),
                            ),
                          ),
                        ),
                        items: (productData!['images'] as List<dynamic>)
                            .map((imageUrl) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Image.network(
                                imageUrl,
                                fit: BoxFit.contain,
                              );
                            },
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  productData!['category'],
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                Row(
                                  children: [
                                    Text(productData!['brand'],
                                        style: const TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 1),
                            Text(
                              productData!['title'],
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Product Details',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              productData!['description'],
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 122, 122, 122)),
                            ),
                            const SizedBox(height: 8),
                            const Divider(
                                color: const Color.fromARGB(255, 82, 82, 82)),
                            const SizedBox(height: 8),
                            const Text(
                              'Available Sizes',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: double
                                  .infinity, // Ensures the Wrap takes the full width
                              child: Wrap(
                                spacing: 10,
                                alignment: WrapAlignment.spaceAround,
                                children: productData!['sizes']
                                    .map<Widget>(
                                        (sizes) => _buildSizeButton(sizes))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Available Colors',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 20,
                              children: productData!['color']
                                  .map<Widget>(
                                      (color) => _buildColorCircle(color))
                                  .toList(),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Ensure space between price and button
                              children: [
                                // Total Price section (in a column to display both texts vertically)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Align text to the left
                                  children: [
                                    const Text(
                                      'Price: ',
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            4), // Small space between text and price
                                    Text(
                                      "\$${productData!['price']}",
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 152, 11, 0),
                                      ),
                                    ),
                                  ],
                                ),

                                // Add to Cart button
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.shopping_bag_outlined,
                                      color: Colors.white),
                                  label: const Text(
                                    'Add to Wish List',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.brown, // Button color
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Rounded corners
                                    ),
                                  ),
                                  onPressed: handleAddToCart,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSizeButton(String size) {
    bool isSelected = selectedSize == size;
    return GestureDetector(
      child: Card(
        color: Colors.brown,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            size,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorCircle(String color) {
    Color actualColor = _getColorFromString(color);
    //bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: actualColor,
        ),
      ),
    );
  }

  Color _getColorFromString(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      case 'brown':
        return Colors.brown;
      case 'grey':
        return Colors.grey;
      case 'black':
        return Colors.black;
      default:
        return Colors.grey; // Default color
    }
  }
}
