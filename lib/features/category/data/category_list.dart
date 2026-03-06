class CategoryModel {
  final String title;
  final String image;
  final String value;   // 🔥 ADD THIS

  CategoryModel({
    required this.title,
    required this.image,
    required this.value,
  });
}

final List<CategoryModel> categories = [
  CategoryModel(
    title: "Casual",
    image: "assets/images/categories/casual.jpg",
    value: "casual",
  ),
  CategoryModel(
    title: "Co-ord",
    image: "assets/images/categories/coord.jpg",
    value: "coord",
  ),
  CategoryModel(
    title: "Wedding",
    image: "assets/images/categories/wedding.jpg",
    value: "wedding",
  ),
  CategoryModel(
    title: "Party",
    image: "assets/images/categories/party.jpg",
    value: "party",
  ),
  CategoryModel(
    title: "One Piece",
    image: "assets/images/categories/onepiece.jpg",
    value: "onepiece",
  ),
  CategoryModel(
    title: "Winter",
    image: "assets/images/categories/winter.jpg",
    value: "winter",
  ),
];