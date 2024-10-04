// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pizza_app/screens/auth/blocs/sing_in_bloc/sign_in_bloc.dart';
// import 'package:pizza_app/screens/home/blocs/get_pizza_bloc/get_pizza_bloc.dart';
// import 'package:pizza_app/screens/home/views/details_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         title: Row(
//           children: 
//             Image.asset('assets/8.png', scale: 14),
//             const SizedBox(width: 8),
//             const Text(
//               'PIZZA',
//               style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
//             )F
//           ],
//         ),
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.cart)),
//           IconButton(
//               onPressed: () {
//                 context.read<SignInBloc>().add(SignOutRequired());
//               },
//               icon: const Icon(CupertinoIcons.arrow_right_to_line)),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocBuilder<GetPizzaBloc, GetPizzaState>(
//           builder: (context, state) {
//             if(state is GetPizzaSuccess) {
//               return GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 9 / 16),
//                 itemCount: state.pizzas.length,
//                 itemBuilder: (context, int i) {
//                   return Material(
//                     elevation: 3,
//                     color: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(20),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute<void>(
//                             builder: (BuildContext context) => DetailsScreen(
//                               state.pizzas[i]
//                             ),
//                           ),
//                         );
//                       },
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Image.network(state.pizzas[i].picture),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     color: state.pizzas[i].isVeg
//                                       ? Colors.green
//                                       : Colors.red,
//                                     borderRadius: BorderRadius.circular(30)
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                                     child: Text(
//                                       state.pizzas[i].isVeg
//                                         ? "VEG"
//                                         : "NON-VEG",
//                                       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Container(
//                                   decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(30)),
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                                     child: Text(
//                                       state.pizzas[i].spicy == 1
//                                         ? "🌶️ BLAND"
//                                         : state.pizzas[i].spicy == 2
//                                           ? "🌶️ BALANCE"
//                                           : "🌶️ SPICY",
//                                       style: TextStyle(
//                                         color: state.pizzas[i].spicy == 1
//                                         ? Colors.green
//                                         : state.pizzas[i].spicy == 2
//                                           ? Colors.orange
//                                           : Colors.redAccent, 
//                                         fontWeight: FontWeight.w800, 
//                                         fontSize: 10
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                             child: Text(
//                               state.pizzas[i].name,
//                               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                             child: Text(
//                                state.pizzas[i].description,
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 color: Colors.grey.shade500,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       "\$${state.pizzas[i].price - (state.pizzas[i].price * (state.pizzas[i].discount) / 100)}",
//                                       style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
//                                     ),
//                                     const SizedBox(
//                                       width: 5,
//                                     ),
//                                     Text(
//                                       "\$${state.pizzas[i].price}.00",
//                                       style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w700, decoration: TextDecoration.lineThrough),
//                                     ),
//                                   ],
//                                 ),
//                                 IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.add_circled_solid))
//                               ],
//                             )
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//               );
//             } else if(state is GetPizzaLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else {
//               return const Center(
//                 child: Text(
//                   "An error has occured..."
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// --------------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';

// import '../services/firestore.dart';

// class productPage extends StatefulWidget {
//   const productPage({super.key});

//   @override
//   State<productPage> createState() => _ProductPageState();
// }

// class _ProductPageState extends State<productPage> {
//   //firestore
//   final FirestoreService firestoreService = FirestoreService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Product Details"),
//         backgroundColor: Colors.brown[400],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Product image
//             Center(
//               child: Image.network(
//                   'https://www-s.mlo.me/upen/vs/2024/202403/20240310/202403101837220777710.webp',
//                   height: 300,
//                   fit: BoxFit.cover),
//             ),
//             const SizedBox(height: 16),
//             // Category and Brand Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Kids",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                   color: Colors.black,
//                   child: const Text(
//                     "Brand",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             // Product Name
//             const Text(
//               "Product name",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             // Product description
//             const Text(
//               "Description: Here the description of the product",
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//             const SizedBox(height: 16),
//             // Sizes
//             const Text(
//               "Sizes",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 _buildSizeButton("M"),
//                 _buildSizeButton("L"),
//                 _buildSizeButton("XL"),
//                 _buildSizeButton("XXL"),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // Colors
//             const Text(
//               "Colors",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 _buildColorCircle(Colors.purple), // Purple Color
//                 const SizedBox(width: 10),
//                 _buildColorCircle(Colors.pink), // Pink Color
//                 const SizedBox(width: 10),
//                 _buildColorCircle(Colors.blue), // Blue Color
//                 const SizedBox(width: 10),
//                 _buildColorCircle(Colors.yellow), // Yellow Color
//               ],
//             ),
//             const SizedBox(height: 16),
//             // Metal and remaining stock info
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 Text(
//                   "Metal",
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "Remaining Stocks: 50",
//                   style: TextStyle(fontSize: 14, color: Colors.grey),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // Price and Wishlist button
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "150/=",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black, // Button color
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 10),
//                   ),
//                   onPressed: () {
//                     // Add to wishlist
//                   },
//                   child: const Text(
//                     "Add Wishlist",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget for size buttons
//   Widget _buildSizeButton(String size) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color.fromARGB(
//               255, 255, 16, 203), // Size button background color
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//         ),
//         onPressed: () {},
//         child: Text(
//           size,
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }

//   // Widget for color circles
//   Widget _buildColorCircle(Color color) {
//     return Container(
//       width: 40,
//       height: 40,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color,
//       ),
//     );
//   }
// }
// -------------------------------------------------------------------------------------------------------------------------------------


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:spm_shoppingmall_mobile/services/firestore.dart';

// class Wishlist extends StatefulWidget {
//   const Wishlist({super.key});

//   @override
//   State<Wishlist> createState() => _WishlistState();
// }

// class _WishlistState extends State<Wishlist> {
//   //firestore
//   final FirestoreService firestoreService = FirestoreService();
//   // Function to fetch the products in the wishlist
//   Future<List<DocumentSnapshot>> fetchWishlistProducts() async {
//     List<String> productIds =
//         await firestoreService.fetchWishlistProductIds(); // Fetch product IDs
//     return await firestoreService
//         .fetchProductsByIds(productIds); // Fetch products by IDs
//   }

//   // Function to remove product from wishlist
//   Future<void> removeProductFromWishlist(String productId) async {
//     await firestoreService
//         .removeFromWishlist(productId); // Remove product from Firestore
//     setState(() {}); // Refresh the UI after removing
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Your Wishlist"),
//         backgroundColor: Colors.brown[400],
//       ),
//       body: FutureBuilder<List<DocumentSnapshot>>(
//         future: fetchWishlistProducts(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text("Error fetching wishlist"));
//           } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             // Display the products in the wishlist
//             List<DocumentSnapshot> wishlistProducts = snapshot.data!;

//             return ListView.builder(
//               itemCount: wishlistProducts.length,
//               itemBuilder: (context, index) {
//                 var product = wishlistProducts[index];
//                 return ListTile(
//                   leading: Image.network(
//                       product['images'][0]), // Display first product image
//                   title: Text(product['title']),
//                   subtitle: Text("Price: ${product['price']}"),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: () {
//                       // Remove product from wishlist
//                       removeProductFromWishlist(product.id);
//                     },
//                   ),
//                 );
//               },
//             );
//           } else {
//             return const Center(child: Text("No products in your wishlist"));
//           }
//         },
//       ),
//     );
//   }
// }

// ---------------------------------------------------------------------------------------------------------------------
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:spm_shoppingmall_mobile/services/firestore.dart';

// class Wishlist extends StatefulWidget {
//   const Wishlist({super.key});

//   @override
//   State<Wishlist> createState() => _WishlistState();
// }

// class _WishlistState extends State<Wishlist> {
//   final FirestoreService firestoreService = FirestoreService();

//   Future<List<DocumentSnapshot>> fetchWishlistProducts() async {
//     List<String> productIds = await firestoreService.fetchWishlistProductIds();
//     return await firestoreService.fetchProductsByIds(productIds);
//   }

//   Future<void> removeProductFromWishlist(String productId) async {
//     await firestoreService.removeFromWishlist(productId);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Your Wishlist"),
//         backgroundColor: Colors.brown[400],
//         elevation: 0,
//       ),
//       body: FutureBuilder<List<DocumentSnapshot>>(
//         future: fetchWishlistProducts(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text("Error fetching wishlist"));
//           } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             List<DocumentSnapshot> wishlistProducts = snapshot.data!;

//             return ListView.builder(
//               itemCount: wishlistProducts.length,
//               itemBuilder: (context, index) {
//                 var product = wishlistProducts[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                       horizontal: 5.0, vertical: 5.0),
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(10.0),
//                     leading: ClipRRect(
//                       borderRadius: BorderRadius.circular(10.0),
//                       child: Image.network(
//                         product['images'][0],
//                         width: 70,
//                         height: 70,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                     title: Text(
//                       product['title'],
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                     subtitle: Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Text(
//                         "Price: \$${product['price']}",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Color.fromARGB(136, 0, 125, 31),
//                         ),
//                       ),
//                     ),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.delete),
//                       color: Colors.red[400],
//                       onPressed: () {
//                         removeProductFromWishlist(product.id);
//                       },
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else {
//             return const Center(child: Text("No products in your wishlist"));
//           }
//         },
//       ),
//     );
//   }
// }

// ---------------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
// import 'package:spm_shoppingmall_mobile/productSearchFunction/pages/scannerPage.dart';

// import 'package:spm_shoppingmall_mobile/productSearchFunction/pages/wishList.dart';

// import '../services/firestore.dart';

// class ProductPage extends StatefulWidget {
//   final String docId;

//   const ProductPage({required this.docId, super.key});

//   @override
//   State<ProductPage> createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
//   final FirestoreService firestoreService = FirestoreService();
//   final CollectionReference productStore =
//       FirebaseFirestore.instance.collection('Store Products');

//   Map<String, dynamic>? productData;
//   bool isLoading = true;
//   String selectedSize = '';
//   String selectedColor = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchProductData();
//   }

//   Future<void> fetchProductData() async {
//     try {
//       DocumentSnapshot doc = await productStore.doc(widget.docId).get();
//       setState(() {
//         productData = doc.data() as Map<String, dynamic>;
//         isLoading = false;
//         if (productData!['sizes'].isNotEmpty) {
//           selectedSize = productData!['sizes'][0];
//         }
//         if (productData!['colors'].isNotEmpty) {
//           selectedColor = productData!['colors'][0];
//         }
//       });
//     } catch (e) {}
//   }

//   Future<void> handleAddToCart() async {
//     // Implement add to cart functionality
//     await firestoreService.addToWishlist(widget.docId); // Add to wishlist
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Wishlist(),
//       ),
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Added to Wishist')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => ScannerPage(),
//             ),
//           ),
//         ),
//         title: Text(
//           'Product Details',
//           style: TextStyle(
//               color: const Color.fromARGB(255, 255, 255, 255),
//               fontSize: 24,
//               fontWeight: FontWeight.w400),
//         ),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : productData == null
//               ? const Center(child: Text('Product not found!'))
//               : SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Image Carousel
//                       FlutterCarousel(
//                         options: CarouselOptions(
//                           height: 500.0,
//                           showIndicator: true,
//                           slideIndicator: const CircularSlideIndicator(
//                             slideIndicatorOptions: SlideIndicatorOptions(
//                               itemSpacing: 10,
//                               indicatorRadius: 5,
//                               currentIndicatorColor:
//                                   Color.fromARGB(255, 255, 255, 255),
//                               indicatorBackgroundColor:
//                                   Color.fromARGB(255, 102, 0, 150),
//                             ),
//                           ),
//                         ),
//                         items: (productData!['images'] as List<dynamic>)
//                             .map((imageUrl) {
//                           return Builder(
//                             builder: (BuildContext context) {
//                               return Image.network(
//                                 imageUrl,
//                                 fit: BoxFit.contain,
//                               );
//                             },
//                           );
//                         }).toList(),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   productData!['category'],
//                                   style: const TextStyle(
//                                       fontSize: 16, color: Colors.grey),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text(productData!['brand'],
//                                         style: const TextStyle(fontSize: 18)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 1),
//                             Text(
//                               productData!['title'],
//                               style: const TextStyle(
//                                   fontSize: 24, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 4),
//                             const Text(
//                               'Product Details',
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.w400),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               productData!['description'],
//                               style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Color.fromARGB(255, 122, 122, 122)),
//                             ),
//                             const SizedBox(height: 8),
//                             const Divider(
//                                 color: const Color.fromARGB(255, 82, 82, 82)),
//                             const SizedBox(height: 8),
//                             const Text(
//                               'Available Sizes',
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.w500),
//                             ),
//                             const SizedBox(height: 4),
//                             Container(
//                               width: double
//                                   .infinity, // Ensures the Wrap takes the full width
//                               child: Wrap(
//                                 spacing: 10,
//                                 alignment: WrapAlignment.spaceAround,
//                                 children: productData!['sizes']
//                                     .map<Widget>(
//                                         (sizes) => _buildSizeButton(sizes))
//                                     .toList(),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             const Text(
//                               'Available Colors',
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.w500),
//                             ),
//                             const SizedBox(height: 4),
//                             Wrap(
//                               spacing: 20,
//                               children: productData!['colors']
//                                   .map<Widget>(
//                                       (colors) => _buildColorCircle(colors))
//                                   .toList(),
//                             ),
//                             const SizedBox(height: 15),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment
//                                   .spaceBetween, // Ensure space between price and button
//                               children: [
//                                 // Total Price section (in a column to display both texts vertically)
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment
//                                       .start, // Align text to the left
//                                   children: [
//                                     const Text(
//                                       'Price: ',
//                                       style: TextStyle(
//                                         fontSize: 24,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                         height:
//                                             4), // Small space between text and price
//                                     Text(
//                                       "\$${productData!['price']}",
//                                       style: const TextStyle(
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color.fromARGB(255, 152, 11, 0),
//                                       ),
//                                     ),
//                                   ],
//                                 ),

//                                 // Add to Cart button
//                                 ElevatedButton.icon(
//                                   icon: const Icon(Icons.shopping_bag_outlined,
//                                       color: Colors.white),
//                                   label: const Text(
//                                     'Add to Wish List',
//                                     style: TextStyle(
//                                         fontSize: 16, color: Colors.white),
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor:
//                                         Colors.purple, // Button color
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 15, horizontal: 18),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(
//                                           10), // Rounded corners
//                                     ),
//                                   ),
//                                   onPressed: handleAddToCart,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//     );
//   }

//   Widget _buildSizeButton(String size) {
//     return GestureDetector(
//       child: Card(
//         color: Colors.purple[400],
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//           child: Text(
//             size,
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildColorCircle(String color) {
//     Color actualColor = _getColorFromString(color);
//     //bool isSelected = selectedColor == color;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedColor = color;
//         });
//       },
//       child: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: actualColor,
//         ),
//       ),
//     );
//   }

//   Color _getColorFromString(String colorString) {
//     switch (colorString.toLowerCase()) {
//       case 'red':
//         return Colors.red;
//       case 'blue':
//         return Colors.blue;
//       case 'green':
//         return Colors.green;
//       case 'yellow':
//         return Colors.yellow;
//       case 'purple':
//         return Colors.purple;
//       case 'orange':
//         return Colors.orange;
//       case 'brown':
//         return Colors.brown;
//       case 'grey':
//         return Colors.grey;
//       case 'black':
//         return Colors.black;
//       default:
//         return Colors.grey; // Default color
//     }
//   }
// }
// ---------------------------------------------------------------------------------