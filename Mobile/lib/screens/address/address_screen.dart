import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/addresses.dart';
import 'package:flutter_shop_application/screens/address/create_address.dart';
import 'package:flutter_shop_application/widgets/address_item_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'edit_address.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = "/address-screen";
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Addresses>(context);
    final itemData = data.addresses;
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => CreateAddress(
                          address: '',
                        )));
              },
            ),
          ],
          title: Text(
            'Address List',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        body: _isLoading
            ? Center(
                child: Lottie.asset('assets/images/loading_plane_paper.json'))
            : ListView.builder(
                itemBuilder: (ctx, i) => Slidable(
                    actionExtentRatio: 0.2,
                    actionPane: SlidableStrechActionPane(),
                    child: Card(
                      child: Stack(
                        children: [
                          AddressItemWidget(
                            name: itemData[i].fullName,
                            phoneNumber: itemData[i].phoneNumber,
                            address: itemData[i].address,
                            handle: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => EditAddress(
                                        id: itemData[i].id,
                                        name: itemData[i].fullName,
                                        phoneNumber: itemData[i].phoneNumber,
                                        address: itemData[i].address,
                                        defaultStatus: itemData[i].status,
                                      )));
                            },
                          ),
                          itemData[i].status == false
                              ? Container()
                              : Positioned(
                                  child: Text('Default',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 10.sp,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.normal)),
                                  top: 1.5.h,
                                  right: 8.w),
                        ],
                      ),
                    ),
                    secondaryActions: [
                      IconSlideAction(
                          caption: "Edit",
                          color: Colors.yellow,
                          icon: Icons.edit,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => EditAddress(
                                      id: itemData[i].id,
                                      name: itemData[i].fullName,
                                      phoneNumber: itemData[i].phoneNumber,
                                      address: itemData[i].address,
                                      defaultStatus: itemData[i].status,
                                    )));
                          }),
                      IconSlideAction(
                          caption: "Delete",
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
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
                                            color: Theme.of(context).errorColor,
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
                                              Navigator.of(context).pop(false);
                                            },
                                            child: const Text('No')),
                                        // ignore: deprecated_member_use
                                        FlatButton(
                                            onPressed: () {
                                              data.deleteAddress(
                                                  itemData[i].id);
                                              Navigator.of(context).pop(true);
                                            },
                                            child: const Text('Yes')),
                                      ],
                                    ));
                          }),
                    ]),
                itemCount: itemData.length,
              ));
  }
}
