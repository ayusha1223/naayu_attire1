import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  CartItemModel({
    required super.id,
    required super.name,
    required super.image,
    required super.price,
    super.quantity = 1,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      price: json["price"],
      quantity: json["quantity"] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "price": price,
      "quantity": quantity,
    };
  }
}