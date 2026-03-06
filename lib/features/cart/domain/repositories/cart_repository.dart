import '../entities/cart_item.dart';

abstract class CartRepository {

  List<CartItem> getCart();

  void addToCart(CartItem product);

  void removeFromCart(CartItem product);

  void increaseQty(CartItem product);

  void decreaseQty(CartItem product);

  void clearCart();
}