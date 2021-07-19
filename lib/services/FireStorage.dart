import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class FireStorage{
  FirebaseStorage storage = FirebaseStorage.instance;


  Future<String> uploadFile(String fileName, File file) async {

    try {
      Reference reference = storage.ref()
      .child('images')
      .child('$fileName');
      UploadTask task = reference.putFile(file);
      var url;
      await task.whenComplete((){
        url = reference.getDownloadURL();
      });
      return url; 
    } catch (e) {
      print('Error in upload File $e');
      return null;
    }
  }


  deleteFile(String fileName) async {
    try {
      await storage.ref()
      .child('images')
      .child('$fileName').delete();
    } catch (e) {
      print('Error in upload File $e');
    }
  }

  Future<String> downloadFile(String fileName) async {
    
    try {
      String url;

      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String pathdir = '${documentsDirectory.path}/images/$fileName.jpg';
      final downloadToFile =
      await File(pathdir).create(recursive: true);

      Reference reference = storage.ref()
      .child('images')
      .child('$fileName');
      DownloadTask task = reference.writeToFile(downloadToFile);
      await task.whenComplete(
        (){
          url = downloadToFile.path;
        }
      );
      return url;
    } on FirebaseException catch (e) {
      print('error in downloading files $e');
      return null;
    }
  }
}