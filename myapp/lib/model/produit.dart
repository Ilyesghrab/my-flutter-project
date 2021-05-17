import 'package:meta/meta.dart';

class Produit {
  final String imgPath;
  final String foodName;
  final String foodPrice;

  const Produit({
    @required this.imgPath,
    @required this.foodName,
    @required this.foodPrice,
  });
}
