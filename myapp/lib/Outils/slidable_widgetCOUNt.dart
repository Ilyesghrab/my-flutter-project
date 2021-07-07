import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myapp/Views/List/listCount.dart';
import 'package:myapp/Views/List/listCummul.dart';
import 'package:myapp/Views/List/listProd.dart';

enum SlidableAction { archive, share, more, delete }

class SlidableWidget<T> extends StatelessWidget {
  final Widget child;
  //final Function(SlidableAction action) onDismissed;

  const SlidableWidget({
    @required this.child,
    //@required this.onDismissed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        child: child,
        actionExtentRatio: 0.2,

        /// left side

        /// right side
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Product',
            color: Colors.blue,
            icon: Icons.more_horiz,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListProd()),
              );
            },
          ),
          IconSlideAction(
            caption: 'Cummul',
            color: Colors.blue[800],
            icon: Icons.delete,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListCummul()),
              );
            },
          ),
          IconSlideAction(
            caption: 'Archive',
            color: Colors.grey[800],
            icon: Icons.archive,
            onTap: () {},
          ),
          IconSlideAction(
            caption: 'Details',
            color: Colors.yellow,
            icon: Icons.more,
            onTap: () {},
          ),
          IconSlideAction(
            caption: 'Close',
            color: Colors.grey[100],
            icon: Icons.close,
            onTap: () {},
          ),
        ],
      );
}
