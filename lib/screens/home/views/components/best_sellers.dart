import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/providers/product_providers.dart';

import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

class BestSellers extends ConsumerWidget {
  const BestSellers({
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
            "Best sellers",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading use 👇
        // const ProductsSkelton(),
        productListAsync.when(
          loading: () => const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, st) => SizedBox(
            height: 220,
            child: Center(child: Text('Error: $err')),
          ),
          data: (products) {
            final best = products
                .take(5)
                .map((product) => ProductModel(
                      image: product.imageUrl,
                      brandName: 'Brand',
                      title: product.name,
                      price: product.price,
                      priceAfetDiscount: product.price * 0.9,
                      dicountpercent: 10,
                    ))
                .toList();

            return SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: best.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: defaultPadding,
                    right: index == best.length - 1 ? defaultPadding : 0,
                  ),
                  child: ProductCard(
                    image: best[index].image,
                    brandName: best[index].brandName,
                    title: best[index].title,
                    price: best[index].price,
                    priceAfetDiscount: best[index].priceAfetDiscount,
                    dicountpercent: best[index].dicountpercent,
                    press: () {
                      Navigator.pushNamed(context, productDetailsScreenRoute,
                          arguments: index.isEven);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
