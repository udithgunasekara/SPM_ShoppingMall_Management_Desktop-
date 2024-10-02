import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as add2cal;
import '../models/event_model.dart';
import '../utils/date_formatter.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.deepPurple,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        event.bannerImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error,
                                size: 100, color: Colors.white),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(Icons.calendar_today,
                          '${formatDate(event.date)}, ${event.time}', context),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.location_on, event.location, context),
                      const SizedBox(height: 24),
                      Text(
                        'About this event',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.altText,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.grey[800],
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        event.description, // Display the description here
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.grey[800],
                            ),
                      ),
                      const SizedBox(
                          height: 80), // To create space above the button
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () => _addToCalendar(context),
                icon: const Icon(Icons.calendar_today),
                label: const Text('Add to Calendar'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.deepPurple),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
          ),
        ),
      ],
    );
  }

  void _addToCalendar(BuildContext context) {
    DateTime eventStartDate = DateFormat('MM/dd/yyyy').parse(event.date);
    DateTime eventEndDate = eventStartDate.add(const Duration(hours: 2));

    final eventToAdd = add2cal.Event(
      title: event.name,
      description: event.altText,
      location: event.location,
      startDate: eventStartDate,
      endDate: eventEndDate,
    );

    add2cal.Add2Calendar.addEvent2Cal(eventToAdd).then((success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success
            ? 'Event added to calendar successfully!'
            : 'Failed to add event to calendar.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: success ? Colors.green : Colors.red,
      ));
    });
  }
}
