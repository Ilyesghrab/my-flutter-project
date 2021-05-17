import 'package:flutter/material.dart';
import 'package:myapp/model/category.dart';

class CategoryDetailWidget extends StatelessWidget {
  final Category category;
  final ValueChanged<Category> onSelectedCategory;

  const CategoryDetailWidget({
    Key key,
    @required this.category,
    @required this.onSelectedCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onSelectedCategory(category),
        child: Container(
          padding: EdgeInsets.only(right: 10),
          width: MediaQuery.of(context).size.width * 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildImage(),
              SizedBox(height: 12),
              Text(
                category.categoryName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              SizedBox(height: 0.5),
              Text(
                category.description,
                style: TextStyle(fontSize: 16, color: Colors.black),
              )
            ],
          ),
        ),
      );

  Widget buildImage() => Container(
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(image: AssetImage(category.imageUrl)),
        ),
      );
}
