class CategoryModel {
  final String title;
  final String image;

  CategoryModel({required this.title, required this.image});
}

final List<CategoryModel> categories = [
  CategoryModel(
    title: "Casual",
    image: "assets/images/categories/casual.jpg",
  ),
  CategoryModel(
    title: "Co-ord",
    image: "assets/images/categories/coord.jpg",
  ),
  CategoryModel(
    title: "Wedding",
    image: "assets/images/categories/wedding.jpg",
  ),
  CategoryModel(
    title: "Party",
    image: "assets/images/categories/party.jpg",
  ),
  CategoryModel(
    title: "One Piece",
    image: "assets/images/categories/onepiece.jpg",
  ),
   CategoryModel(
    title: "Winter",
    image: "assets/images/categories/winter.jpg",
  ),
];
