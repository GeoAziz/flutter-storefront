import 'package:flutter_test/flutter_test.dart';
import 'package:shop/models/product.dart';
import 'package:shop/repositories/mock_product_repository.dart';

void main() {
  group('MockProductRepository', () {
    late MockProductRepository repository;

    setUp(() {
      repository = MockProductRepository();
    });

    test('getProducts returns a non-empty list', () async {
      final products = await repository.getProducts();
      expect(products, isNotEmpty);
      expect(products.length, greaterThan(0));
    });

    test('getProducts returns Product instances', () async {
      final products = await repository.getProducts();
      expect(products, isA<List<Product>>());
      for (final product in products) {
        expect(product.id, isA<String>());
        expect(product.name, isA<String>());
        expect(product.price, isA<double>());
      }
    });

    test('getProductById returns correct product', () async {
      final product = await repository.getProductById('1');
      expect(product.id, '1');
      expect(product.name, 'Premium Wireless Headphones');
    });

    test('getProductById throws for non-existent ID', () async {
      expect(
        () => repository.getProductById('999'),
        throwsA(isA<Exception>()),
      );
    });

    test('searchProducts returns matching products', () async {
      final results = await repository.searchProducts('headphones');
      expect(results, isNotEmpty);
      expect(results.first.name, 'Premium Wireless Headphones');
    });

    test('searchProducts returns empty list for no matches', () async {
      final results = await repository.searchProducts('nonexistent');
      expect(results, isEmpty);
    });

    test('searchProducts is case-insensitive', () async {
      final resultsLower = await repository.searchProducts('smart');
      final resultsUpper = await repository.searchProducts('SMART');
      expect(resultsLower, isNotEmpty);
      expect(resultsLower.length, resultsUpper.length);
    });
  });

  group('Product Model', () {
    test('Product equality works correctly', () {
      final product1 = const Product(
        id: '1',
        name: 'Test Product',
        description: 'A test product',
        price: 99.99,
        imageUrl: 'test.png',
        rating: 4.5,
        reviewCount: 100,
      );

      final product2 = const Product(
        id: '1',
        name: 'Test Product',
        description: 'A test product',
        price: 99.99,
        imageUrl: 'test.png',
        rating: 4.5,
        reviewCount: 100,
      );

      expect(product1, equals(product2));
    });

    test('Product copyWith creates a modified copy', () {
      const product = Product(
        id: '1',
        name: 'Original',
        description: 'Original description',
        price: 50.0,
        imageUrl: 'original.png',
        rating: 4.0,
        reviewCount: 50,
      );

      final modified = product.copyWith(name: 'Modified', price: 75.0);

      expect(modified.id, '1');
      expect(modified.name, 'Modified');
      expect(modified.price, 75.0);
      expect(modified.description, 'Original description');
    });
  });
}
