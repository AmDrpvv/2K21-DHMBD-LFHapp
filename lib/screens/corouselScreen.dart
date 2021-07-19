import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lfh_app/util/Models.dart';
import 'package:lfh_app/widgets/favorite_item.dart';

import 'FurnitureFullInfo.dart';

class CorouselScreen extends StatelessWidget {
  final List<ImageItem> imageItemList;
  CorouselScreen({this.imageItemList});
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height,
        scrollDirection: Axis.vertical,
        viewportFraction: 0.3,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        initialPage: 1
      ),
      itemCount: imageItemList.length,
      itemBuilder: (BuildContext context, int i){
        int index = imageItemList.length-i-1;
        ImageItem image = imageItemList[index];
        return GestureDetector(
          onTap: (){
              Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return FurnitureFullInfo(imageItemList: imageItemList, pageIndex: index,);
                },
              ),
            );  
          },
          child: FavoriteItem(
            image: image,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.3,
          )
        );
      },
    );
  }
}