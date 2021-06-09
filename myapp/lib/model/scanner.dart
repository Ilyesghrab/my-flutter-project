import 'package:flutter/cupertino.dart';

class Scanner {
  final String scannerName;
  final String description;
  final int backgroundColor;
  final String cardElementTop;
  final String cardElementBottom;
  final String imageUrl;
  final String selectedIcon;
  final String unselectedIcon;

  const Scanner({
    @required this.scannerName,
    @required this.description,
    @required this.backgroundColor,
    @required this.cardElementTop,
    @required this.cardElementBottom,
    @required this.imageUrl,
    @required this.selectedIcon,
    @required this.unselectedIcon,
  });
}
