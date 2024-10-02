import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../utils/date_formatter.dart'; // Import the date formatter

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  EventDetailsScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              event.bannerImage,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error);
              },
            ),
            SizedBox(height: 20),
            Text(
              event.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('${formatDate(event.date)}, ${event.time}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text(event.location, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text(
              'About this event',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(event.altText),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text('Attend'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Full width button
              ),
            )
          ],
        ),
      ),
    );
  }
}
