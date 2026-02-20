class FlashProduct {
  final String imagePath;
  final String title;
  final int price;
  final int oldPrice;

  FlashProduct({
    required this.imagePath,
    required this.title,
    required this.price,
    required this.oldPrice,
  });
}

final List<FlashProduct> flashProducts = [
  FlashProduct(
    imagePath: "assets/images/splash/onepiece2.png",
    title: "Chaubandi",
    price: 1200,
    oldPrice: 1999,
  ),
  FlashProduct(
    imagePath: "assets/images/onepiece/onepiece3.png",
    title: "Cotton",
    price: 999,
    oldPrice: 1299,
  ),
];
