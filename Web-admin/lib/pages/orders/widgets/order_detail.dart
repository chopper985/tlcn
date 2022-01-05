import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tl_web_admin/constants/style.dart';
import 'package:tl_web_admin/providers/cart_item.dart';
import 'package:tl_web_admin/providers/local.dart';
import 'package:tl_web_admin/providers/product.dart';
import 'package:tl_web_admin/providers/products.dart';
import 'package:tl_web_admin/widgets/custom_text.dart';

class OrderDetail extends StatelessWidget {
  final List<CartItem> lstProduct;
  const OrderDetail({Key key, this.lstProduct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                label: Text('Quantily'),
                size: ColumnSize.M,
              ),
              DataColumn2(
                label: Text('Price'),
                size: ColumnSize.M,
              ),
              DataColumn2(
                label: Text('Image'),
                size: ColumnSize.L,
              ),
            ],
            rows: List<DataRow>.generate(
                lstProduct.length,
                (index) => DataRow(cells: [
                      DataCell(CustomText(text: lstProduct[index].title)),
                      DataCell(CustomText(
                          text: lstProduct[index].quantily.toString())),
                      DataCell(Row(
                        children: [
                          CustomText(
                              text: lstProduct[index].price.toString() + '\$'),
                        ],
                      )),
                      DataCell(CustomText(text: lstProduct[index].imgUrl)),
                    ]))));
  }
}
