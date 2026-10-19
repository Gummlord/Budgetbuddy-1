import 'package:flutter/material.dart';

class Categories {
  Categories._();

  static const String food = 'Food';
  static const String transportation = 'Transportation';
  static const String school = 'School';
  static const String loadInternet = 'Load/Internet';
  static const String entertainment = 'Entertainment';
  static const String other = 'Other';

  static const List<String> all = [
    food,
    transportation,
    school,
    loadInternet,
    entertainment,
    other,
  ];

  static const Map<String, IconData> _icons = {
    food: Icons.restaurant_rounded,
    transportation: Icons.directions_bus_rounded,
    school: Icons.menu_book_rounded,
    loadInternet: Icons.wifi_rounded,
    entertainment: Icons.sports_esports_rounded,
    other: Icons.more_horiz_rounded,
  };

  static IconData iconFor(String category) =>
      _icons[category] ?? Icons.category_rounded;
}
