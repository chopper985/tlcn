import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tl_web_admin/constants/style.dart';
import 'package:tl_web_admin/providers/local.dart';
import 'package:tl_web_admin/providers/product.dart';
import 'package:tl_web_admin/providers/products.dart';
import 'package:tl_web_admin/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class ProductsTable extends StatelessWidget {
  final String keyword;
  final String type;

  const ProductsTable({Key key, this.keyword, this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);
    final local = Provider.of<Local>(context);
    List<Product> products = product.searchProducts(keyword, product.items);
    if (type != null) {
      products = product.searchByType(type, products);
    }
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: active.withOpacity(.4), width: .5),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 6),
                color: lightGrey.withOpacity(.1),
                blurRadius: 12)
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 30),
        child: DataTable2(
            dataRowHeight: 100,
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: 600,
            columns: [
              DataColumn2(
                label: Text("Products Name"),
                size: ColumnSize.L,
              ),
              DataColumn2(
                label: Text('Type'),
                size: ColumnSize.S,
              ),
              DataColumn2(
                label: Text('Description'),
                size: ColumnSize.L,
              ),
              DataColumn2(
                label: Text('Price'),
                size: ColumnSize.S,
              ),
              DataColumn2(
                label: Text('Image'),
                size: ColumnSize.L,
              ),
              DataColumn2(
                label: Text('Action'),
                size: ColumnSize.M,
              ),
            ],
            rows: List<DataRow>.generate(
                products.length,
                (index) => DataRow(cells: [
                      DataCell(CustomText(text: products[index].title)),
                      DataCell(CustomText(text: products[index].type)),
                      DataCell(CustomText(text: products[index].description)),
                      DataCell(Row(
                        children: [
                          CustomText(
                              text: products[index].price.toString() + '\$'),
                        ],
                      )),
                      DataCell(CustomText(text: products[index].imageUrl)),
                      DataCell(Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () async {
                                await product.getEditProduct(new Product(
                                    id: products[index].id,
                                    title: products[index].title,
                                    description: products[index].description,
                                    price: products[index].price,
                                    type: products[index].type,
                                    imageUrl: products[index].imageUrl));
                                local.changeProductScreenStatus('Edit');
                              }),
                          IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                          elevation: 5.0,
                                          backgroundColor: Colors.white,
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons.warning_rounded,
                                                size: 20.0,
                                                color: Theme.of(context)
                                                    .errorColor,
                                              ),
                                              SizedBox(
                                                width: 15.0,
                                              ),
                                              Text('Are you sure?')
                                            ],
                                          ),
                                          content: Text(
                                              'Do you want to remove the item from the cart?'),
                                          actions: [
                                            // ignore: deprecated_member_use
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop('dialog');
                                                },
                                                child: const Text('No')),
                                            // ignore: deprecated_member_use
                                            FlatButton(
                                                onPressed: () async {
                                                  await product.deleteProduct(
                                                      products[index].id);
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop('dialog');
                                                },
                                                child: const Text('Yes')),
                                          ],
                                        ));
                              }),
                        ],
                      ))
                    ]))));
  }
}
