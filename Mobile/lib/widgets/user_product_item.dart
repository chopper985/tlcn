import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/products.dart';
import 'package:flutter_shop_application/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  UserProductItem(
      {required this.id, required this.title, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imgUrl, scale: 1.0),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName, arguments: id);
                  },
                  icon: Icon(Icons.edit),
                  color: Colors.indigo,
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      await Provider.of<Products>(context, listen: false)
                          .deleteProduct(id);
                    } catch (error) {
                      scaffold.hideCurrentSnackBar();
                      scaffold.showSnackBar(SnackBar(
                          content: const Text(
                        'Deleting Fail!',
                        textAlign: TextAlign.center,
                      )));
                    }
                  },
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
