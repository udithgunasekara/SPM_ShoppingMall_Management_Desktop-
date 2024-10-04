import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';
import '../widgets/category_slider.dart';
import '../widgets/featured_event_card.dart';
import '../widgets/promotion_slideshow.dart';
import '../widgets/section_title.dart';
import 'event_details_screen.dart';
import 'events_screen.dart';
import 'promotion_screen.dart'; // Import PromotionScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _handleCategorySelected(BuildContext context, String category) {
    if (category == 'Events') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventsScreen()),
      );
    } else if (category == 'Promotions') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PromotionScreen()), // Navigate to PromotionScreen
      );
    } else {
      // Handle other categories or show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$category category selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text('Mall of America'),
            actions: [
              // Notification Bell Button
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  // Implement notification functionality
                },
              ),
              // Logout Button
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  // Implement logout functionality
                },
              ),
            ],
          ),
          // Adjusted padding to reduce margin
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(
                  12.0), // Reduced padding from 16.0 to 12.0
              child: PromotionSlideshow(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12.0), // Reduced horizontal padding
              child: CategorySlider(
                onCategorySelected: (category) =>
                    _handleCategorySelected(context, category),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SectionTitle(title: 'Featured Events'),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<Event> events = snapshot.data!.docs
                      .map((doc) => Event.fromFirestore(doc))
                      .toList();

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                        horizontal: 12), // Reduced horizontal padding
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return FeaturedEventCard(
                        event: events[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventDetailsScreen(event: events[index]),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
