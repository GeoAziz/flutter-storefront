import 'package:shop/models/product.dart';
import 'package:shop/repositories/product_repository.dart';

/// Mock implementation of ProductRepository for development and testing.
/// Returns hardcoded sample products.
class MockProductRepository implements ProductRepository {
  // Sample product data
  static const List<Product> _sampleProducts = [
    Product(
      id: '1',
      name: 'Premium Wireless Headphones',
      description: 'High-quality wireless headphones with noise cancellation.',
      price: 199.99,
      imageUrl: 'assets/images/headphones.png',
      rating: 4.5,
      reviewCount: 128,
    ),
    Product(
      id: '2',
      name: 'Smart Watch Pro',
      description:
          'Advanced fitness tracking smartwatch with heart rate monitor.',
      price: 299.99,
      imageUrl: 'assets/images/smartwatch.png',
      rating: 4.7,
      reviewCount: 256,
    ),
    Product(
      id: '3',
      name: 'Ultra Fast Charger',
      description: 'USB-C fast charger supporting up to 100W charging.',
      price: 49.99,
      imageUrl: 'assets/images/charger.png',
      rating: 4.2,
      reviewCount: 512,
    ),
    Product(
      id: '4',
      name: 'Portable Speaker',
      description:
          'Waterproof portable Bluetooth speaker with 12-hour battery.',
      price: 79.99,
      imageUrl: 'assets/images/speaker.png',
      rating: 4.6,
      reviewCount: 342,
    ),
    Product(
      id: '5',
      name: 'Camera Gimbal',
      description:
          'Professional stabilizer gimbal for smartphones and cameras.',
      price: 149.99,
      imageUrl: 'assets/images/gimbal.png',
      rating: 4.4,
      reviewCount: 187,
    ),
  ];

  @override
  Future<List<Product>> getProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _sampleProducts;
  }

  @override
  Future<Product> getProductById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _sampleProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      throw Exception('Product with id $id not found');
    }
  }

  @override
  Future<List<Product>> searchProducts(String keyword) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    final query = keyword.toLowerCase();
    return _sampleProducts
        .where((product) =>
            product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query))
        .toList();
  }
}
