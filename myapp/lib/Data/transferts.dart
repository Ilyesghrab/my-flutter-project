import 'package:myapp/model/transfert.dart';

class Transferts {
  static const transferts = <Transfert>[
    Transfert(
        imageUrl: 'assets/images/inventory.png',
        transfertName: 'Transfert and reclassification',
        backgroundColor: 0xFF00897B,
        //icon: FontAwesomeIcons.conciergeBell,
        description: 'transfer and reclassification',
        cardElementTop: 'assets/SVG/ellipse_top_blue.svg',
        cardElementBottom: 'assets/SVG/ellipse_bottom_blue.svg',
        selectedIcon: 'assets/SVG/money_transfer_white.svg',
        unselectedIcon: 'assets/SVG/money_transfer_blue.svg'),
  ];
}
