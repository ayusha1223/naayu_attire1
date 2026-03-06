import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  void call(CartItem product) {
    repository.addToCart(product);
  }
}