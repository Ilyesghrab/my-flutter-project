import 'package:myapp/model/category.dart';

class Categories {
  static const categoris = <Category>[
    Category(
        imageUrl: 'assets/images/barcode.png',
        categoryName: 'Scan Here',
        backgroundColor: 0xFF00897B,
        //icon: FontAwesomeIcons.barcode,
        description: 'Scan here for more information',
        cardElementTop: 'assets/SVG/ellipse_top_blue.svg',
        cardElementBottom: 'assets/SVG/ellipse_bottom_blue.svg',
        selectedIcon: 'assets/SVG/bank_withdraw_white.svg',
        unselectedIcon: 'assets/SVG/bank_withdraw_blue.svg'),
    Category(
        imageUrl: 'assets/images/information-desk.png',
        categoryName: 'Reception',
        backgroundColor: 0xFFEEEEEE,
        //icon: FontAwesomeIcons.conciergeBell,
        description: 'Reception product list',
        cardElementTop: 'assets/SVG/ellipse_top_pink.svg',
        cardElementBottom: 'assets/SVG/ellipse_bottom_pink.svg',
        selectedIcon: 'assets/SVG/insight_tracking_white.svg',
        unselectedIcon: 'assets/SVG/insight_tracking_blue.svg'),
    Category(
        imageUrl: 'assets/images/inventory.png',
        categoryName: 'Transfert and reclassification',
        backgroundColor: 0xFF00897B,
        //icon: FontAwesomeIcons.conciergeBell,
        description: 'transfer and reclassification',
        cardElementTop: 'assets/SVG/ellipse_top_blue.svg',
        cardElementBottom: 'assets/SVG/ellipse_bottom_blue.svg',
        selectedIcon: 'assets/SVG/money_transfer_white.svg',
        unselectedIcon: 'assets/SVG/money_transfer_blue.svg'),
    Category(
        categoryName: 'Delivery',
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
