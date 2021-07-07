import 'package:myapp/Models/inventory.dart';
import 'package:myapp/Models/livraison.dart';

class Livraisons {
  static const deliveries = <Livraison>[
    Livraison(
        livraisonName: 'Delivery',
        description: 'Delivery',
        backgroundColor: 0xFFEEEEEE,
        //icon: FontAwesomeIcons.truckLoading,
        cardElementTop: 'assets/SVG/ellipse_top_pink.svg',
        cardElementBottom: 'assets/SVG/ellipse_bottom_pink.svg',
        imageUrl: 'assets/images/truck.png',
        selectedIcon: 'assets/SVG/money_transfer_white.svg',
        unselectedIcon: 'assets/SVG/money_transfer_blue.svg'),
  ];
}
