import 'package:flutter/material.dart';
import 'package:lfh_app/screens/Display.dart';
import 'package:lfh_app/services/CloudFirestore.dart';
import 'package:lfh_app/util/Models.dart';
import 'package:lfh_app/widgets/Category_item.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          SizedBox(height: 10.0),
          buildTitleContanier(context),
          SizedBox(height: 20.0),
          buildFurnitureList(context),
          SizedBox(height: 10.0),
        ],
    );
  }

  buildListView(List<FurnitureItem> itemList, bool isEven){
    return Container(
      height: 200.0,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 20.0),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: itemList.length,
        itemBuilder: (BuildContext context, int i) {
          int index = itemList.length-i-1;
          FurnitureItem furniture = itemList[index];

          return (!isEven && index.isEven) || (isEven && !index.isEven)
          ? SizedBox(width: 0.0, height: 0.0,)
          : GestureDetector(
            onTap: (){
                Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return DisplayScreen(furnitureItem: furniture, isCorousel: true);
                  },
                ),
              );  
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: CategoryItem(
                furniture: furniture,
                width: 250.0,
                height: 200.0,
              ),
            ),
          );
        },
      ),
    );
  }


  buildFurnitureList(BuildContext context) {

    return StreamBuilder<List<FurnitureItem>>(
      stream: DatabaseService().furnitureStream,
      builder: (context, snapshot) {
        return Container(
          child: !snapshot.hasData || snapshot.data.length == 0  ? Container(
            height: 200,
            child: Center(
              child: Text(
                'No Furniture Item Added',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
              ),
            ),
          )
          :Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildListView(snapshot.data, true),
              SizedBox(height: 20.0,),
              buildListView(snapshot.data, false),
            ],
          ),
        );
      }
    );
  }

  buildIconCard(IconData icon, BuildContext context, bool iscart){
    return Expanded(
      child: GestureDetector(
        onTap: (){
            Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return DisplayScreen(isCart: iscart, isCorousel: false);
              },
            ),
          );  
        },
        child: Card(
          elevation: 5.0,
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Icon(icon,
              size: 50.0,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
  buildTitleContanier(BuildContext context) {
    return Container(
      height: 100.0,
      // color: Colors.pink,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildIconCard(Icons.shopping_cart, context, true),
          SizedBox(width: 10.0),
          buildIconCard(Icons.favorite, context, false),
          SizedBox(width: 10.0),
          buildIconCard(Icons.local_shipping, context, true),
        ],
      ),
    );
  }
}
