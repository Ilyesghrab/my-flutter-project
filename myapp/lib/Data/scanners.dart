import 'package:myapp/Models/scanner.dart';

class Scanners {
  static const scanners = <Scanner>[
    Scanner(
        imageUrl: 'assets/images/barcode.png',
        scannerName: 'Préparation de commande',
        backgroundColor: 0xFF00897B,
        //icon: FontAwesomeIcons.barcode,
        description: 'Scan here for more information',
        cardElementTop: 'assets/SVG/ellipse_top_blue.svg',
        cardElementBottom: 'assets/SVG/ellipse_bottom_blue.svg',
        selectedIcon: 'assets/SVG/bank_withdraw_white.svg',
        unselectedIcon: 'assets/SVG/bank_withdraw_blue.svg'),
  ];
}
