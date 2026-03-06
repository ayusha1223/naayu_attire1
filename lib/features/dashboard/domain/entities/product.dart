class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final double? oldPrice;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.oldPrice,
  });
}