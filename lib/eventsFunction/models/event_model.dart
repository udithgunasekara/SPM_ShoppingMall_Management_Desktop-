import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String name;
  final String date;
  final String time;
  final String location;
  final String bannerImage;
  final String altText;
  final String description; // Add description field

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.bannerImage,
    required this.altText,
    required this.description, // Required for the constructor
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
      description:
          data['description'] ?? '', // Retrieve description from Firestore
    );
  }
}
