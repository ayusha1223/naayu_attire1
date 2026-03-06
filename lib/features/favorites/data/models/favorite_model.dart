import '../../domain/entities/favorite_item.dart';

class FavoriteModel extends FavoriteItem {

  FavoriteModel({
    required super.id,
    required super.name,
    required super.price,
    required super.image,
  });

  factory FavoriteModel.fromJson(Map<String,dynamic> json){
    return FavoriteModel(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      image: json["image"],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "name": name,
      "price": price,
      "image": image,
    };
  }
}