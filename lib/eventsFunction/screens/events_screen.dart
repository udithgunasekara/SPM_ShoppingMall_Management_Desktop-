import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        elevation: 0,
        backgroundColor: Color(0xffffffff),
        foregroundColor: Color(0xff000000),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No events found'));
          }

          List<Event> events = snapshot.data!.docs
              .map((doc) => Event.fromFirestore(doc))
              .toList();

          return RefreshIndicator(
            onRefresh: () async {
              // Implement refresh logic if needed
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 16),
              itemCount: events.length,
              itemBuilder: (context, index) => EventCard(event: events[index]),
            ),
          );
        },
      ),
    );
  }
}
