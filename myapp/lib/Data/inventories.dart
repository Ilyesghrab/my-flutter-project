import 'package:myapp/model/inventory.dart';

class Inventories {
  static const inventoris = <Inventory>[
    Inventory(
        inventoryName: 'Inventory',
        description: 'Inventory',
        backgroundColor: 0xFFEEEEEE,
        //icon: FontAwesomeIcons.truckLoading,
        cardElementTop: 'assets/SVG/ellipse_top_pink.svg',
        cardElementBottom: 'assets/SVG/ellipse_bottom_pink.svg',
        imageUrl: 'assets/images/truck.png',
        selectedIcon: 'assets/SVG/money_transfer_white.svg',
        unselectedIcon: 'assets/SVG/money_transfer_blue.svg'),
  ];
}
