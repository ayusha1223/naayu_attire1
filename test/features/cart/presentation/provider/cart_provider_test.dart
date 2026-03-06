import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:naayu_attire1/features/cart/presentation/provider/cart_provider.dart';
import 'package:naayu_attire1/features/cart/domain/repositories/cart_repository.dart';
import 'package:naayu_attire1/features/cart/domain/entities/cart_item.dart';

/// ---------------- MOCK ----------------

class MockCartRepository extends Mock implements CartRepository {}

class FakeCartItem extends Fake implements CartItem {}

void main() {

  late MockCartRepository repository;
  late CartProvider provider;

  setUpAll(() {
    registerFallbackValue(FakeCartItem());
  });

  setUp(() {
    repository = MockCartRepository();
    provider = CartProvider(repository);
  });

  /// ---------------- ADD TO CART ----------------

  test("addToCart should call repository.addToCart", () {

    final item = CartItem(
      id: "1",
      name: "Shirt",
      image: "shirt.png",
      price: 100,
      quantity: 1,
    );

    provider.addToCart(item);

    verify(() => repository.addToCart(item)).called(1);
  });

  /// ---------------- REMOVE FROM CART ----------------

  test("removeFromCart should call repository.removeFromCart", () {

    final item = CartItem(
      id: "1",
      name: "Shirt",
      image: "shirt.png",
      price: 100,
      quantity: 1,
    );

    provider.removeFromCart(item);

    verify(() => repository.removeFromCart(item)).called(1);
  });

  /// ---------------- INCREASE QTY ----------------

  test("increaseQty should call repository.increaseQty", () {

    final item = CartItem(
      id: "1",
      name: "Shirt",
      image: "shirt.png",
      price: 100,
      quantity: 1,
    );

    provider.increaseQty(item);

    verify(() => repository.increaseQty(item)).called(1);
  });

  /// ---------------- DECREASE QTY ----------------

  test("decreaseQty should call repository.decreaseQty", () {

    final item = CartItem(
      id: "1",
      name: "Shirt",
      image: "shirt.png",
      price: 100,
      quantity: 1,
    );

    provider.decreaseQty(item);

    verify(() => repository.decreaseQty(item)).called(1);
  });

  /// ---------------- CLEAR CART ----------------

  test("clearCart should call repository.clearCart", () {

    provider.clearCart();

    verify(() => repository.clearCart()).called(1);
  });

  /// ---------------- PAYMENT METHOD ----------------

  test("setPaymentMethod should update payment method", () {

    provider.setPaymentMethod("esewa");

    expect(provider.paymentMethod, "esewa");
  });

}