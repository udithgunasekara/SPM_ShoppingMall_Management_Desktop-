// lib/widgets/category_slider.dart

import 'package:flutter/material.dart';

class CategorySlider extends StatelessWidget {
  final List<Category> categories = [
    Category(icon: Icons.event, name: 'Events'),
    Category(icon: Icons.local_offer, name: 'Promotions'),
    Category(icon: Icons.lock, name: 'Locker'),
    Category(icon: Icons.card_giftcard, name: 'Giftcards'),
  ];

  final Function(String) onCategorySelected;

  CategorySlider({Key? key, required this.onCategorySelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onCategorySelected(categories[index].name),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(categories[index].icon, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(categories[index].name),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Category {
  final IconData icon;
  final String name;

  Category({required this.icon, required this.name});
}
