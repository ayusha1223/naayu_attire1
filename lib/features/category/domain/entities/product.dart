class Product {
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
  final String category;
  int quantity;

  Product({
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
}