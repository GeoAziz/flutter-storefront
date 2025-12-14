import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/providers/product_providers.dart';
import 'package:shop/route/screen_export.dart';

import '../../../../constants.dart';

class PopularProducts extends ConsumerWidget {
  const PopularProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productListAsync = ref.watch(productListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Popular products",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        productListAsync.when(
          loading: () => const SizedBox(
            height: 220,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stackTrace) => SizedBox(
            height: 220,
            child: Center(
              child: Text('Error: $error'),
            ),
          ),
          data: (products) {
            if (products.isEmpty) {
              return const SizedBox(
                height: 220,
                child: Center(
                  child: Text('No products available'),
                ),
              );
            }

            // Convert Product (domain model) to ProductModel (view model)
            final popularProducts = products
                .take(5)
                .map((product) => ProductModel(
                      image: product.imageUrl,
                      brandName: 'Brand',
                      title: product.name,
                      price: product.price,
                      priceAfetDiscount:
                          product.price * 0.8, // Simulate 20% discount
                      dicountpercent: 20,
                    ))
                .toList();

            return SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularProducts.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: defaultPadding,
                    right: index == popularProducts.length - 1
                        ? defaultPadding
                        : 0,
                  ),
                  child: ProductCard(
                    image: popularProducts[index].image,
                    brandName: popularProducts[index].brandName,
                    title: popularProducts[index].title,
                    price: popularProducts[index].price,
                    priceAfetDiscount: popularProducts[index].priceAfetDiscount,
                    dicountpercent: popularProducts[index].dicountpercent,
                    press: () {
                      Navigator.pushNamed(context, productDetailsScreenRoute,
                          arguments: index.isEven);
                    },
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
