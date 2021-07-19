import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lfh_app/services/CloudFirestore.dart';
import 'package:lfh_app/services/FireStorage.dart';
import 'package:lfh_app/util/AppEntity.dart';
import 'package:lfh_app/util/Models.dart';
import 'package:lfh_app/util/const.dart';


class AddFurnitureScreen extends StatefulWidget {
  final FurnitureItem furniture;

  AddFurnitureScreen({this.furniture});
  @override
  _AddFurnitureScreenState createState() => _AddFurnitureScreenState();
}

class _AddFurnitureScreenState extends State<AddFurnitureScreen> {
  File _image;
  String qualityVal;
  TextEditingController textController;
  @override
  void initState() {
    textController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  Widget addImageWidget(BuildContext cntx){
    return CircleAvatar(
    radius: 20.0,
    backgroundColor: Theme.of(cntx).accentColor,
    child: IconButton(
      onPressed: () {
        showSheet(cntx);
      },
      alignment: Alignment.center,
      icon: Icon(Icons.add),
      color: Constants.lightPrimary,
    ),
  );
  }
  
  getImage(bool isCamera, [String qualityVal = 'medium']) async{
    if(_image!= null)
      {
        _image.delete(recursive: true);
        imageCache.clear();
      }
      try {
          _image = await getImageFromDevice(isCamera, qualityVal);
        await Future.delayed(Duration(seconds: 1));
        setState(() {});
      } catch (e) {
        print('error in image picker: $e');
      }
      
  }


  showSheet(BuildContext cnxt){
    qualityVal = 'medium';
    showModalBottomSheet(
    context: cnxt,
    elevation: 3.0,
    backgroundColor: Theme.of(cnxt).primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      )
    ),
    builder: (context) => ListView(
      children: [
        Container(
          padding: EdgeInsets.only(top: 20.0),
          alignment: Alignment.center,
          child: Text('Pick Image',
            style: TextStyle(fontSize: 18.0,
              color: Theme.of(cnxt).accentColor,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                backgroundColor: Theme.of(cnxt).accentColor,
                onPressed: () {
                  getImage(true, qualityVal);
                  Navigator.pop(context);
                },
                child: Icon(Icons.camera, size: 30.0, color: Colors.white,),
              ),
              FloatingActionButton(
                backgroundColor: Theme.of(cnxt).accentColor,
                onPressed: () {
                  getImage(false, qualityVal);
                  Navigator.pop(context);
                },
                child: Icon(Icons.photo_library_outlined, size: 30.0, color: Colors.white,),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 40.0, bottom: 10.0, top: 20.0),
          alignment: Alignment.centerLeft,
          child: Text('Image quality',
            style: TextStyle(fontSize: 14.0,
              color: Theme.of(cnxt).accentColor,
              fontWeight: FontWeight.normal
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: DropdownButtonFormField(
              value: qualityVal,
              onChanged: (val){
                qualityVal = val;
              },
              items: qualityList.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text('$item quality'),
                );
              }).toList(),
              decoration:InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(cnxt).accentColor,)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(cnxt).accentColor,)
                ),
              ),
            ),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Constants.appName),),
      body: Builder(
        builder: (BuildContext context){
          return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80.0,),
              buildColumn(context),
              SizedBox(height: 20.0,),
            ],
          )
        );
        }
      )
    );
  }


  buildColumn(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10.0,),
              Container(
                alignment: Alignment.center,
                child: Text(widget.furniture.name,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500),),
              ),
              SizedBox(height: 20.0,),
              _image == null ? Container(
                height: 200,
                alignment: Alignment.center,
                child: addImageWidget(context)
              )
              : Container(
                height: 200,
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(_image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20.0),
                ),
              ),
              child: addImageWidget(context)
              ),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.only(top:5.0,bottom: 5.0,left: 10.0,right: 10.0),
                child: TextField(
                  controller: textController,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Name',
                    hintStyle:
                    TextStyle(
                        color: Colors.grey[400]),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              RaisedButton(
                onPressed: () async{

                  if(_image != null)
                  {
                    try {
                        String id = await DatabaseService().createImageID();

                        String url = await FireStorage().uploadFile(id, _image);

                        await DatabaseService().createImageItem( 
                          ImageItem(
                            id: id,
                            furnitureID: widget.furniture.id,
                            url: url,
                            name: textController.text == '' ? widget.furniture.name: textController.text
                          )
                        );
                        
                        Scaffold.of(ctx).showSnackBar(
                          SnackBar(
                            content: Text('Furniture Item Added Successfully!',
                            style: TextStyle(color: Constants.lightPrimary),
                            ),
                            backgroundColor: Theme.of(context).accentColor,
                            elevation: 2.0,
                          ),
                        );
                    } catch (e) {
                      print('Error in add furniture: $e');
                      Scaffold.of(ctx).showSnackBar(
                          SnackBar(
                            content: Text('Error in adding Furniture Item',
                            style: TextStyle(color: Colors.red),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 2.0,
                          ),
                        );
                    }
                    if(_image!= null)
                    {
                      _image.delete(recursive: true);
                      imageCache.clear();
                    }
                    setState(() {_image = null;});
                    
                  }
                },
                color: Theme.of(context).accentColor,
                child: Text('Save',
                style: TextStyle(color: Constants.lightPrimary),
              ),
              ),
              SizedBox(height: 10.0,)
            ],
          ),
        ),
      ),
    );
  }
}