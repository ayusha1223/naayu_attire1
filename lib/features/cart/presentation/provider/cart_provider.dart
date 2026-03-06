import 'package:flutter/material.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {

  final CartRepository repository;

  CartProvider(this.repository);

  List<CartItem> get cart => repository.getCart();

  void addToCart(CartItem product) {
    repository.addToCart(product);
    notifyListeners();
  }

  void removeFromCart(CartItem product) {
    repository.removeFromCart(product);
    notifyListeners();
  }

  void increaseQty(CartItem product) {
    repository.increaseQty(product);
    notifyListeners();
  }

  void decreaseQty(CartItem product) {
    repository.decreaseQty(product);
    notifyListeners();
  }

  void clearCart() {
    repository.clearCart();
    notifyListeners();
  }
  String paymentMethod = "cod";

void setPaymentMethod(String method) {
  paymentMethod = method;
  notifyListeners();
}

  double get totalPrice {
    return cart.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  double get shippingCharge => 25;

  double get finalTotal => totalPrice + shippingCharge;

}