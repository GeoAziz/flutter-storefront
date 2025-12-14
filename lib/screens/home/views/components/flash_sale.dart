import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/route/route_constants.dart';

import '/components/Banner/M/banner_m_with_counter.dart';
import '../../../../components/product/product_card.dart';
import '../../../../constants.dart';
import '../../../../models/product_model.dart';
import 'package:shop/providers/product_providers.dart';

class FlashSale extends ConsumerWidget {
  const FlashSale({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productListAsync = ref.watch(productListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // While loading show 👇
        // const BannerMWithCounterSkelton(),
        BannerMWithCounter(
          duration: const Duration(hours: 8),
          text: "Super Flash Sale \n50% Off",
          press: () {},
        ),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Flash sale",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading show 👇
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
            if (products.isEmpty) {
              return const SizedBox(
                height: 220,
                child: Center(child: Text('No flash sale items')),
              );
            }

            final flashProducts = products
                .take(5)
                .map((product) => ProductModel(
                      image: product.imageUrl,
                      brandName: 'Brand',
                      title: product.name,
                      price: product.price,
                      priceAfetDiscount: product.price * 0.5,
                      dicountpercent: 50,
                    ))
                .toList();

            return SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: flashProducts.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: defaultPadding,
                    right:
                        index == flashProducts.length - 1 ? defaultPadding : 0,
                  ),
                  child: ProductCard(
                    image: flashProducts[index].image,
                    brandName: flashProducts[index].brandName,
                    title: flashProducts[index].title,
                    price: flashProducts[index].price,
                    priceAfetDiscount: flashProducts[index].priceAfetDiscount,
                    dicountpercent: flashProducts[index].dicountpercent,
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
