class ProductModel {
  final String id;
  final String image;
  final String? previewImage;
  final String name;
  final double price;
  final String description;
  final double rating;
  final List<String> sizes;
  final String color;
  final bool isNew;
  final double? oldPrice;
  int quantity;

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
    this.quantity = 1, 
  });

  // 🔥 equality for cart
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  // ✅ Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'price': price,
      'description': description,
      'rating': rating,
      'sizes': sizes,
      'color': color,
      'isNew': isNew,
      'oldPrice': oldPrice,
      'quantity': quantity,
    };
  }

  // ✅ Convert from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      rating: (json['rating'] as num).toDouble(),
      sizes: List<String>.from(json['sizes']),
      color: json['color'],
      isNew: json['isNew'],
      oldPrice: json['oldPrice'] != null
          ? (json['oldPrice'] as num).toDouble()
          : null,
      quantity: json['quantity'] ?? 1, 
    );
  }

  get discount => null;
}
