// models/promotion_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Promotion {
  final String bannerImage;
  final String discount;
  final String duration;
  final String name;

  Promotion({
    required this.bannerImage,
    required this.discount,
    required this.duration,
    required this.name,
  });

  factory Promotion.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    print('Promotion data: $data'); // Debugging line to check data
    return Promotion(
      bannerImage: data['bannerImage'] ?? '', // Handle missing field
      discount: data['discount'] ?? '',
      duration: data['duration'] ?? '',
      name: data['name'] ?? '',
    );
  }
}
