import 'package:flutter/material.dart';
import 'package:lfh_app/util/Models.dart';
import 'package:lfh_app/util/const.dart';

class FavoriteItem extends StatelessWidget {
  final ImageItem image;
  final double width;
  final double height;

  FavoriteItem({this.image, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(image.url),fit: BoxFit.cover
          )
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          color: Colors.black26,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.shopping_cart,
              color: !image.isCarted ? Constants.lightPrimary : Constants.lightAccent,),
              Expanded(child: Text(image.name,textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Constants.lightPrimary,),
              ),),
              Icon(Icons.favorite,
              color: !image.isLiked ? Constants.lightPrimary : Constants.lightAccent,),
          ],),
        ),
      ),
    );
  }
}