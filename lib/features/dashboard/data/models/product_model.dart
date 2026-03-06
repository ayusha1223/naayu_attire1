import 'package:naayu_attire1/features/cart/domain/entities/cart_item.dart';

class ProductModel {
  final String id;
  final String name;
  final String image;
  final double price;
  final double? oldPrice;
  final String description;
  final double rating;
  final String category;
  final String color;
  final bool isNew;

  int quantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.oldPrice,
    required this.description,
    required this.rating,
    required this.category,
    required this.color,
    required this.isNew,
    this.quantity = 1,
  });

  // JSON → OBJECT
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      oldPrice: json['oldPrice'] != null
          ? (json['oldPrice']).toDouble()
          : null,
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      color: json['color'] ?? '',
      isNew: json['isNew'] ?? false,
    );
  }

  // OBJECT → JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "image": image,
      "price": price,
      "oldPrice": oldPrice,
      "description": description,
      "rating": rating,
      "category": category,
      "color": color,
      "isNew": isNew,
      "quantity": quantity,
    };
  }

  // ✅ PRODUCT → CART ITEM CONVERTER
  CartItem toCartItem() {
    return CartItem(
      id: id,
      name: name,
      price: price,
      image: image,
      quantity: quantity,
    );
  }
}