import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:spm_shoppingmall_mobile/productSearchFunction/pages/scannerPage.dart';

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
        if (productData!['colors'].isNotEmpty) {
          selectedColor = productData!['colors'][0];
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ScannerPage(),
            ),
          ),
        ),
        title: Text(
          'Product Details',
          style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontSize: 24,
              fontWeight: FontWeight.w400),
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
                        // options: CarouselOptions(
                        //   height: 500.0,
                        //   showIndicator: true,
                        //   slideIndicator: const CircularSlideIndicator(
                        //     slideIndicatorOptions: SlideIndicatorOptions(
                        //       itemSpacing: 10,
                        //       indicatorRadius: 5,
                        //       currentIndicatorColor:
                        //           Color.fromARGB(255, 255, 255, 255),
                        //       indicatorBackgroundColor:
                        //           Color.fromARGB(255, 102, 0, 150),
                        //     ),
                        //   ),
                        // ),

                        options: CarouselOptions(
                          height: 400.0,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          pauseAutoPlayOnTouch: true,
                          aspectRatio: 2.0,
                        ),
                        items: (productData!['images'] as List<dynamic>)
                            .map((imageUrl) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Image.network(
                                imageUrl,
                                fit: BoxFit.fitWidth,
                              );
                            },
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Category Text
                                Text(
                                  productData!['category'].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    letterSpacing:
                                        1.2, // Slight letter spacing for better readability
                                  ),
                                ),
                                // Brand Text
                                Text(
                                  productData!['brand'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Product Title
                            Text(
                              productData!['title'],
                              style: const TextStyle(
                                fontSize: 28, // Slightly larger for emphasis
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .black87, // Darker for better contrast
                              ),
                            ),
                            const SizedBox(
                                height: 12), // Add more space for clarity
                            // Section Header for "Product Details"
                            const Text(
                              'Product Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors
                                    .black54, // Subtle color for section header
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Product Description
                            Text(
                              productData!['description'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(
                                    0xFF7A7A7A), // Adjust the color to be softer
                                height:
                                    1.5, // Increased line height for readability
                              ),
                            ),
                            const SizedBox(height: 4),

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
                              children: productData!['colors']
                                  .map<Widget>(
                                      (colors) => _buildColorCircle(colors))
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
                                        color: Color.fromARGB(255, 192, 13, 0),
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
                                        Colors.purple, // Button color
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
    return GestureDetector(
      child: Card(
        color: Colors.purple[400],
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
