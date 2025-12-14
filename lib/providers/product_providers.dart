import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/models/product.dart';
import 'package:shop/repositories/mock_product_repository.dart';
import 'package:shop/repositories/product_repository.dart';
import 'package:shop/repositories/remote_product_repository.dart';
import 'package:shop/services/api_client.dart';

/// Provider for the ProductRepository singleton.
/// Currently returns MockProductRepository; swap with RemoteProductRepository when ready.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  // Toggle this flag to switch between remote and mock implementations.
  // Change to: const useRemote = true; // to use the remote repository
  const useRemote = false; // set to true to use the remote repository

  // ignore: dead_code
  if (useRemote) {
    // ignore: dead_code
    final apiClient = ApiClient(baseUrl: 'https://api.example.com');
    // ignore: dead_code
    return RemoteProductRepository(apiClient: apiClient);
  }

  // Using MockProductRepository for development/testing
  return MockProductRepository();
});

/// Provider for fetching a list of all products.
/// This is a FutureProvider that fetches products from the repository.
final productListProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

/// Provider for fetching a single product by ID.
/// Pass the product ID as a parameter.
final productByIdProvider =
    FutureProvider.family<Product, String>((ref, productId) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductById(productId);
});

/// State provider for the search query input.
/// Stores the current search term.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for search results based on the current search query.
/// Depends on searchQueryProvider and refetches when the query changes.
final searchResultsProvider = FutureProvider<List<Product>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final repository = ref.watch(productRepositoryProvider);

  if (query.isEmpty) {
    return [];
  }

  return repository.searchProducts(query);
});
