import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon; // Added icon parameter
  final VoidCallback onPressed;

  const ActionButton({
    Key? key,
    required this.label,
    required this.icon, // Required the icon parameter
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20), // Using the icon
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Theme.of(context).primaryColor, // Updated to backgroundColor
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
