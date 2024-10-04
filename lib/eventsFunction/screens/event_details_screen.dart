import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';
import '../services/reminder_service.dart';
import '../utils/date_formatter.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isReminded = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReminderStatus();
  }

  Future<void> _loadReminderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isReminded = prefs.getBool('reminder_${widget.event.id}') ?? false;
    });
  }

  Stream<DocumentSnapshot> _eventStream() {
    return FirebaseFirestore.instance
        .collection('events')
        .doc(widget.event.id)
        .snapshots();
  }

  Future<void> _toggleReminder() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final newIsReminded = !isReminded;

      // Update state
      setState(() {
        isReminded = newIsReminded;
      });

      // Update local storage
      await prefs.setBool('reminder_${widget.event.id}', newIsReminded);

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.id)
          .update({'isReminded': newIsReminded});

      if (newIsReminded) {
        await ReminderService.scheduleReminder(widget.event);
      } else {
        await ReminderService.cancelReminder(widget.event.id);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newIsReminded
              ? 'Reminder set for this event'
              : 'Reminder removed for this event'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print('Error toggling reminder: $e');
      // Revert the state
      setState(() {
        isReminded = !isReminded;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update reminder. Please try again.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _eventStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Event not found.'));
        }

        final updatedEvent = Event.fromFirestore(snapshot.data!);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          extendBodyBehindAppBar: true,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        updatedEvent.bannerImage,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16.0,
                        left: 16.0,
                        right: 16.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              updatedEvent.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: Colors.white, size: 16.0),
                                const SizedBox(width: 4.0),
                                Text(
                                  formatDate(updatedEvent.date),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(width: 16.0),
                                const Icon(Icons.access_time,
                                    color: Colors.white, size: 16.0),
                                const SizedBox(width: 4.0),
                                Text(
                                  updatedEvent.time,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
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
                      _buildInfoSection('Location', updatedEvent.location,
                          Icons.location_on, Colors.red),
                      const SizedBox(height: 16.0),
                      _buildInfoSection('Category', updatedEvent.category,
                          Icons.category, Colors.orange),
                      const SizedBox(height: 24.0),
                      Text(
                        'About This Event',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        updatedEvent.description,
                        style: const TextStyle(fontSize: 16.0, height: 1.5),
                      ),
                      const SizedBox(
                          height: 80), // To create space for the button
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Add the button directly to the body of the Scaffold
          bottomNavigationBar: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : _toggleReminder,
              icon: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(isReminded ? Icons.alarm_off : Icons.alarm_add),
              label: Text(isReminded ? 'Remove Reminder' : 'Set Reminder'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(
      String title, String content, IconData icon, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
