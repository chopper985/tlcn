import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/address.dart';
import 'package:flutter_shop_application/providers/addresses.dart';
import 'package:flutter_shop_application/providers/user.dart';
import 'package:flutter_shop_application/widgets/sheet_address.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
// import '../../providers/directions_repository.dart';
// import 'map_google.dart';

class EditAddress extends StatefulWidget {
  final String id;
  final String name;
  final String phoneNumber;
  final String address;
  final bool defaultStatus;
  const EditAddress(
      {Key? key,
      required this.name,
      required this.phoneNumber,
      required this.address,
      required this.defaultStatus,
      required this.id})
      : super(key: key);

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final _formkey = new GlobalKey<FormState>();
  bool defaultStatus = false;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void initState() {
    _nameController.text = widget.name;
    _phoneNumberController.text = widget.phoneNumber;
    _addressController.text = widget.address;
    defaultStatus = widget.defaultStatus;
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<AddressItems>(context, listen: false).getDistrict();
      final address = Provider.of<AddressItems>(context, listen: false).item;
      if (address != null) {
        Provider.of<AddressItems>(context, listen: false).deleteItem();
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final address = Provider.of<AddressItems>(context).item;
    if (address != null) {
      setState(() {
        _addressController.text = address.stress +
            ', ' +
            address.ward +
            ', ' +
            address.districts +
            ', thành phố Hồ Chí Minh';
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit My Address',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      body: _isLoading
          ? Center(
              child: Lottie.asset('assets/images/loading_plane_paper.json'))
          : Form(
              key: _formkey,
              child: Container(
                padding: EdgeInsets.all(5.sp),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contact :',
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 11.sp,
                              letterSpacing: 1.0)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 13.sp,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.normal,
                          ),
                          validator: (val) => val!.trim().length == 0
                              ? 'Please enter my name!'
                              : null,
                          controller: _nameController,
                          decoration: InputDecoration(
                            prefixIcon: Container(
                                child: new Icon(
                              LineAwesomeIcons.user_secret,
                              color: Colors.blue,
                            )),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 2),
                            ),
                            hintText: 'Ex: Tom Hiddleston',
                            hintStyle: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 13.sp,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.normal,
                          ),
                          validator: (val) => val!.trim().length == 0
                              ? 'Please enter my phone number!'
                              : null,
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            prefixIcon: Container(
                                child: new Icon(
                              LineAwesomeIcons.mobile_phone,
                              color: Colors.purple,
                            )),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 2),
                            ),
                            hintText: 'Ex: 212 823 9800',
                            hintStyle: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text('Address :',
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 11.sp,
                              letterSpacing: 1.0)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          readOnly: true,
                          onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return SheetAddress();
                                });
                          },
                          style: TextStyle(
                            fontSize: 13.sp,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.normal,
                          ),
                          validator: (val) => val!.trim().length == 0
                              ? 'Please enter my address!'
                              : null,
                          controller: _addressController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 2),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.location_on),
                              onPressed: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (ctx) => MapScreen(
                                //         isCreate: false,
                                //         name: _nameController.text,
                                //         phoneNumber: _phoneNumberController.text,
                                //         defaultStatus: defaultStatus)));
                              },
                            ),
                            prefixIcon: Container(
                                child: new Icon(
                              LineAwesomeIcons.globe,
                              color: Colors.green,
                            )),
                            fillColor: Colors.white,
                            hintText:
                                'Ex: 10 Columbus Cir., 4th fl, New York, USA',
                            hintStyle: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text('Settings :',
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 11.sp,
                              letterSpacing: 1.0)),
                      SizedBox(height: 0.7.h),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Set as default address',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    letterSpacing: 1.0)),
                          ),
                          Spacer(),
                          Switch(
                              inactiveThumbColor: Colors.orange,
                              inactiveTrackColor:
                                  Colors.orange.withOpacity(0.4),
                              value: defaultStatus,
                              onChanged: defaultStatus == true
                                  ? null
                                  : (val) {
                                      setState(() {
                                        defaultStatus = !defaultStatus;
                                      });
                                    })
                        ],
                      ),
                      SizedBox(height: 7.h),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Colors.blue.shade800,
                          Colors.blue.withOpacity(0.7)
                        ])),
                        width: double.infinity,
                        child: TextButton(
                            onPressed: () async {
                              try {
                                setState(() {
                                  _isLoading = true;
                                });
                                await Provider.of<Addresses>(context,
                                        listen: false)
                                    .updateAddress(
                                        widget.id,
                                        Address(
                                            id: widget.id,
                                            address: _addressController.text,
                                            fullName: _nameController.text,
                                            phoneNumber:
                                                _phoneNumberController.text,
                                            idUser: '123',
                                            status: defaultStatus))
                                    .then((value) => {
                                          setState(() {
                                            _isLoading = false;
                                          }),
                                          Navigator.of(context).pop()
                                        });
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
