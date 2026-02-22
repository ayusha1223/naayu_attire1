import 'package:hive/hive.dart';

class WishlistService {
  final Box wishlistBox = Hive.box("wishlistBox");

  void addToWishlist(Map<String, dynamic> product) {
    List wishlistItems = wishlistBox.get("items", defaultValue: []);

    // Prevent duplicates
    bool alreadyExists = wishlistItems.any(
      (item) => item["title"] == product["title"],
    );

    if (!alreadyExists) {
      wishlistItems.add(product);
      wishlistBox.put("items", wishlistItems);
    }
  }

  List getWishlistItems() {
    return wishlistBox.get("items", defaultValue: []);
  }

  void removeFromWishlist(int index) {
    List wishlistItems = wishlistBox.get("items", defaultValue: []);
    wishlistItems.removeAt(index);
    wishlistBox.put("items", wishlistItems);
  }

  void clearWishlist() {
    wishlistBox.delete("items");
  }
}