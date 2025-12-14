import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/components/product/secondary_product_card.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/providers/product_providers.dart';

import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

class MostPopular extends ConsumerWidget {
  const MostPopular({
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
            "Most popular",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading use 👇
        // SeconderyProductsSkelton(),
        productListAsync.when(
          loading: () => const SizedBox(
            height: 114,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, st) => SizedBox(
            height: 114,
            child: Center(child: Text('Error: $err')),
          ),
          data: (products) {
            final popular = products
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
              height: 114,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popular.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: defaultPadding,
                    right: index == popular.length - 1 ? defaultPadding : 0,
                  ),
                  child: SecondaryProductCard(
                    image: popular[index].image,
                    brandName: popular[index].brandName,
                    title: popular[index].title,
                    price: popular[index].price,
                    priceAfetDiscount: popular[index].priceAfetDiscount,
                    dicountpercent: popular[index].dicountpercent,
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
