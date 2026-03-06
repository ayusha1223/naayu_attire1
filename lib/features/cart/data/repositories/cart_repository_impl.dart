import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {

  final List<CartItem> _cart = [];

  @override
  List<CartItem> getCart() {
    return _cart;
  }

  @override
  void addToCart(CartItem product) {
    int index = _cart.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      _cart[index].quantity++;
    } else {
      _cart.add(product);
    }
  }
  @override
void clearCart() {
  _cart.clear();
}

  @override
  void removeFromCart(CartItem product) {
    _cart.removeWhere((item) => item.id == product.id);
  }

  @override
  void increaseQty(CartItem product) {
    int index = _cart.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _cart[index].quantity++;
    }
  }

  @override
  void decreaseQty(CartItem product) {
    int index = _cart.indexWhere((item) => item.id == product.id);
    if (index >= 0 && _cart[index].quantity > 1) {
      _cart[index].quantity--;
    }
  }
}