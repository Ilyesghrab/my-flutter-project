import 'package:flutter/material.dart';
import 'package:myapp/model/category.dart';

class CategoryHeaderWidget extends StatelessWidget {
  final Category category;

  const CategoryHeaderWidget({
    Key key,
    @required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]),
            //color: category.backgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // FaIcon(category.icon, color: Colors.blue, size: 30),
              const SizedBox(height: 0.1),
              Text(
                category.categoryName,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
      );
}
