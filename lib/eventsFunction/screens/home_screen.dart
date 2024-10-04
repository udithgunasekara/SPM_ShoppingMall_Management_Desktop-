import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spm_shoppingmall_mobile/giftCardAndLoyaltyFunction/pages/loyalty_giftcard_page.dart';
import 'package:spm_shoppingmall_mobile/lockerFunction/pages/user/lockerHome.dart';
import '../models/event_model.dart';
import '../widgets/category_slider.dart';
import '../widgets/featured_event_card.dart';
import '../widgets/promotion_slideshow.dart';
import '../widgets/section_title.dart';
import 'event_details_screen.dart';
import 'events_screen.dart';
import 'promotion_screen.dart'; // Import PromotionScreen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/auth/firebase_auth_impl/firebase_auth_impl.dart';
import '/giftCardAndLoyaltyFunction/util/user_data_service.dart';

class HomeScreen extends StatefulWidget {

  final User? user;

  const HomeScreen({super.key,required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Map<String, dynamic>? _userDetails;
  final UserDataService _userDataService = UserDataService();
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _checkUserIdInPreferences();
  }

  // Check if user ID is set in shared preferences
  Future<void> _checkUserIdInPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('userID');
    if (userID == null) {
      // User ID is not set, redirect to login
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // If user ID is set, fetch user details
      _fetchUserDetails();
    }
  }

  Future<void> _fetchUserDetails() async {    
      final userDetails = await _userDataService.getUserDetails(widget.user!.uid);
      setState(() {
        _userDetails = userDetails;
      });
    
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User signed out')),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userID');

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      debugPrint('Sign out failed: $e');
    }
  }

  void _handleCategorySelected(BuildContext context, String category) {
    if (category == 'Events') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventsScreen()),
      );
    } else if (category == 'Promotions') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PromotionScreen()),
      );
    }
    else if (category == 'Locker') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LockerHome()),
      );
    }else if (category == 'Giftcards') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GiftCardAndLoyaltyPage()),
      );
    }
     else {
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
            title: Text('PocketMall',
              style: TextStyle(
                color: Colors.purple,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              )
            ),
            
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_active_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () => _signOut(context),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: PromotionSlideshow(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                    padding: EdgeInsets.symmetric(horizontal: 12),
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
