import 'package:flutter/material.dart';
import 'package:lfh_app/util/Models.dart';

class CategoryItem extends StatelessWidget {
  final FurnitureItem furniture;
  final double width;
  final double height;

  CategoryItem({this.furniture, this.height, this.width});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Container(
        padding: EdgeInsets.only(left: 10.0),
        alignment: Alignment.centerLeft,
        child: Text(
          furniture.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
      ),
      SizedBox(height: 10.0),
      Expanded(
        child: Card(
          color: Theme.of(context).primaryColor,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: NetworkImage(furniture.url),
                  fit: BoxFit.cover
                )
              ),
            ),
          ),
        ),
      ),
    ],
    );

  }
}
