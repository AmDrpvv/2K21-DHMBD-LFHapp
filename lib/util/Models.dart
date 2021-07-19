
final String furnitureItemColumnID = 'id';
final String furnitureItemColumnName = 'name';
final String furnitureItemColumnUrl = 'imgUrl';


final String imageItemColumnID = 'id';
final String imageItemColumnFurnitureID = 'furnitureID';
final String imageItemColumnName = 'name';
final String imageItemColumnPrice = 'price';
final String imageItemColumnURL = 'url';
final String imageItemColumnLike = 'isLiked';
final String imageItemColumnCart = 'isCarted';


class FurnitureItem{
  String id;
  String name;
  String url;

  FurnitureItem({this.id, this.name, this.url});

  FurnitureItem.fromMap(Map<String, dynamic> map){
    id = map[furnitureItemColumnID] ?? '';
    name = map[furnitureItemColumnName] ?? '';
    url = map[furnitureItemColumnUrl] ?? '';
  }
  
  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      furnitureItemColumnName : name ?? '',
      furnitureItemColumnUrl : url ?? ''
    };
    if(id != null){
      map[furnitureItemColumnID] = id;
    }
    return map;
  }

  String repr(){
    return 'Furniture : $id , $name, $url';
  }
}


class ImageItem{
  String id;
  String furnitureID;
  String price;
  String name;
  String url;
  bool isLiked;
  bool isCarted;

  ImageItem({this.id, this.furnitureID, this.price,
  this.name, this.url, this.isCarted, this.isLiked});

  ImageItem.fromMap(Map<String, dynamic> map){
    id = map[imageItemColumnID] ?? '';
    furnitureID = map[imageItemColumnFurnitureID] ?? '';
    price = map[imageItemColumnPrice] ?? '00';
    name = map[imageItemColumnName] ?? '';
    url = map[imageItemColumnURL] ?? '';
    isLiked = map[imageItemColumnLike] ?? false;
    isCarted = map[imageItemColumnCart] ?? false;
  }
  
  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      imageItemColumnName : name ?? '',
      imageItemColumnPrice : price ?? '00',
      imageItemColumnFurnitureID : furnitureID ?? '',
      imageItemColumnURL : url ?? '',
      imageItemColumnLike : isLiked ?? false,
      imageItemColumnCart : isCarted ?? false,
    };
    if(id != null){
      map[imageItemColumnID] = id;
    }
    return map;
  }

  String repr(){
    return 'Image : $id , $furnitureID, $price $name, $url, $isLiked, $isCarted';
  }
}

