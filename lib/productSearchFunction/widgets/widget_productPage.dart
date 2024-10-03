// Widget for color circles
import 'package:flutter/material.dart';

Widget _buildColorCircle(Color color) {
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
  );
}
