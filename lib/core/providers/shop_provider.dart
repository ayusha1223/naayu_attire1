import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:naayu_attire1/core/api/api_client.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:naayu_attire1/features/category/domain/models/product_model.dart';
import 'package:naayu_attire1/features/address/domain/models/address_model.dart';
import 'package:naayu_attire1/features/category/data/casual_data.dart';
import 'package:naayu_attire1/features/category/data/coord_data.dart';
import 'package:naayu_attire1/features/category/data/one_piece_data.dart';
import 'package:naayu_attire1/features/category/data/party_data.dart';
import 'package:naayu_attire1/features/category/data/wedding_data.dart';
import 'package:naayu_attire1/features/category/data/winter_data.dart';
import 'package:dio/dio.dart';
import 'package:naayu_attire1/features/notification/domain/models/app_notification.dart';

class ShopProvider extends ChangeNotifier {
  final TokenService tokenService;
  final ApiClient apiClient;

  ShopProvider(this.tokenService, this.apiClient);
  // ================= ALL PRODUCTS =================

  late final List<ProductModel> _allProducts = [
    ...CasualData.products,
    ...CoordData.products,
    ...OnePieceData.products,
    ...PartyData.products,
    ...WeddingData.products,
    ...WinterData.products,
  ];

  List<ProductModel> get allProducts => _allProducts;

  // ================= USER =================

  String? _userId;

  Future<void> setUser(String userId) async {
    _userId = userId;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("currentUser", userId);

    Hive.box("authBox").put("currentUser", userId);

    await loadData();
    await fetchNotifications(); 
  }

Future<void> initializeUser() async {
  final prefs = await SharedPreferences.getInstance();

  String? savedUser =
      Hive.box("authBox").get("currentUser") ??
      prefs.getString("currentUser");

  if (savedUser != null) {
    _userId = savedUser;

    await loadData();
    await fetchNotifications();   

    notifyListeners();
  }
}

  void logout() {
    _userId = null;
    _cart.clear();
    _favorites.clear();
    _address = null;

    Hive.box("authBox").delete("currentUser");

    notifyListeners();
  }

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

  // ================= CART =================

  void addToCart(ProductModel product) {
    int index = _cart.indexWhere((item) => item.id == product.id);

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
    int index = _cart.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      _cart[index].quantity++;
      saveData();
      notifyListeners();
    }
  }

  void decreaseQty(ProductModel product) {
    int index = _cart.indexWhere((item) => item.id == product.id);

    if (index >= 0 && _cart[index].quantity > 1) {
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
      _favorites.removeWhere((item) => item.id == product.id);
    } else {
      _favorites.add(product);
    }

    saveData();
    notifyListeners();
  }

  bool isFavorite(ProductModel product) {
    return _favorites.any((item) => item.id == product.id);
  }

  // ================= LOCATION =================

  String _selectedLocation = "Select Location";
  String get selectedLocation => _selectedLocation;

  void setLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }


 // ================= REAL NOTIFICATIONS =================

final List<AppNotification> _notifications = [];
List<AppNotification> get notifications => _notifications;

// 🔥 ADD THIS
bool _isLoadingNotifications = false;
bool get isLoadingNotifications => _isLoadingNotifications;

int get notificationCount =>
    _notifications.where((n) => !n.isRead).length;


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
    if (_userId == null) return;

    final prefs = await SharedPreferences.getInstance();

    final cartJson = _cart.map((e) => e.toJson()).toList();
    final favJson = _favorites.map((e) => e.toJson()).toList();

    // Save in SharedPreferences (your original system)
// SAVE TO HIVE
Hive.box("cartBox").put(
  "cart_data",
  _cart.map((e) => e.toJson()).toList(),
);

Hive.box("wishlistBox").put(
  "favorites_data",
  _favorites.map((e) => e.toJson()).toList(),
);

// SAVE TO SHARED PREFS
prefs.setString(
  "cart_data",
  jsonEncode(_cart.map((e) => e.toJson()).toList()),
);

prefs.setString(
  "favorites_data",
  jsonEncode(_favorites.map((e) => e.toJson()).toList()),
);

    prefs.setString('deliveryType_$_userId', _deliveryType);
    prefs.setString('paymentMethod_$_userId', _paymentMethod);
  }

  Future<void> loadData() async {
    if (_userId == null) return;

    _cart.clear();
    _favorites.clear();

    // Try Hive first
final hiveCart =
    Hive.box("cartBox").get("cart_data") as List?;
final hiveFav =
    Hive.box("wishlistBox").get("favorites_data") as List?;

    if (hiveCart != null) {
      _cart.addAll(
        hiveCart.map((e) =>
            ProductModel.fromJson(Map<String, dynamic>.from(e))),
      );
    }

    if (hiveFav != null) {
      _favorites.addAll(
        hiveFav.map((e) =>
            ProductModel.fromJson(Map<String, dynamic>.from(e))),
      );
    }

    notifyListeners();
  }
    // ================= FETCH NOTIFICATIONS =================

Future<void> fetchNotifications() async {
  try {
    _isLoadingNotifications = true;
    notifyListeners();

    final response = await apiClient.dio.get(
      "/api/notifications/my",
    );

    _notifications.clear();

    _notifications.addAll(
      (response.data as List)
          .map((e) => AppNotification.fromJson(e))
          .toList(),
    );

  } catch (e) {
    print("Fetch notification error: $e");
  } finally {
    _isLoadingNotifications = false;
    notifyListeners();
  }
}
Future<void> markAsRead(String id) async {
  try {
    final token = tokenService.getToken();

    await apiClient.dio.put(
      "/api/notifications/read/$id",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    final index =
        _notifications.indexWhere((n) => n.id == id);

    if (index != -1) {
      _notifications[index] = AppNotification(
        id: _notifications[index].id,
        message: _notifications[index].message,
        isRead: true,
        createdAt: _notifications[index].createdAt,
      );
    }

    notifyListeners();
  } catch (e) {
    print("Mark read error: $e");
  }
}
}