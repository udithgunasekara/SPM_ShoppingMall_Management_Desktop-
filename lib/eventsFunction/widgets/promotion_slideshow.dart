// widgets/promotion_slideshow.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/promotion_model.dart';
import '../screens/promotion_details_screen.dart';

class PromotionSlideshow extends StatefulWidget {
  const PromotionSlideshow({Key? key}) : super(key: key);

  @override
  _PromotionSlideshowState createState() => _PromotionSlideshowState();
}

class _PromotionSlideshowState extends State<PromotionSlideshow> {
  late PageController _pageController;
  late ValueNotifier<int> _currentPageNotifier;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPageNotifier = ValueNotifier(0);
    _pageController.addListener(() {
      _currentPageNotifier.value = _pageController.page!.round();
    });
    _autoSlide();
  }

  void _autoSlide() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_currentPageNotifier.value < 2) {
        _currentPageNotifier.value++;
      } else {
        _currentPageNotifier.value = 0;
      }
      _pageController.animateToPage(
        _currentPageNotifier.value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _autoSlide();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('promotions').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<Promotion> promotions = snapshot.data!.docs
            .map((doc) => Promotion.fromFirestore(doc))
            .toList();

        if (promotions.isEmpty) {
          return Center(child: Text('No promotions available.'));
        }

        return Container(
          height: 200,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: promotions.length,
                itemBuilder: (context, index) {
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
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(promotions[index].bannerImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(
                                  0.5), // Adjusted opacity for a modern feel
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 16, // Adjusted position
                left: 0,
                right: 0,
                child: ValueListenableBuilder<int>(
                  valueListenable: _currentPageNotifier,
                  builder: (context, currentPage, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        promotions.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width:
                              12, // Increased size of indicators for better visibility
                          height: 12,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage == index
                                ? Theme.of(context).primaryColor
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
