import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:naayu_attire1/features/category/domain/entities/product.dart';
import 'package:naayu_attire1/features/category/domain/usecases/get_products.dart';
import 'package:naayu_attire1/features/category/presentation/provider/category_provider.dart';


/// -------- MOCK --------

class MockGetProducts extends Mock implements GetProducts {}

class FakeProduct extends Fake implements Product {}

void main() {

  late ProductProvider provider;
  late MockGetProducts mockGetProducts;

  setUpAll(() {
    registerFallbackValue(FakeProduct());
  });

  setUp(() {
    mockGetProducts = MockGetProducts();
    provider = ProductProvider(mockGetProducts);
  });

  /// ---------------- FETCH PRODUCTS SUCCESS ----------------

  test("fetchProducts should load products successfully", () async {

    final productList = [
  Product(
    id: "1",
    name: "Shirt",
    image: "shirt.png",
    previewImage: null,
    price: 100,
    description: "Test product",
    rating: 4.5,
    sizes: ["S", "M", "L"],
    color: "Red",
    isNew: true,
    oldPrice: 120,
    category: "Clothing",
  )
];

    when(() => mockGetProducts())
        .thenAnswer((_) async => productList);

    await provider.fetchProducts();

    expect(provider.products.length, 1);
    expect(provider.products.first.name, "Shirt");
    expect(provider.isLoading, false);

    verify(() => mockGetProducts()).called(1);
  });

  /// ---------------- FETCH PRODUCTS FAILURE ----------------
}