import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lfh_app/util/Models.dart';

class DatabaseService{
  final CollectionReference furnitureCollection = FirebaseFirestore.instance.collection('Furniture Collection');
  final CollectionReference imageCollection = FirebaseFirestore.instance.collection('Image Collection');

  //Convert stream into Furniture list
  List<FurnitureItem> changeQuerySnapshotIntoFurniture(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return FurnitureItem.fromMap(doc.data());
    }).toList();
  }

  //Convert stream into Image list
  List<ImageItem> changeQuerySnapshotIntoImageItem(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      return ImageItem.fromMap(doc.data());
    }).toList();
  }


  //create Furniture
  Future createFurnitureID() async {
    return furnitureCollection.doc().id;
  }

  Future createFurnitureItem(FurnitureItem furnitureItem) async {
    return await furnitureCollection.doc(furnitureItem.id).set(furnitureItem.toMap());
  }
  //update Furniture
  Future updateFurnitureItem (FurnitureItem furnitureItem) async{
    return await furnitureCollection.doc(furnitureItem.id).update(furnitureItem.toMap());
  }

  // get Furniture stream
  Stream<List<FurnitureItem>> get furnitureStream{
    return furnitureCollection.snapshots()
    .map(changeQuerySnapshotIntoFurniture);
  }


  //create ImageItem
  Future createImageID() async{
    return imageCollection.doc().id;
  }

  Future createImageItem(ImageItem imageItem) async{
    return await imageCollection.doc(imageItem.id).set(imageItem.toMap());
  }

  //update ImageItem
  Future updateImageItem(String id, Map<String, dynamic> dataToUpdate) async{
    return await imageCollection.doc(id).update(dataToUpdate);
  }
  //update ImageItem
  Future deleteImageItem(String id) async{
    return await imageCollection.doc(id).delete();
  }
  //get Furniture images stream
  Future<List<ImageItem>> getimageItemList(String fID) async {
    var map = await imageCollection.where(imageItemColumnFurnitureID, isEqualTo: fID).get();
    return changeQuerySnapshotIntoImageItem(map);
  }
  //get Favorites and cart item
  Future<List<ImageItem>> getFavOrCartItemList(bool isFav) async {
    String field = isFav ? imageItemColumnLike : imageItemColumnCart;
    var map = await imageCollection.where(field, isEqualTo: true).get();
    return changeQuerySnapshotIntoImageItem(map);
  }

}