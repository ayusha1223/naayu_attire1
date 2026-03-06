import 'package:hive/hive.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String image;

  @HiveField(2)
  final String? previewImage;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final double rating;

  @HiveField(7)
  final List<String> sizes;

  @HiveField(8)
  final String color;

  @HiveField(9)
  final bool isNew;

  @HiveField(10)
  final double? oldPrice;

  @HiveField(11)
  final String category;

  @HiveField(12)
  final int quantity;

  ProductModel({
    required this.id,
    required this.image,
    this.previewImage,
    required this.name,
    required this.price,
    required this.description,
    required this.rating,
    required this.sizes,
    required this.color,
    required this.isNew,
    this.oldPrice,
    required this.category,
    this.quantity = 1,
  });

  // ================= ENTITY CONVERSION =================

  Product toEntity() {
    return Product(
      id: id,
      image: image,
      previewImage: previewImage,
      name: name,
      price: price,
      description: description,
      rating: rating,
      sizes: sizes,
      color: color,
      isNew: isNew,
      oldPrice: oldPrice,
      category: category,
      quantity: quantity,
    );
  }

  // ================= FROM JSON =================

  factory ProductModel.fromJson(Map<String, dynamic> json) {

    String image = json['image'] ?? "";
    String? previewImage = json['previewImage'];

    /// Convert relative path → full URL
    if (image.isNotEmpty && !image.startsWith("http")) {
      image = "http://192.168.1.74:3000$image";
    }

    if (previewImage != null && !previewImage.startsWith("http")) {
      previewImage = "http://192.168.1.74:3000$previewImage";
    }

    return ProductModel(
      id: json['_id'] ?? "",
      image: image,
      previewImage: previewImage,
      name: json['name'] ?? "",
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description'] ?? "",
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      sizes: List<String>.from(json['sizes'] ?? []),
      color: json['color'] ?? "",
      isNew: json['isNew'] ?? false,
      oldPrice: json['oldPrice'] != null
          ? (json['oldPrice'] as num).toDouble()
          : null,
      category: json['category'] ?? "",
      quantity: 1,
    );
  }

  // ================= TO JSON =================

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "image": image,
      "previewImage": previewImage,
      "name": name,
      "price": price,
      "description": description,
      "rating": rating,
      "sizes": sizes,
      "color": color,
      "isNew": isNew,
      "oldPrice": oldPrice,
      "category": category,
    };
  }
}