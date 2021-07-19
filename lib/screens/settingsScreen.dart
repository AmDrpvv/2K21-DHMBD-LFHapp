import 'package:flutter/material.dart';
import 'package:lfh_app/services/CloudFirestore.dart';
import 'package:lfh_app/util/AppEntity.dart';
import 'package:lfh_app/util/Models.dart';
import 'package:lfh_app/util/const.dart';
import 'AddFurniture.dart';


class SettingsScreen extends StatefulWidget {

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  TextEditingController textController;
  @override
    void initState() {
      // TODO: implement initState
      textController = TextEditingController();
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          SizedBox(height: 20.0),
          buildTitleRow(),
        ],
    );
  }


  buildTitleRow() {
    return StreamBuilder<List<FurnitureItem>>(
      stream: DatabaseService().furnitureStream,
      builder: (context, snapshot) {
        return !snapshot.hasData ? Container():Container(
          padding: EdgeInsets.only(left: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Add Furniture",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              for(int i=0;i<snapshot.data.length;i++)
              ListTile(
                onTap: (){
                  Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return AddFurnitureScreen(
                        furniture: snapshot.data[i]
                      );
                    },
                  ),
                );
                },
                title: Text(snapshot.data[i].name),
              ),
              ListTile(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                        return AlertDialog(
                          actions: [
                            FlatButton(
                              child: Text("Close"),
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Continue"),
                              onPressed: () async{
                                if(textController.text != ''){
                                  try {
                                    var prefs = await getSharedPreferences();
                                    String id = await DatabaseService().createFurnitureID();
                                    
                                    await DatabaseService().createFurnitureItem(
                                      FurnitureItem(
                                        id: id,
                                        name: textController.text,
                                        url: prefs[sharedPrefDefaultUrl]
                                      )
                                    );
                                    
                                    textController.clear();
                                  } catch (e) {
                                    print('Error In add Furniture: $e');
                                    textController.clear();
                                  }
                                  
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                          title: Text("Add Furniture"),
                          content:  Container(
                            padding: EdgeInsets.all(5.0),
                            child: TextField(
                              controller: textController,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Name (should be unique)',
                                hintStyle: TextStyle(
                                    color: Colors.grey[400]),
                              ),
                            ),
                          ),
                        );
                    }
                  );
                },
                title: Text('Add Furniture Category',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
                trailing: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Theme.of(context).accentColor,
                  child: Icon(Icons.add,
                  color: Constants.lightPrimary,
                )
              ),
              ),
            ],
          ),
        );
      }
    );
  }
  
}