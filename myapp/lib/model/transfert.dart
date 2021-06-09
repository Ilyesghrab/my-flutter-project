import 'package:flutter/cupertino.dart';

class Transfert {
  final String transfertName;
  final String description;
  final int backgroundColor;
  final String cardElementTop;
  final String cardElementBottom;
  final String imageUrl;
  final String selectedIcon;
  final String unselectedIcon;

  const Transfert({
    @required this.transfertName,
    @required this.description,
    @required this.backgroundColor,
    @required this.cardElementTop,
    @required this.cardElementBottom,
    @required this.imageUrl,
    @required this.selectedIcon,
    @required this.unselectedIcon,
  });
}
