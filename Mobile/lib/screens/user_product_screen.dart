import 'package:flutter/material.dart';
import 'package:flutter_shop_application/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static String routeName = '/user-product-screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Products',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: ListView.builder(
            itemBuilder: (ctx, index) => UserProductItem(
              id: productsData.items[index].id,
              title: productsData.items[index].title,
              imgUrl: productsData.items[index].imageUrl,
            ),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
