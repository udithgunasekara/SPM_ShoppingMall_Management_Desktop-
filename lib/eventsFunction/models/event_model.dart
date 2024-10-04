import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String name;
  final String date;
  final String time;
  final String location;
  final String bannerImage;
  final String altText;
  final String description;
  final String category;
  bool isReminded;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.bannerImage,
    required this.altText,
    required this.description,
    required this.category,
    this.isReminded = false,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      name: data['name'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      location: data['location'] ?? '',
      bannerImage: data['bannerImage'] ?? '',
      altText: data['altText'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'All',
      isReminded: data['isReminded'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'time': time,
      'location': location,
      'bannerImage': bannerImage,
      'altText': altText,
      'description': description,
      'category': category,
      'isReminded': isReminded,
    };
  }
}
