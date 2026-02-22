import 'package:hive/hive.dart';

class CartService {
  final Box cartBox = Hive.box("cartBox");

  void addToCart(Map<String, dynamic> product) {
    List cartItems = cartBox.get("items", defaultValue: []);
    cartItems.add(product);
    cartBox.put("items", cartItems);
  }

  List getCartItems() {
    return cartBox.get("items", defaultValue: []);
  }

  void removeFromCart(int index) {
    List cartItems = cartBox.get("items", defaultValue: []);
    cartItems.removeAt(index);
    cartBox.put("items", cartItems);
  }

  void clearCart() {
    cartBox.delete("items");
  }
}