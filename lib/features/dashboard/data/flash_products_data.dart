class FlashProduct {
  final String imagePath;
  final int price;

  FlashProduct({
    required this.imagePath,
    required this.price,
  });
}

final List<FlashProduct> flashProducts = [
  FlashProduct(
    imagePath: "assets/images/splash/wedding5.png",
    price: 2999,
  ),
  FlashProduct(
    imagePath: "assets/images/splash/wedding1.png",
    price: 3499,
  ),
  FlashProduct(
    imagePath: "assets/images/splash/wedding6.png",
    price: 2799,
  ),
  FlashProduct(
    imagePath: "assets/images/splash/wedding4.png",
    price: 3999,
  ),
];
