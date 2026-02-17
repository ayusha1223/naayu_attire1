class ProductModel {
  final String id;
  final String name;
  final String image;
  final double price;
  final double? oldPrice;

  final String? color; // keep existing
  final bool isNew;    // keep existing

  // 🔥 NEW FIELDS
  final List<String> sizes;
  final String description;
  final double rating;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.color,
    this.oldPrice,
    this.isNew = false,

    // 🔥 NEW FIELDS (with defaults so old data doesn’t break)
    this.sizes = const ["S", "M", "L", "XL"],
    this.description =
        "Premium quality fabric. Comfortable fit. Perfect for any occasion.",
    this.rating = 4.5,
  });
}
