import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naayu_attire1/features/category/presentation/widgets/product_grid.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:naayu_attire1/features/category/presentation/screens/category_screen.dart';
import 'package:naayu_attire1/features/category/presentation/provider/product_provider.dart';
import 'package:naayu_attire1/features/category/domain/entities/product.dart';

/// Mock Provider
class MockProductProvider extends Mock implements ProductProvider {}

void main() {

  late MockProductProvider mockProvider;

  setUp(() {
  mockProvider = MockProductProvider();

  when(() => mockProvider.addListener(any())).thenReturn(null);
  when(() => mockProvider.removeListener(any())).thenReturn(null);
});

  Widget createWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<ProductProvider>.value(
        value: mockProvider,
        child: const Scaffold(
          body: CategoryScreen(
            category: "shirt",
            title: "Shirts",
          ),
        ),
      ),
    );
  }

  /// ===============================
  /// TEST 1 : Loading indicator
  /// ===============================
  testWidgets("shows loading indicator when loading", (tester) async {

    when(() => mockProvider.isLoading).thenReturn(true);
    when(() => mockProvider.products).thenReturn([]);

    await tester.pumpWidget(createWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  /// ===============================
  /// TEST 2 : No products message
  /// ===============================
  testWidgets("shows no products message", (tester) async {

    when(() => mockProvider.isLoading).thenReturn(false);
    when(() => mockProvider.products).thenReturn([]);

    await tester.pumpWidget(createWidget());

    expect(find.text("No products found"), findsOneWidget);
  });

}