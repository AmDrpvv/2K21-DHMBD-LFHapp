// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';

// final String furnitureTableName = 'FurnitureTable';
// final String furnitureColumnID = 'id';
// final String furnitureColumnName = 'name';

// final String imageTableName = 'ImageTable';
// final String imageColumnID = 'id';
// final String imageColumnName = 'name';
// final String imageColumnURL = 'url';
// final String imageColumnLike = 'isLiked';
// final String imageColumnCart = 'isCarted';

// final String furnitureImageTableName = 'FurnitureImageTable';
// final String furnitureImageColumnFID = 'furnitureID';
// final String furnitureImageColumnIID = 'imageID';

// class Furniture{
//   int id;
//   String name;
//   List<Images> imagesList;
//   Furniture({this.id, this.name});

//   Furniture.fromMap(Map<String, dynamic> map){
//     id = map[furnitureColumnID];
//     name = map[furnitureColumnName];
//   }
  
//   Map<String, dynamic> toMap(){
//     var map = <String, dynamic>{
//       furnitureColumnName : name
//     };
//     if(id != null){
//       map[furnitureColumnID] = id;
//     }
//     return map;
//   }

//   String repr(){
//     return 'Furniture : $id , $name';
//   }
// }

// class FurnitureImages{
//   int furnitureID;
//   int imageID;
//   FurnitureImages({this.furnitureID, this.imageID});

//   FurnitureImages.fromMap(Map<String, dynamic> map){
//     furnitureID = map[furnitureImageColumnFID];
//     imageID = map[furnitureImageColumnIID];
//   }
  
//   Map<String, dynamic> toMap(){
//     return <String, dynamic>{
//       furnitureImageColumnFID : furnitureID,
//       furnitureImageColumnIID : imageID
//     };
//   }

//   String repr(){
//     return 'FurnitureImage : $furnitureID , $imageID';
//   }

// }

// class Images{
//   int id;
//   String name;
//   String url;
//   int isLiked;
//   int isCarted;

//   Images({this.id, this.name, this.url, this.isCarted, this.isLiked});

//   Images.fromMap(Map<String, dynamic> map){
//     id = map[imageColumnID];
//     name = map[imageColumnName];
//     url = map[imageColumnURL];
//     isLiked = map[imageColumnLike];
//     isCarted = map[imageColumnCart];
//   }
  
//   Map<String, dynamic> toMap(){
//     var map = <String, dynamic>{
//       imageColumnName : name,
//       imageColumnURL : url,
//       imageColumnLike : isLiked,
//       imageColumnCart : isCarted,
//     };
//     if(id != null){
//       map[imageColumnID] = id;
//     }
//     return map;
//   }

//   String repr(){
//     return 'Image : $id , $name, $url, $isLiked, $isCarted';
//   }
// }


// //define database helper class

// class DatabaseHelper {

//   // This is the actual database filename that is saved in the docs directory.
//   static final _databaseName = "LFH_DATABASE.db";
//   // Increment this version when you need to change the schema.
//   static final _databaseVersion = 1;

//   // Make this a singleton class.
//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   // Only allow a single open connection to the database.
//   static Database _database;
//   Future<Database> get database async {
//     if (_database != null) return _database;
//     _database = await _initDatabase();
//     return _database;
//   }

//   // open the database
//   _initDatabase() async {
//     // The path_provider plugin gets the right directory for Android or iOS.
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _databaseName);
//     print('database created at : $path');
//     // Open the database. Can also add an onUpdate callback parameter.
//     return await openDatabase(path,
//         version: _databaseVersion,
//         onCreate: _onCreate);
//   }

//   // SQL string to create the database 
//   Future _onCreate(Database db, int version) async {
//     await db.execute('PRAGMA foreign_keys = ON');
//     await db.execute('''
//           CREATE TABLE $furnitureTableName (
//             $furnitureColumnID INTEGER PRIMARY KEY,
//             $furnitureColumnName TEXT NOT NULL UNIQUE
//           )
//           ''');
//     await db.execute('''
//         CREATE TABLE $imageTableName (
//             $imageColumnID INTEGER PRIMARY KEY,
//             $imageColumnName TEXT NOT NULL,
//             $imageColumnURL TEXT NOT NULL UNIQUE,
//             $imageColumnLike INTEGER NOT NULL,
//             $imageColumnCart INTEGER NOT NULL
//             )''');

//     await db.execute('''
//           CREATE TABLE $furnitureImageTableName (
//             $furnitureImageColumnFID INTEGER,
//             $furnitureImageColumnIID INTEGER,
//             FOREIGN KEY($furnitureImageColumnFID) REFERENCES $furnitureTableName($furnitureColumnID),
//             FOREIGN KEY($furnitureImageColumnIID) REFERENCES $imageTableName($imageColumnID)
//           )
//           ''');
//   }

//   // Database helper methods:

//   Future<int> insertFurniture(Furniture furniture) async {
//     Database db = await database;
//     int id = await db.insert(furnitureTableName, furniture.toMap());
//     return id;
//   }


//   Future<Furniture> queryFurniture(int id) async {
//     Database db = await database;
//     List<Map> maps = await db.query(furnitureTableName,
//         columns: [furnitureColumnID, furnitureColumnName],
//         where: '$furnitureColumnID = ?',
//         whereArgs: [id]);
//     if (maps.length > 0) {
//       return Furniture.fromMap(maps.first);
//     }
//     return null;
//   }

//   Future<int> insertFurnitureImage(FurnitureImages fImage) async {
//     Database db = await database;
//     int id = await db.insert(furnitureImageTableName, fImage.toMap());
//     return id;
//   }


//   Future<FurnitureImages> queryFurnitureImage(int fID, int iID) async {
//     Database db = await database;
//     List<Map> maps = await db.query(furnitureImageTableName,
//         columns: [furnitureImageColumnFID, furnitureImageColumnIID],
//         where: '$furnitureImageColumnFID = ? and $furnitureImageColumnIID = ?',
//         whereArgs: [fID, iID]);
//     if (maps.length > 0) {
//       return FurnitureImages.fromMap(maps.first);
//     }
//     return null;
//   }

//   Future<List<Images>> queryImagesFromFurniture(int fID) async {
//     List<Images> fImageList = [];
//     Database db = await database;
//     List<Map> maps = await db.query(furnitureImageTableName,
//         columns: [furnitureImageColumnFID, furnitureImageColumnIID],
//         where: '$furnitureImageColumnFID = ?',
//         whereArgs: [fID]);
//     if (maps.length > 0) {
//       for(int i=0; i< maps.length; i++) {
//         Images img = await queryImage(maps[i][furnitureImageColumnIID]);
//         fImageList.add(img);
//       }
//     }
//     return fImageList;
//   }

//     Future<List<Images>> queryFavImages() async {
//     List<Images> fImageList = [];
//     Database db = await database;
//     List<Map> maps = await db.query(imageTableName,
//         columns: [imageColumnID, imageColumnName, imageColumnURL, imageColumnLike, imageColumnCart],
//         where: '$imageColumnLike = 1');
//     if (maps.length > 0) {
//       for(int i=0; i< maps.length; i++) {
//         fImageList.add(Images.fromMap(maps[i]));
//       }
//     }
//     return fImageList;
//   }

//   Future<List<Images>> queryCartImages() async {
//     List<Images> fImageList = [];
//     Database db = await database;
//     List<Map> maps = await db.query(imageTableName,
//         columns: [imageColumnID, imageColumnName, imageColumnURL, imageColumnLike, imageColumnCart],
//         where: '$imageColumnCart = 1');
//     if (maps.length > 0) {
//       for(int i=0; i< maps.length; i++) {
//         fImageList.add(Images.fromMap(maps[i]));
//       }
//     }
//     return fImageList;
//   }

//   Future<List<Furniture>> queryAllFurniture() async {
//     List<Furniture> furnitureList = [];
//     Database db = await database;
//     List<Map> maps = await db.query(furnitureTableName,
//         columns: [furnitureColumnID, furnitureColumnName]);
//     if (maps.length > 0) {
//       for(int i=0; i< maps.length; i++) {
//         furnitureList.add(Furniture.fromMap(maps[i]));
//       }
//     }
//     return furnitureList;
//   }


//   Future<int> insertImage(Images img) async {
//     Database db = await database;
//     int id = await db.insert(imageTableName, img.toMap());
//     return id;
//   }

//   Future<Images> queryImage(int id) async {
//     Database db = await database;
//     List<Map> maps = await db.query(imageTableName,
//         columns: [imageColumnID, imageColumnName, imageColumnURL, imageColumnLike, imageColumnCart],
//         where: '$imageColumnID = $id',
//         );
//     if (maps.length > 0) {
//       return Images.fromMap(maps.first);
//     }
//     return null;
//   }

//   Future<Images> queryImageWithURL(String url) async {
//     Database db = await database;
//     List<Map> maps = await db.query(imageTableName,
//         columns: [imageColumnID, imageColumnName, imageColumnURL, imageColumnLike, imageColumnCart],
//         where: '$imageColumnURL = "$url"'
//         );
//     if (maps.length > 0) {
//       return Images.fromMap(maps.first);
//     }
//     return null;
//   }
  
//   Future<List<Images>> queryAllImages() async {
//     List<Images> imageList = [];
//     Database db = await database;
//     List<Map> maps = await db.query(imageTableName,
//     columns: [imageColumnID, imageColumnName, imageColumnURL, imageColumnLike, imageColumnCart]);
//     if (maps.length > 0) {
//       for(int i=0; i< maps.length; i++) {
//         imageList.add(Images.fromMap(maps[i]));
//       }
//     }
//     return imageList;
//   }
//   // TODO: delete(int id)
//   Future<int> deleteFurniture(int id) async {
//     Database db = await database;
//     return await db.delete(furnitureTableName, where: '$furnitureColumnID = ?', whereArgs: [id]);
//   }

//   Future<int> deleteFurnitureImages(int fID, int iID) async {
//     Database db = await database;
//     try {
//       return await db.delete(furnitureImageTableName,
//       where: '$furnitureImageColumnFID = ? and $furnitureImageColumnIID = ?',
//       whereArgs: [fID, iID]);
//     } catch (e) {
//       print('error in deleting furnitureImages : $e');
//       return null;
//     }
//   }
  
//   Future<int> deleteFurnitureImagesWithID(int iID) async {
//     Database db = await database;
//     try {
//       return await db.delete(furnitureImageTableName,
//       where: '$furnitureImageColumnIID = ?',
//       whereArgs: [iID]);
//     } catch (e) {
//       print('error in deleting furnitureImages : $e');
//       return null;
//     }
//   }

//   Future<int> deleteImages(int id) async {
//     Database db = await database;
//     return await db.delete(imageTableName, where: '$imageColumnID = ?', whereArgs: [id]);
//   }

//   // TODO: update(Word word)

//   Future<int> updateFurniture(Furniture furniture) async {
//     Database db = await database;
//     return await db.update(furnitureTableName, furniture.toMap(),
//     where: '$furnitureColumnID = ?', whereArgs: [furniture.id]);
//   }

//   Future<int> updateImage(Images img) async {
//     Database db = await database;
//     return await db.update(imageTableName, img.toMap(),
//     where: '$imageColumnID = ?', whereArgs: [img.id]);
//   }

//   Future<int> updateFurnitureImage(FurnitureImages fImg) async {
//     Database db = await database;
//     return await db.update(furnitureImageTableName, fImg.toMap(),
//     where: '$furnitureImageColumnFID = ? and $furnitureImageColumnIID = ?',
//     whereArgs: [fImg.furnitureID, fImg.imageID]);
//   }

//   deleteDatabse(String path) async{
//     await deleteDatabase(path);
//   }
// }