import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:naayu_attire1/features/category/domain/models/product_model.dart';
import 'package:naayu_attire1/features/address/domain/models/address_model.dart';

class ShopProvider extends ChangeNotifier {

  // ================= VARIABLES =================

  final List<ProductModel> _cart = [];
  final List<ProductModel> _favorites = [];

  AddressModel? _address;

  String _deliveryType = "standard";
  String _paymentMethod = "cod";

  // ================= GETTERS =================

  List<ProductModel> get cart => _cart;
  List<ProductModel> get favorites => _favorites;

  AddressModel? get address => _address;

  String get deliveryType => _deliveryType;
  String get paymentMethod => _paymentMethod;

  double get totalPrice =>
      _cart.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get shippingCharge =>
      _deliveryType == "express" ? 100 : 25;

  double get finalTotal => totalPrice + shippingCharge;

  // ================= CONSTRUCTOR =================

  ShopProvider() {
    loadData();
  }

  // ================= CART =================

  void addToCart(ProductModel product) {
    int index =
        _cart.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      _cart[index].quantity++;
    } else {
      _cart.add(product);
    }

    saveData();
    notifyListeners();
  }

  void removeFromCart(ProductModel product) {
    _cart.removeWhere((item) => item.id == product.id);
    saveData();
    notifyListeners();
  }

  void increaseQty(ProductModel product) {
    int index =
        _cart.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      _cart[index].quantity++;
      saveData();
      notifyListeners();
    }
  }

  void decreaseQty(ProductModel product) {
    int index =
        _cart.indexWhere((item) => item.id == product.id);

    if (index >= 0 &&
        _cart[index].quantity > 1) {
      _cart[index].quantity--;
      saveData();
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    saveData();
    notifyListeners();
  }

  // ================= FAVORITES =================

  void toggleFavorite(ProductModel product) {
    if (_favorites.any((item) => item.id == product.id)) {
      _favorites.removeWhere(
          (item) => item.id == product.id);
    } else {
      _favorites.add(product);
    }

    saveData();
    notifyListeners();
  }

  bool isFavorite(ProductModel product) {
    return _favorites
        .any((item) => item.id == product.id);
  }

  // ================= ADDRESS =================

  void setAddress(AddressModel address) {
    _address = address;
    saveData();
    notifyListeners();
  }

  void clearAddress() {
    _address = null;
    saveData();
    notifyListeners();
  }

  // ================= DELIVERY =================

  void setDeliveryType(String type) {
    _deliveryType = type;
    saveData();
    notifyListeners();
  }

  // ================= PAYMENT =================

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    saveData();
    notifyListeners();
  }

  // ================= LOCAL STORAGE =================

  Future<void> saveData() async {
    final prefs =
        await SharedPreferences.getInstance();

    // CART
    prefs.setString(
      'cart',
      jsonEncode(
          _cart.map((e) => e.toJson()).toList()),
    );

    // FAVORITES
    prefs.setString(
      'favorites',
      jsonEncode(
          _favorites.map((e) => e.toJson()).toList()),
    );

    // ADDRESS
    if (_address != null) {
      prefs.setString(
        'address',
        jsonEncode({
          'name': _address!.name,
          'fullAddress':
              _address!.fullAddress,
          'phone': _address!.phone,
          'email': _address!.email,
        }),
      );
    } else {
      prefs.remove('address');
    }

    // DELIVERY TYPE
    prefs.setString(
        'deliveryType', _deliveryType);

    // PAYMENT METHOD
    prefs.setString(
        'paymentMethod', _paymentMethod);
  }

  Future<void> loadData() async {
    final prefs =
        await SharedPreferences.getInstance();

    final cartData =
        prefs.getString('cart');
    final favData =
        prefs.getString('favorites');
    final addressData =
        prefs.getString('address');
    final deliveryTypeData =
        prefs.getString('deliveryType');
    final paymentMethodData =
        prefs.getString('paymentMethod');

    // CART
    if (cartData != null) {
      List decoded =
          jsonDecode(cartData);
      _cart.addAll(decoded.map(
          (e) =>
              ProductModel.fromJson(e)));
    }

    // FAVORITES
    if (favData != null) {
      List decoded =
          jsonDecode(favData);
      _favorites.addAll(decoded.map(
          (e) =>
              ProductModel.fromJson(e)));
    }

    // ADDRESS
    if (addressData != null) {
      final decoded =
          jsonDecode(addressData);

      _address = AddressModel(
        name: decoded['name'],
        fullAddress:
            decoded['fullAddress'],
        phone: decoded['phone'],
        email: decoded['email'],
      );
    }

    // DELIVERY TYPE
    if (deliveryTypeData != null) {
      _deliveryType =
          deliveryTypeData;
    }

    // PAYMENT METHOD
    if (paymentMethodData != null) {
      _paymentMethod =
          paymentMethodData;
    }

    notifyListeners();
  }
}
