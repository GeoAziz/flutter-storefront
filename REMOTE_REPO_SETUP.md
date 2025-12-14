# Remote Repository Setup

This document describes the RemoteProductRepository implementation that integrates with the Riverpod state management layer.

## Architecture

```
┌─────────────────────────────┐
│  productRepositoryProvider  │
│  (switches between Mock     │
│   and Remote)               │
└──────────────┬──────────────┘
               │
        ┌──────┴──────────┐
        │                 │
   ┌────▼────────────┐   ┌─────▼────────────┐
   │ MockProduct     │   │ RemoteProduct    │
   │ Repository      │   │ Repository       │
   │ (hardcoded)     │   │ (HTTP client)    │
   └────────────────┘   └────────┬─────────┘
                                 │
                         ┌───────▼────────┐
                         │   ApiClient    │
                         │   (http pkg)   │
                         └────────────────┘
```

## Files Created

### 1. `lib/services/api_client.dart`
- Lightweight HTTP client wrapper around `package:http`.
- Provides `getJson(path)` method to fetch and decode JSON responses.
- Handles status code checking and error reporting.

### 2. `lib/repositories/remote_product_repository.dart`
- Implements `ProductRepository` interface using `ApiClient`.
- Provides three methods:
  - `getProducts()` — fetches list of products from `/products` endpoint
  - `getProductById(id)` — fetches single product from `/products/{id}`
  - `searchProducts(keyword)` — searches products from `/products/search?q={keyword}`
- Parses JSON into `Product` domain model with flexible field mapping.

### 3. `lib/providers/product_providers.dart` (modified)
- Updated `productRepositoryProvider` to support toggling between Mock and Remote.
- To switch to RemoteProductRepository:
  ```dart
  const useRemote = true; // set to true to use the remote repository
  ```

### 4. `test/remote_product_repository_test.dart`
- Unit tests using `package:http/testing.dart` MockClient.
- Tests:
  - `getProducts` returns list on success
  - `getProductById` returns single product
  - `searchProducts` returns search results
  - Error handling on non-200 responses

## Dependencies Added

- `http: ^1.6.0` — HTTP client library (compatible with existing `flutter_svg` dependency)

## How to Use

### Development (MockProductRepository)
Keep `const useRemote = false;` in `lib/providers/product_providers.dart`. The app will use hardcoded mock data.

### Production (RemoteProductRepository)
1. Update the base URL in `lib/providers/product_providers.dart`:
   ```dart
   const apiClient = ApiClient(baseUrl: 'https://your-api.com');
   ```

2. Change the toggle:
   ```dart
   const useRemote = true;
   ```

### Expected API Response Format

The API should return JSON matching this structure:

**GET /products**
```json
[
  {
    "id": "1",
    "name": "Product Name",
    "description": "Product description",
    "price": 99.99,
    "imageUrl": "https://example.com/image.png",
    "rating": 4.5,
    "reviewCount": 42
  }
]
```

Or with a wrapper:
```json
{
  "products": [{ ... }]
}
```

**GET /products/{id}**
```json
{
  "id": "1",
  "name": "Product Name",
  ...
}
```

**GET /products/search?q={keyword}**
```json
[{ ... }]
```

## Test Results

All 21 tests pass:
- 8 MockProductRepository unit tests
- 6 Riverpod provider integration tests
- 4 RemoteProductRepository unit tests
- 1 HomeScreen smoke test + 2 widget variants

## Notes

- The `_parseProduct()` method in RemoteProductRepository is flexible and handles various JSON field formats.
- The implementation supports both direct arrays and wrapped responses (with a `products` array).
- All HTTP errors are propagated as exceptions for the Riverpod FutureProvider to handle as error states in the UI.
