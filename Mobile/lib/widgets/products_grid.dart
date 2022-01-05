import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/product.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  final String keywords;
  final String isType;

  ProductsGrid(
      {required this.showFavs, required this.keywords, required this.isType});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final productByType = isType == 'All'
        ? productsData.items
        : productsData.searchByType(isType);
    var products = showFavs ? productsData.itemsFavorites : productByType;
    if (keywords.length > 0) {
      products =
          Provider.of<Products>(context).searchProducts(keywords, products);
    }
    return products.isEmpty
        ? Center(
            child: Text(
              'No have any item!',
              style: TextStyle(color: Colors.grey),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20),
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem(),
            ),
            itemCount: products.length,
          );
  }
}
