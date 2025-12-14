import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop/providers/product_providers.dart';

void main() {
  group('Product Providers', () {
    test('productRepositoryProvider provides a repository', () {
      final container = ProviderContainer();
      final repository = container.read(productRepositoryProvider);
      expect(repository, isNotNull);
    });

    test('productListProvider fetches products', () async {
      final container = ProviderContainer();
      final products = await container.read(productListProvider.future);
      expect(products, isNotEmpty);
      expect(products.length, greaterThan(0));
    });

    test('productByIdProvider fetches a single product', () async {
      final container = ProviderContainer();
      final product = await container.read(productByIdProvider('1').future);
      expect(product.id, '1');
      expect(product.name, 'Premium Wireless Headphones');
    });

    test('searchQueryProvider starts with empty string', () {
      final container = ProviderContainer();
      final query = container.read(searchQueryProvider);
      expect(query, '');
    });

    test('searchQueryProvider can be updated', () {
      final container = ProviderContainer();
      container.read(searchQueryProvider.notifier).state = 'headphones';
      final query = container.read(searchQueryProvider);
      expect(query, 'headphones');
    });

    test('searchResultsProvider returns empty for empty query', () async {
      final container = ProviderContainer();
      // searchQueryProvider starts with empty string
      final results = await container.read(searchResultsProvider.future);
      expect(results, isEmpty);
    });

    test('searchResultsProvider searches based on query', () async {
      final container = ProviderContainer();
      // Set search query
      container.read(searchQueryProvider.notifier).state = 'smart';
      // Fetch search results
      final results = await container.read(searchResultsProvider.future);
      expect(results, isNotEmpty);
      expect(results.any((p) => p.name.toLowerCase().contains('smart')), true);
    });
  });
}
