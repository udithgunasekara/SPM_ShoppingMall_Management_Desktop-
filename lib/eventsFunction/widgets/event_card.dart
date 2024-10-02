import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../screens/event_details_screen.dart'; // Import the EventDetailsScreen
import '../utils/date_formatter.dart'; // Import the date formatter

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EventDetailsScreen(event: event), // Call the EventDetailsScreen
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Image.network(
                event.bannerImage,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error);
                },
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(formatDate(event.date)), // Format the date
                    Text(event.location),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
