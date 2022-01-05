import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tl_web_admin/constants/style.dart';
import 'package:tl_web_admin/providers/user.dart';
import 'package:tl_web_admin/widgets/custom_text.dart';
import 'package:provider/provider.dart';

/// Example without datasource
class Clientstable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
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
        child: FutureBuilder<List<UserItem>>(
            future: user.getAllUser(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Container()
                  : DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 600,
                      dataRowHeight: 100,
                      columns: [
                        DataColumn2(
                          label: Text("Avatar"),
                          size: ColumnSize.L,
                        ),
                        DataColumn2(
                            label: Text('Full Name'), size: ColumnSize.M),
                        DataColumn(
                          label: Text('Birthday'),
                        ),
                        DataColumn(
                          label: Text('Email'),
                        ),
                        DataColumn(
                          label: Text('Phone Number'),
                        ),
                        DataColumn2(
                          label: Text('Address'),
                          size: ColumnSize.L,
                        )
                      ],
                      rows: List<DataRow>.generate(
                          snapshot.data.length,
                          (index) => DataRow(cells: [
                                DataCell(CustomText(
                                    text: snapshot.data[index].avatar)),
                                DataCell(CustomText(
                                    text: snapshot.data[index].fullName)),
                                DataCell(CustomText(
                                    text: snapshot.data[index].birthday)),
                                DataCell(CustomText(
                                    text: snapshot.data[index].email)),
                                DataCell(CustomText(
                                    text: snapshot.data[index].phoneNumber)),
                                DataCell(CustomText(
                                    text: snapshot.data[index].address)),
                              ])));
            }));
  }
}
