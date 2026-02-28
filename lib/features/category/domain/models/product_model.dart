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
  final String category; // 🔥 ADD THIS
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
    required this.category, // 🔥 ADD THIS
    this.quantity = 1,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  // ✅ Convert to JSON (for POST request)
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'price': price,
      'description': description,
      'rating': rating,
      'sizes': sizes,
      'color': color,
      'isNew': isNew,
      'oldPrice': oldPrice,
      'category': category, // 🔥 IMPORTANT
    };
  }

  // ✅ Convert from JSON (for GET request)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'], // 🔥 MongoDB uses _id
      image: json['image'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      rating: (json['rating'] as num).toDouble(),
      sizes: List<String>.from(json['sizes'] ?? []),
      color: json['color'],
      isNew: json['isNew'],
      oldPrice: json['oldPrice'] != null
          ? (json['oldPrice'] as num).toDouble()
          : null,
      category: json['category'], // 🔥 IMPORTANT
      quantity: 1,
    );
  }

  get discount => null;
}