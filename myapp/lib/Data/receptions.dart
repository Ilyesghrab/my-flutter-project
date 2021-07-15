import 'package:myapp/Models/reception.dart';

class Receptions {
  static const receptions = <Reception>[
    Reception(
        imageUrl: 'assets/images/information-desk.png',
        receptionName: 'Réception',
        backgroundColor: 0xFFEEEEEE,
        //icon: FontAwesomeIcons.conciergeBell,
        description: 'Reception product list',
        cardElementTop: 'assets/SVG/ellipse_top_pink.svg',
        cardElementBottom: 'assets/SVG/ellipse_bottom_pink.svg',
        selectedIcon: 'assets/SVG/insight_tracking_white.svg',
        unselectedIcon: 'assets/SVG/insight_tracking_blue.svg'),
  ];
}
