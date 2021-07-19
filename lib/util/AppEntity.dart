import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lfh_app/services/FireStorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

String sharedPrefFavorite = 'Favorite_Furniture';
String sharedPrefCart = 'Cart_Furniture';
String sharedPrefDFS = 'defaultFontSize';
String sharedPrefDarkTheme = 'darkTheme';
String sharedPrefDefaultUrl = 'defaultUrl';

const Map<String, double> quality = {'low': 512.0, 'medium' :720.0,'high': 1080.0};
const List qualityList = ['low', 'medium', 'high'];

Future<Map<String, dynamic>> getSharedPreferences() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return <String, dynamic>{
    sharedPrefFavorite : prefs.getInt(sharedPrefFavorite) ?? 0,
    sharedPrefCart : prefs.getInt(sharedPrefCart) ?? 0, 
    sharedPrefDFS : prefs.getInt(sharedPrefDFS) ?? 0,
    sharedPrefDefaultUrl : prefs.getString(sharedPrefDefaultUrl) ?? 'https://firebasestorage.googleapis.com/v0/b/lfh-online.appspot.com/o/defaultFurniturePic.jpeg?alt=media&token=97f847a8-53bb-4fd8-8e0e-16f50569f9f8',
    sharedPrefDarkTheme : prefs.getBool(sharedPrefDarkTheme) ?? false,
  };
}

Future<String> getImageFileFromAssets(String path, String name) async {
  
  try {
        final byteData = await rootBundle.load('$path');
        String ext = path.split(".").last;
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String pathdir = '${documentsDirectory.path}/SavedImages/$name.$ext';
        final file =
        await File(pathdir).create(recursive: true);
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        imageCache.clear();
        return file.path;
        
  } catch (e) {
        print('error in getImageFileFromAssets : $e');
        return null;
  }

}

Future<List<String>> getImageUrlsFromImageName(List<String> imageName) async{
  List<String> imageUrls = [];
  for(int i=0;i<imageName.length;i++){
    String url = await FireStorage().downloadFile(imageName[i]);
    imageUrls.add(url);
  }
  return imageUrls;
}

deleteImageFromImageUrls(List<String> imageUrls){
  for(int i=0;i<imageUrls.length;i++)
  {
    if(imageUrls[i] != null || imageUrls[i] != ''){
      print('deleted : '+ '${imageUrls[i]}');
      File(imageUrls[i]).delete(recursive: true);
      imageCache.clear();
    }
  }
}


shareFileToOtherDevices(List<String> imgNames, [String name = '']) async{

    try {
      List<String> imgUrls = await  getImageUrlsFromImageName(imgNames);
      if(imgUrls != null || imgUrls != []){
        await Share.shareFiles( imgUrls,
        text: 'Laxmi furniture house shared $name Images with you.\nFor More Details try contact:-\n9811866846, 9868449257',
        subject: 'Laxmi furniture house',
        );
        await Future.delayed(Duration(seconds: 1));
        deleteImageFromImageUrls(imgUrls);
      }
    } catch (e) {
      print('error in sharing $name images : $e');
    }
}

Future<File> getImageFromDevice(bool isCamera, [String qualityVal = 'medium']) async {
  print('${quality[qualityVal]}');
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      maxHeight: quality[qualityVal] ?? 720.0,
      imageQuality: 90,
      maxWidth: quality[qualityVal] ?? 720.0,
  );
  

  if (pickedFile != null) {
    return File(pickedFile.path);

  } else {
    return null;
  }
}

Future<String> saveImageToDevice(File _image, String name) async{

  try {
      String ext = _image.path.split(".").last;
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = '${documentsDirectory.path}/SavedImages/$name.$ext';
      await _image.copy(path);
      await Future.delayed(Duration(seconds: 1));
      _image.delete(recursive: true);
      imageCache.clear();
      return path;    
  } catch (e) {
      print('error in saving Images to Device : $e');
      return null;
  }


}
