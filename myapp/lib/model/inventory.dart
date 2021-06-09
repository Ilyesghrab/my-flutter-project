import 'package:flutter/cupertino.dart';

class Inventory {
  final String inventoryName;
  final String description;
  final int backgroundColor;
  final String cardElementTop;
  final String cardElementBottom;
  final String imageUrl;
  final String selectedIcon;
  final String unselectedIcon;

  const Inventory({
    @required this.inventoryName,
    @required this.description,
    @required this.backgroundColor,
    @required this.cardElementTop,
    @required this.cardElementBottom,
    @required this.imageUrl,
    @required this.selectedIcon,
    @required this.unselectedIcon,
  });
}
