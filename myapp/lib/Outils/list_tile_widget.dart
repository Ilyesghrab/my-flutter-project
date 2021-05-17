import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onClicked;

  const ListTileWidget({
    @required this.text,
    @required this.icon,
    @required this.onClicked,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: Icon(icon, size: 28, color: Colors.black),
        onTap: onClicked,
      );
}
