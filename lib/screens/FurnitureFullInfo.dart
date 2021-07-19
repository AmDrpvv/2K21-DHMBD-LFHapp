import 'package:flutter/material.dart';
import 'package:lfh_app/services/CloudFirestore.dart';
import 'package:lfh_app/services/FireStorage.dart';
import 'package:lfh_app/util/AppEntity.dart';
import 'package:lfh_app/util/Models.dart';
import 'package:lfh_app/util/const.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FurnitureFullInfo extends StatefulWidget {
  final List<ImageItem> imageItemList;
  final int pageIndex;
  FurnitureFullInfo({@required this.imageItemList, @required this.pageIndex});

  @override
  _FurnitureFullInfoState createState() => _FurnitureFullInfoState();
}

class _FurnitureFullInfoState extends State<FurnitureFullInfo> {

  ImageItem _image;
  int pageCount;
  PageController pageController;
  TextEditingController textController;

  updateImage(ImageItem image) async {

    await DatabaseService().updateImageItem(image.id,
    {
      imageItemColumnLike: image.isLiked,
      imageItemColumnCart: image.isCarted
    }
    );
  }

  @override
    void initState() {
      pageCount=widget.pageIndex;
      pageController = PageController(initialPage: widget.pageIndex);
      _image = widget.imageItemList[pageCount];
      textController = TextEditingController();
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    _image = widget.imageItemList[pageCount];
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(_image.name),
    ),
    
    bottomNavigationBar: 
    
      Container(
        color: Colors.black45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Text('Rs ' + _image.price,
              style: TextStyle(fontSize: 18.0, color: Constants.lightPrimary,),
            ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Text(Constants.appName + ' ph: 9811866846',
              style: TextStyle(color: Constants.lightPrimary,),
            ),
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.share, color: Constants.lightPrimary,),
                onPressed: () {
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
                                  [_image.id],
                                  _image.name
                                );
                              },
                            ),
                          ],
                          title: Text("Share Image"),
                          content: Text('Do you want to share the ${_image.name} Image ?')
                        );
                    }
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart,
                color: !_image.isCarted ? Constants.lightPrimary
                : Constants.lightAccent,),
                onPressed: (){
                  setState(() {
                    _image.isCarted = !_image.isCarted;
                  });
                  updateImage(_image);
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite,
                color: !_image.isLiked ? Constants.lightPrimary
                : Constants.lightAccent,),
                onPressed: (){
                  setState(() {
                    _image.isLiked = !_image.isLiked;
                  });
                  updateImage(_image);
                },
              ),
              IconButton(
                icon: Icon(Icons.money_outlined, color: Constants.lightPrimary,),
                onPressed: (){
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
                                  _image.price = textController.text;
                                  await DatabaseService().updateImageItem(_image.id,
                                  {
                                    imageItemColumnPrice: _image.price,
                                  });
                                  setState(() {});
                                } catch (e) {
                                  print('Error In edit price : $e');
                                }
                              }
                              textController.clear();
                              Navigator.of(context).pop();
                            }
                          ),
                        ],
                        title: Text("Edit Your Furniture price"),
                        content: Container(
                          padding: EdgeInsets.all(5.0),
                          child: TextField(
                            controller: textController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration.collapsed(
                              
                              hintText: 'Enter Price',
                              hintStyle: TextStyle(
                                  color: Colors.grey[400]),
                            ),
                          ),
                        ),
                    );
                  }
                );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Constants.lightPrimary,),
                onPressed: () {
                  if(widget.imageItemList.length <= 1) return null;
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
                                try {
                                  await DatabaseService().deleteImageItem(_image.id);
                                  await FireStorage().deleteFile(_image.id);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  
                                } catch (e) {
                                  print('Error In deleting Image : $e');
                                  
                                }
                              Navigator.of(context).pop();
                            }
                          ),
                        ],
                        title: Text("Delete Furniture Image"),
                        content: Text("Do you want to Delete this image ?"),
                    );
                  }
                );
                },
              ),
            ],
          ),
          ], 
        ),
      ),
    body: Container(
      child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(_image.url),
            minScale: 0.5,
            maxScale: 5.0,
          );
        },
        itemCount:widget.imageItemList.length,
        scrollDirection: Axis.horizontal,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
          backgroundDecoration: BoxDecoration(color:Theme.of(context).scaffoldBackgroundColor),
          pageController: pageController,
          onPageChanged: (_page){
            pageCount = _page;
            setState(() {});
          },
      )
    ),
    );
  }
}