import 'package:flutter/material.dart';
import 'package:naayu_attire1/core/api/api_client.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';
import 'package:naayu_attire1/core/services/connectivity/network_info.dart';
import 'package:naayu_attire1/features/category/data/models/product_model.dart';
import 'package:naayu_attire1/features/category/domain/entities/product.dart';
import 'package:naayu_attire1/features/address/domain/models/address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

class ShopProvider extends ChangeNotifier {

  final TokenService tokenService;
  final ApiClient apiClient;
  final INetworkInfo networkInfo;

  ShopProvider(
    this.tokenService,
    this.apiClient,
    this.networkInfo,
  );

  bool _isOffline = false;
  bool get isOffline => _isOffline;

  // ================= PRODUCTS =================

  List<Product> _allProducts = [];
  List<Product> get allProducts => _allProducts;

  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;

 Future<void> fetchProducts() async {

  try {

    _isLoadingProducts = true;
    notifyListeners();

    final box = Hive.box<ProductModel>('productsBox');

    final connected = await networkInfo.isConnected;

    if (!connected) {

      /// NO INTERNET
      _isOffline = true;

      final cachedProducts =
          box.values.cast<ProductModel>().toList();

      _allProducts = cachedProducts.map((e) => e.toEntity()).toList();

      debugPrint("Offline mode - showing cached products");

      return;
    }

    /// INTERNET AVAILABLE
    _isOffline = false;

    final response = await apiClient.dio.get("/products");

    final List productsJson = response.data["data"];

    final List<ProductModel> productModels =
        productsJson.map((e) => ProductModel.fromJson(e)).toList();

    _allProducts = productModels.map((e) => e.toEntity()).toList();

    /// SAVE CACHE
    await box.clear();
    await box.addAll(productModels);

  } catch (e) {

    /// API FAILED
    _isOffline = true;

    debugPrint("Fetch products error: $e");

  } finally {

    _isLoadingProducts = false;
    notifyListeners();

  }
}
  // ================= SEARCH =================

  List<Product> _searchResults = [];
  List<Product> get searchResults => _searchResults;

  bool get isSearching => _searchResults.isNotEmpty;

  void searchProduct(String query) {

    if (query.trim().isEmpty) {

      _searchResults = [];

    } else {

      _searchResults = _allProducts
          .where((p) =>
              p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  // ================= USER =================

  String? _userId;

  Future<void> setUser(String userId) async {

    _userId = userId;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("currentUser", userId);

    Hive.box("authBox").put("currentUser", userId);

    await loadData();
    await fetchProducts();

  }

  Future<void> initializeUser() async {

    final prefs = await SharedPreferences.getInstance();

    String? savedUser =
        Hive.box("authBox").get("currentUser") ??
        prefs.getString("currentUser");

    if (savedUser != null) {

      _userId = savedUser;

      await loadData();
      await fetchProducts();

    }

    notifyListeners();
  }

  void logout() {

    _userId = null;
    _address = null;

    Hive.box("authBox").delete("currentUser");

    notifyListeners();
  }

  // ================= ADDRESS =================

  AddressModel? _address;
  AddressModel? get address => _address;

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

  // ================= LOCATION =================

  String _selectedLocation = "Select Location";
  String get selectedLocation => _selectedLocation;

  void setLocation(String location) {

    _selectedLocation = location;
    notifyListeners();

  }

  // ================= DELIVERY =================

  String _deliveryType = "standard";
  String get deliveryType => _deliveryType;

  void setDeliveryType(String type) {

    _deliveryType = type;
    saveData();
    notifyListeners();

  }

  // ================= PAYMENT =================

  String _paymentMethod = "cod";
  String get paymentMethod => _paymentMethod;

  void setPaymentMethod(String method) {

    _paymentMethod = method;
    saveData();
    notifyListeners();

  }

  // ================= LOCAL STORAGE =================

  Future<void> saveData() async {

    if (_userId == null) return;

    final prefs = await SharedPreferences.getInstance();

    prefs.setString('deliveryType_$_userId', _deliveryType);
    prefs.setString('paymentMethod_$_userId', _paymentMethod);

  }

  Future<void> loadData() async {

    if (_userId == null) return;

    final prefs = await SharedPreferences.getInstance();

    _deliveryType =
        prefs.getString('deliveryType_$_userId') ?? "standard";

    _paymentMethod =
        prefs.getString('paymentMethod_$_userId') ?? "cod";

    notifyListeners();
  }

}