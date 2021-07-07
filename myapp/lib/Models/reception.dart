import 'package:flutter/cupertino.dart';

class Reception {
  final String receptionName;
  final String description;
  final int backgroundColor;
  final String cardElementTop;
  final String cardElementBottom;
  final String imageUrl;
  final String selectedIcon;
  final String unselectedIcon;

  const Reception({
    @required this.receptionName,
    @required this.description,
    @required this.backgroundColor,
    @required this.cardElementTop,
    @required this.cardElementBottom,
    @required this.imageUrl,
    @required this.selectedIcon,
    @required this.unselectedIcon,
  });
}
