import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shop/repositories/remote_product_repository.dart';
import 'package:shop/services/api_client.dart';

void main() {
  group('RemoteProductRepository', () {
    test('getProducts returns list on success', () async {
      final mock = MockClient((request) async {
        if (request.url.path == '/products') {
          return http.Response(
              json.encode([
                {
                  'id': '1',
                  'name': 'Test Product',
                  'description': 'A product',
                  'price': 9.99,
                  'imageUrl': 'https://example.com/img.png',
                  'rating': 4.5,
                  'reviewCount': 10
                }
              ]),
              200,
              headers: {'content-type': 'application/json'});
        }

        return http.Response('Not Found', 404);
      });

      final api = ApiClient(baseUrl: 'https://api.example.com', client: mock);
      final repo = RemoteProductRepository(apiClient: api);

      final products = await repo.getProducts();
      expect(products, isNotEmpty);
      expect(products.first.id, '1');
      expect(products.first.price, 9.99);
    });

    test('getProductById returns product on success', () async {
      final mock = MockClient((request) async {
        if (request.url.path == '/products/1') {
          return http.Response(
              json.encode({
                'id': '1',
                'name': 'Single',
                'description': 'Single product',
                'price': 5.5,
                'imageUrl': '',
                'rating': 4.0,
                'reviewCount': 2
              }),
              200);
        }
        return http.Response('Not Found', 404);
      });

      final api = ApiClient(baseUrl: 'https://api.example.com', client: mock);
      final repo = RemoteProductRepository(apiClient: api);

      final product = await repo.getProductById('1');
      expect(product.id, '1');
      expect(product.name, 'Single');
    });

    test('searchProducts returns list', () async {
      final mock = MockClient((request) async {
        if (request.url.path == '/products/search') {
          return http.Response(
              json.encode([
                {
                  'id': '2',
                  'name': 'Found',
                  'description': 'Found product',
                  'price': 1.0,
                  'imageUrl': '',
                  'rating': 3.0,
                  'reviewCount': 1
                }
              ]),
              200);
        }
        return http.Response('Not Found', 404);
      });

      final api = ApiClient(baseUrl: 'https://api.example.com', client: mock);
      final repo = RemoteProductRepository(apiClient: api);

      final results = await repo.searchProducts('x');
      expect(results, isNotEmpty);
      expect(results.first.id, '2');
    });

    test('getProducts throws on non-200', () async {
      final mock = MockClient((request) async => http.Response('Error', 500));
      final api = ApiClient(baseUrl: 'https://api.example.com', client: mock);
      final repo = RemoteProductRepository(apiClient: api);

      expect(repo.getProducts(), throwsA(isA<Exception>()));
    });
  });
}
