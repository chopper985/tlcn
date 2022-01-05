import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tl_web_admin/constants/controllers.dart';
import 'package:tl_web_admin/constants/style.dart';
import 'package:tl_web_admin/helpers/reponsiveness.dart';
import 'package:tl_web_admin/pages/orders/widgets/orders_table.dart';
import 'package:tl_web_admin/pages/orders/widgets/orders_widget.dart';
import 'package:tl_web_admin/providers/order.dart';
import 'package:tl_web_admin/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = false;
  bool _isInit = true;
  DateTime selectedDate = DateTime.now();
  DateFormat formatDate = DateFormat('dd/MM/yyyy');
  TextEditingController dateController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Order>(context, listen: false)
          .fetchAllOrder()
          .then((_) => _isLoading = false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<DateTime> _selectDateTime(BuildContext context) => showDatePicker(
      context: context,
      initialDate: dateController.text.isEmpty
          ? DateTime.now().add(Duration(seconds: 1))
          : this.selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now());
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Order>(context);
    double _width = MediaQuery.of(context).size.width;
    final _status = order.status;
    final isDetail = order.isDetail;
    final lstDetail = order.lstCard;

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Form(
            key: _formkey,
            child: Container(
              child: isDetail
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(
                          () => Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      top: ResponsiveWidget.isSmallScreen(
                                              context)
                                          ? 56
                                          : 6),
                                  child: CustomText(
                                    text: menuController.activeItem.value,
                                    size: 24,
                                    weight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    order.checkDetail([], false);
                                  },
                                  icon: Icon(Icons.arrow_back_ios)),
                              Text('Back', style: TextStyle(fontSize: 16)),
                              SizedBox(
                                width: 380,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text('Order details',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: active.withOpacity(.4), width: .5),
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
                                columnSpacing: 30,
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
                                    lstDetail.length,
                                    (index) => DataRow(cells: [
                                          DataCell(CustomText(
                                              text: lstDetail[index].title)),
                                          DataCell(CustomText(
                                              text: lstDetail[index]
                                                  .quantily
                                                  .toString())),
                                          DataCell(Row(
                                            children: [
                                              CustomText(
                                                  text: lstDetail[index]
                                                          .price
                                                          .toString() +
                                                      '\$'),
                                            ],
                                          )),
                                          DataCell(CustomText(
                                              text: lstDetail[index].imgUrl)),
                                        ])))),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(
                          () => Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      top: ResponsiveWidget.isSmallScreen(
                                              context)
                                          ? 56
                                          : 6),
                                  child: CustomText(
                                    text: menuController.activeItem.value,
                                    size: 24,
                                    weight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                            child: ListView(
                          children: [
                            SizedBox(
                              height: _width / 64,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    InfoOrderCard(
                                      title: "All",
                                      value: '',
                                      onTap: () {
                                        order.setStatus('All');
                                      },
                                      topColor: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: _width / 64,
                                    ),
                                    InfoOrderCard(
                                      title: "Ordered",
                                      value: '',
                                      onTap: () {
                                        order.setStatus('Ordered');
                                      },
                                      topColor: Colors.orange,
                                    ),
                                    SizedBox(
                                      width: _width / 64,
                                    ),
                                    InfoOrderCard(
                                      title: "Packages Delivered",
                                      value: '',
                                      topColor: Colors.lightGreen,
                                      onTap: () {
                                        order.setStatus('Packed');
                                      },
                                    ),
                                    SizedBox(
                                      width: _width / 64,
                                    ),
                                    InfoOrderCard(
                                      title: "In Transit",
                                      value: '',
                                      topColor: Colors.brown,
                                      onTap: () {
                                        order.setStatus('In transit');
                                      },
                                    ),
                                    SizedBox(
                                      width: _width / 64,
                                    ),
                                    InfoOrderCard(
                                      title: "Delivered",
                                      value: '',
                                      onTap: () {
                                        order.setStatus('Delivered');
                                      },
                                    ),
                                    SizedBox(
                                      width: _width / 64,
                                    ),
                                    InfoOrderCard(
                                      title: "Cancel",
                                      topColor: Colors.redAccent,
                                      value: '',
                                      onTap: () {
                                        order.setStatus('Cancel');
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: _width / 128,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                      height: 58,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            (_status == 'Ordered' ||
                                                    _status == 'In transit' ||
                                                    _status == 'Packed')
                                                ? Colors.blue
                                                : Colors.grey,
                                            (_status == 'Ordered' ||
                                                    _status == 'In transit' ||
                                                    _status == 'Packed')
                                                ? Colors.blue.withOpacity(0.6)
                                                : Colors.grey.withOpacity(0.6)
                                          ]),
                                          border: Border.all(width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TextButton(
                                          onPressed: () {
                                            if (_status == 'Ordered' ||
                                                _status == 'In transit' ||
                                                _status == 'Packed')
                                              order.changeStatus();
                                          },
                                          child: Text('Change Status',
                                              style: TextStyle(
                                                  color: Colors.white)))),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                      child: TextFormField(
                                        readOnly: true,
                                        keyboardType: TextInputType.datetime,
                                        controller: dateController,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        decoration: InputDecoration(
                                          fillColor: Colors.black,
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0.5,
                                          ),
                                          suffixIcon: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 0, 5, 0),
                                                child: Text(dateController.text,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    )),
                                              ),
                                              Spacer(),
                                              if (dateController
                                                  .text.isNotEmpty)
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        dateController.text =
                                                            '';
                                                      });
                                                    },
                                                    icon: Icon(Icons.close,
                                                        color: Colors.red)),
                                              IconButton(
                                                icon:
                                                    Icon(Icons.calendar_today),
                                                onPressed: () async {
                                                  final selectedDate =
                                                      await _selectDateTime(
                                                          context);
                                                  if (selectedDate != null) {
                                                    setState(() {
                                                      this.selectedDate =
                                                          DateTime(
                                                        selectedDate.year,
                                                        selectedDate.month,
                                                        selectedDate.day,
                                                      );
                                                      dateController.text =
                                                          formatDate.format(this
                                                              .selectedDate);
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 1)),
                                          labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      )),
                                ),
                                Expanded(child: Container(), flex: 13)
                              ],
                            ),
                            OrdersTable(
                              date: dateController.text,
                            )
                          ],
                        )),
                      ],
                    ),
            ),
          );
  }
}
