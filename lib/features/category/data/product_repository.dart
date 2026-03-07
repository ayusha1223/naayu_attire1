import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'models/product_model.dart';

class ProductRepository {
  static const String baseUrl =
      "http://192.168.1.74:3000/api/v1/products";

  
  // ================= GET PRODUCTS (FILTER + SEARCH) =================
static Future<List<ProductModel>> getProducts(
  String? category, {
  String? search,
}) async {

  String url = baseUrl + "?";

  if (category != null && category.isNotEmpty) {
    url += "category=$category&";
  }

  if (search != null && search.isNotEmpty) {
    url += "search=$search&";
  }

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List productsJson = data["data"];

    return productsJson
        .map((e) => ProductModel.fromJson(e))
        .toList();
  } else {
    throw Exception("Failed to load products");
  }
}

  // ================= CREATE PRODUCT =================
  static Future<void> createProduct(
      ProductModel product,
      File? imageFile) async {

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(baseUrl),
    );

    request.fields["name"] = product.name;
    request.fields["price"] = product.price.toString();
    request.fields["description"] = product.description;
    request.fields["rating"] = product.rating.toString();
    request.fields["color"] = product.color;
    request.fields["isNew"] = product.isNew.toString();
    request.fields["category"] = product.category;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "image",
          imageFile.path,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode != 201) {
      throw Exception("Failed to create product");
    }
  }

  // ================= DELETE PRODUCT =================
  static Future<void> deleteProduct(String id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete product");
    }
  }

  // ================= UPDATE PRODUCT =================
  static Future<void> updateProduct(
      String id,
      ProductModel product) async {

    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update product");
    }
  }
  // ================= SEARCH PRODUCTS =================
static Future<List<ProductModel>> searchProducts(
    String query) async {

  final response = await http.get(
    Uri.parse("$baseUrl?search=$query"),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List productsJson = data["data"];

    return productsJson
        .map((e) => ProductModel.fromJson(e))
        .toList();
  } else {
    throw Exception("Failed to search products");
  }
}

  // GET ALL PRODUCTS (no category)
static Future<List<ProductModel>> getAllProducts() async {
  final response = await http.get(
    Uri.parse(baseUrl),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List productsJson = data["data"];

    return productsJson
        .map((e) => ProductModel.fromJson(e))
        .toList();
  } else {
    throw Exception("Failed to load products");
  }
}
//GET LIMITED PRODUCTS (for HomeScreen)
static Future<List<ProductModel>> getLimitedProducts(int limit) async {
  final response = await http.get(
    Uri.parse("$baseUrl?limit=$limit"),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List productsJson = data["data"];

    return productsJson
        .map((e) => ProductModel.fromJson(e))
        .toList();
  } else {
    throw Exception("Failed to load limited products");
  }
}
//  GET FLASH PRODUCTS
static Future<List<ProductModel>> getFlashProducts() async {
  final response = await http.get(
    Uri.parse("$baseUrl?isFlash=true"),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List productsJson = data["data"];

    return productsJson
        .map((e) => ProductModel.fromJson(e))
        .toList();
  } else {
    throw Exception("Failed to load flash products");
  }
}
}