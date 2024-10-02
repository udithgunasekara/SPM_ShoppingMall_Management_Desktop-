// widgets/promotion_slideshow.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/promotion_model.dart';
import '../screens/promotion_details_screen.dart'; // Ensure this is the correct path

class PromotionSlideshow extends StatefulWidget {
  const PromotionSlideshow({Key? key}) : super(key: key);

  @override
  _PromotionSlideshowState createState() => _PromotionSlideshowState();
}

class _PromotionSlideshowState extends State<PromotionSlideshow> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Automatically change pages every 5 seconds for a slower slideshow
    Future.delayed(const Duration(seconds: 5), _autoSlide);
  }

  void _autoSlide() {
    if (_currentPage < (_pageController.page!.toInt() + 1) % 3) {
      _currentPage++;
    } else {
      _currentPage = 0; // Loop back to the first page after the last
    }

    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 500), // Slower transition
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 5), _autoSlide);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('promotions').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Error fetching promotions: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Promotion> promotions = snapshot.data!.docs
            .map((doc) => Promotion.fromFirestore(doc))
            .toList();

        print('Number of promotions: ${promotions.length}'); // Debugging line

        if (promotions.isEmpty) {
          return Center(child: Text('No promotions available.'));
        }

        return SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: promotions.length,
            itemBuilder: (context, index) {
              final bannerImage = promotions[index].bannerImage;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PromotionDetailsScreen(
                        promotion: promotions[index],
                      ),
                    ),
                  );
                },
                child: bannerImage.isNotEmpty
                    ? Image.network(
                        bannerImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Text('Failed to load image'));
                        },
                      )
                    : Center(child: Text('No image available')),
              );
            },
          ),
        );
      },
    );
  }
}
