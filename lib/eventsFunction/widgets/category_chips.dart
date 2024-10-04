import 'package:flutter/material.dart';

class CategoryChips extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CategoryChips({Key? key, required this.onCategorySelected})
      : super(key: key);

  @override
  _CategoryChipsState createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Music',
    'Art',
    'Food',
    'Fashion',
    'Tech'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _categories
            .map(
              (category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                    widget.onCategorySelected(category);
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
