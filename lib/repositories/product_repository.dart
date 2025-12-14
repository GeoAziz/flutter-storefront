import 'package:shop/models/product.dart';

/// Abstract repository interface for product data operations.
/// Implementations can provide mock data, remote API calls, or local caching.
abstract class ProductRepository {
  /// Fetch a list of all products.
  /// Throws an exception if the fetch fails.
  Future<List<Product>> getProducts();

  /// Fetch a single product by ID.
  /// Throws an exception if the product is not found or fetch fails.
  Future<Product> getProductById(String id);

  /// Search products by keyword.
  /// Throws an exception if the search fails.
  Future<List<Product>> searchProducts(String keyword);
}
