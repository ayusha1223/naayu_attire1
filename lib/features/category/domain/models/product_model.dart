class ProductModel {
  final String id;
  final String name;
  final String image;
  final double price;
  final double? oldPrice;
  final String? color;
  final bool isNew;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.color,
    this.oldPrice,
    this.isNew = false,
  });
}
