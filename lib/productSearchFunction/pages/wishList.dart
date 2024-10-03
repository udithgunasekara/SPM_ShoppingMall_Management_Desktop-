import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spm_shoppingmall_mobile/productSearchFunction/services/firestore.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final FirestoreService firestoreService = FirestoreService();

  Future<List<DocumentSnapshot>> fetchWishlistProducts() async {
    List<String> productIds = await firestoreService.fetchWishlistProductIds();
    return await firestoreService.fetchProductsByIds(productIds);
  }

  Future<void> removeProductFromWishlist(String productId) async {
    await firestoreService.removeFromWishlist(productId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Wishlist',
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.w400),
          ),
        ),
        backgroundColor: Colors.brown[600],
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchWishlistProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error fetching wishlist"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<DocumentSnapshot> wishlistProducts = snapshot.data!;

            return ListView.builder(
              itemCount: wishlistProducts.length,
              itemBuilder: (context, index) {
                var product = wishlistProducts[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to product details if necessary
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.network(
                            product['images'][0],
                            width: 120,
                            height: 120,
                            fit: BoxFit
                                .cover, // Image fills one side of the card
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Price: \$${product['price']}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon:
                                        const Icon(Icons.remove_shopping_cart),
                                    color: const Color.fromARGB(255, 132, 2, 0),
                                    onPressed: () {
                                      removeProductFromWishlist(product.id);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No products in your wishlist"));
          }
        },
      ),
    );
  }
}
