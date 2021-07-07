import 'package:flutter/cupertino.dart';

class Livraison {
  final String livraisonName;
  final String description;
  final int backgroundColor;
  final String cardElementTop;
  final String cardElementBottom;
  final String imageUrl;
  final String selectedIcon;
  final String unselectedIcon;

  const Livraison({
    @required this.livraisonName,
    @required this.description,
    @required this.backgroundColor,
    @required this.cardElementTop,
    @required this.cardElementBottom,
    @required this.imageUrl,
    @required this.selectedIcon,
    @required this.unselectedIcon,
  });
}
