import 'package:flutter/material.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';
import 'package:provider/provider.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Consumer<ShopProvider>(
        builder: (context, shop, _) {

          if (shop.cart.isEmpty) {
            return const Center(
              child: Text("Your Cart is Empty"),
            );
          }

          return ListView.builder(
            itemCount: shop.cart.length,
            itemBuilder: (context, index) {
              final product = shop.cart[index];

              return ListTile(
                leading: Image.asset(product.image, width: 60),
                title: Text(product.name),
                subtitle: Text("Rs. ${product.price}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    shop.removeFromCart(product);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
