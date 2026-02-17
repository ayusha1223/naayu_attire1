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
    imagePath: "assets/images/splash/onepiece3.png",
    title: "Cotton",
    price: 999,
    oldPrice: 1299,
  ),
  FlashProduct(
    imagePath: "assets/images/splash/onepiece4.png",
    title: "Siyaa",
    price: 1199,
    oldPrice: 1899,
  ),
  FlashProduct(
    imagePath: "assets/images/splash/onepiece14.png",
    title: "V-neck",
    price: 1099,
    oldPrice: 1299,
  ),
  FlashProduct(
    imagePath: "assets/images/splash/onepiece4.png",
    title: "Royal Lehenga Set",
    price: 2799,
    oldPrice: 3099,
  ),
  FlashProduct(
    imagePath: "assets/images/splash/onepiece14.png",
    title: "Designer Bridal Wear",
    price: 3999,
    oldPrice: 4399,
  ),
];
