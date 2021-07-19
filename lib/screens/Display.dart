import 'package:flutter/material.dart';
import 'package:lfh_app/screens/corouselScreen.dart';
import 'package:lfh_app/services/CloudFirestore.dart';
import 'package:lfh_app/util/AppEntity.dart';
import 'package:lfh_app/util/Models.dart';
import 'package:lfh_app/util/const.dart';
import 'package:lfh_app/widgets/favorite_item.dart';
import 'FurnitureFullInfo.dart';


class DisplayScreen extends StatelessWidget {

  final FurnitureItem furnitureItem;
  final bool isCorousel;
  final bool isCart;
  DisplayScreen({this.furnitureItem, @required this.isCorousel, this.isCart});
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ImageItem>>(
      future: isCart != null ? DatabaseService().getFavOrCartItemList(!isCart)
      : DatabaseService().getimageItemList(furnitureItem.id),
      builder: (context, snapshot) {
        if(!snapshot.hasData || snapshot.data.length == 0)
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(Constants.appName,),
          ),
          body: Container(
            child: Center(child: Text('No Data to Display'),),
          ),
        );
        else  return DisplayGrid(
          imageItemList: snapshot.data,
          furnitureItem: furnitureItem != null ? furnitureItem :  isCart
          ? FurnitureItem(name: 'Cart Products') : FurnitureItem(name: 'Favorite Products'),
          isCorousel : isCorousel);
      }
    );
  }

}

class DisplayGrid extends StatefulWidget {
  final List<ImageItem> imageItemList;
  final FurnitureItem furnitureItem;
  final bool isCorousel;
  DisplayGrid({this.imageItemList, this.isCorousel, this.furnitureItem});
  @override
  _DisplayGridState createState() => _DisplayGridState();
}

class _DisplayGridState extends State<DisplayGrid> {
  bool isCorousel;
  @override
  void initState() {
    isCorousel = widget.isCorousel;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Constants.appName,),
        actions: [
        GestureDetector(
          onTap: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context){
                  return AlertDialog(
                    actions: [
                      FlatButton(
                        child: Text("No"),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text("Yes"),
                        onPressed: () async{
                          Navigator.of(context).pop();
                          await shareFileToOtherDevices(
                            widget.imageItemList.map((img){return img.id;}).toList(),
                            widget.furnitureItem.name
                          );
                          
                        },
                      ),
                    ],
                    title: Text("Share Images"),
                    content: Text('Do you want to share all the ${widget.furnitureItem.name} Images ?')
                  );
              }
            );
          },
          child: Icon(Icons.share),
        ),
        SizedBox(width: 20.0),
        Center(
            child: GestureDetector(
              onTap: (){
                setState(() { isCorousel = !isCorousel; });
              },
              child: Icon( Icons.swap_horizontal_circle_sharp),
            ),
          ), 
          SizedBox(width: 20.0),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.zero,
            color: Theme.of(context).primaryColor,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)
            ),
            ),
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                widget.furnitureItem.name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: isCorousel ? CorouselScreen(imageItemList : widget.imageItemList) :GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2
              ),
              scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.imageItemList.length,
                itemBuilder: (BuildContext context, int i) {
                  int index = widget.imageItemList.length-i-1;
                  ImageItem image = widget.imageItemList[index];

                  return GestureDetector(
                    onTap: (){
                        Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return FurnitureFullInfo(imageItemList: widget.imageItemList, pageIndex: index,);
                          },
                        ),
                      );  
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FavoriteItem(
                        image: image,
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );

  }
}
