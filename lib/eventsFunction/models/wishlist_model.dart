// models/wishlist_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistItem {
  final String id;
  final String title;
  final String imageUrl;
  final double price;

  WishlistItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
  });

  factory WishlistItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WishlistItem(
      id: doc.id,
      title: data['title'] ?? '',
      imageUrl: data['images'][0] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
    );
  }
}
