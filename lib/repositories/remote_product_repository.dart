import 'package:shop/models/product.dart';
import 'package:shop/repositories/product_repository.dart';
import 'package:shop/services/api_client.dart';

/// Remote implementation of [ProductRepository] using an [ApiClient].
class RemoteProductRepository implements ProductRepository {
  RemoteProductRepository({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<List<Product>> getProducts() async {
    final data = await apiClient.getJson('/products');

    if (data is List) {
      return data.map<Product>(_parseProduct).toList();
    }

    // If the API responds with an object containing a `products` array
    if (data is Map && data['products'] is List) {
      return (data['products'] as List).map<Product>(_parseProduct).toList();
    }

    throw Exception('Unexpected response format from /products');
  }

  @override
  Future<Product> getProductById(String id) async {
    final data = await apiClient.getJson('/products/$id');

    if (data is Map) {
      return _parseProduct(data);
    }

    throw Exception('Unexpected response format from /products/$id');
  }

  @override
  Future<List<Product>> searchProducts(String keyword) async {
    final data = await apiClient
        .getJson('/products/search?q=${Uri.encodeQueryComponent(keyword)}');

    if (data is List) {
      return data.map<Product>(_parseProduct).toList();
    }

    if (data is Map && data['products'] is List) {
      return (data['products'] as List).map<Product>(_parseProduct).toList();
    }

    throw Exception('Unexpected response format from search');
  }

  Product _parseProduct(dynamic item) {
    if (item is! Map) throw Exception('Invalid product item');

    return Product(
      id: (item['id'] ?? '').toString(),
      name: (item['name'] ?? '').toString(),
      description: (item['description'] ?? '').toString(),
      price: (item['price'] is num)
          ? (item['price'] as num).toDouble()
          : double.tryParse('${item['price']}') ?? 0.0,
      imageUrl: (item['imageUrl'] ?? item['image'] ?? '').toString(),
      rating: (item['rating'] is num)
          ? (item['rating'] as num).toDouble()
          : double.tryParse('${item['rating']}') ?? 0.0,
      reviewCount: (item['reviewCount'] is int)
          ? item['reviewCount'] as int
          : (int.tryParse('${item['reviewCount']}') ?? 0),
    );
  }
}
