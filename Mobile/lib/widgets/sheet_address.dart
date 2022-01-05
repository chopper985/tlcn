import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_shop_application/providers/address.dart';
import 'package:flutter_shop_application/screens/profile_screen.dart';
import 'package:flutter_shop_application/widgets/widget.dart';

class SheetAddress extends StatefulWidget {
  const SheetAddress({Key? key}) : super(key: key);

  @override
  State<SheetAddress> createState() => _SheetAddressState();
}

class _SheetAddressState extends State<SheetAddress> {
  final _formkey = GlobalKey<FormState>();
  late District dropdownValue;
  Ward? dropdownValue2;
  TextEditingController _districtController = TextEditingController();
  TextEditingController _wardController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  List<District> listDistrict = [];
  List<Ward> listWard = [];

  @override
  void initState() {
    listDistrict = Provider.of<AddressItems>(context, listen: false).districts;
    dropdownValue = listDistrict[0];
    _districtController.text = listDistrict[0].name;
    listWard = Provider.of<AddressItems>(context, listen: false)
        .getWard(dropdownValue.id);
    dropdownValue2 = listWard[0];
    _wardController.text = listWard[0].name;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 1.sp),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h, bottom: 3.h),
                  child: Center(
                    child: Text(
                      'Choose your address',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
                title('District:'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: DropdownButtonFormField(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide:
                              BorderSide(color: Colors.black, width: 1)),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.5,
                      ),
                    ),
                    onChanged: (District? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        _districtController.text = newValue.name;
                      });
                      listWard =
                          Provider.of<AddressItems>(context, listen: false)
                              .getWard(dropdownValue.id);
                      dropdownValue2 = listWard[0];
                    },
                    items: listDistrict.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 0.5,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                title('Ward:'),
                listWard.isEmpty
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child: DropdownButtonFormField(
                          value: dropdownValue2,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1)),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                            ),
                          ),
                          onChanged: (Ward? newValue) {
                            setState(() {
                              dropdownValue2 = newValue!;
                              _wardController.text = newValue.name;
                            });
                          },
                          items: listWard.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                title('Address:'),
                BuildTextField(
                    null,
                    TextInputType.text,
                    false,
                    'Please enter detail your address!',
                    _streetController,
                    'Ex: 12 Thach Thao',
                    () {}),
                Center(
                  child: Container(
                      width: 100.sp,
                      margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blue),
                      child: TextButton(
                          onPressed: () {
                            Provider.of<AddressItems>(context, listen: false)
                                .addressItem(AddressItem(
                                    stress: _streetController.text,
                                    ward: _wardController.text,
                                    districts: _districtController.text));
                            Navigator.pop(context);
                          },
                          child: Text('Choose',
                              style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
