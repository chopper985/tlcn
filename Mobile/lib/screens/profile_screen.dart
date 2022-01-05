import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop_application/common/voucherDefaulse.dart';
import 'package:flutter_shop_application/providers/address.dart';
import 'package:flutter_shop_application/providers/addresses.dart';
import 'package:flutter_shop_application/providers/auth.dart';
import 'package:flutter_shop_application/providers/voucher.dart';
import 'package:flutter_shop_application/widgets/sheet_address.dart';
import 'package:flutter_shop_application/widgets/widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_shop_application/providers/user.dart';

import 'drawer_screen.dart';
import 'products_overview_screen.dart';
import 'reset_password.dart';

enum listChoose { ChangePassword }

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';
  final String email;
  final bool isSignUp;
  const ProfileScreen({
    Key? key,
    required this.email,
    required this.isSignUp,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formkey = new GlobalKey<FormState>();
  bool gender = true;
  String imageAvatar =
      'https://firebasestorage.googleapis.com/v0/b/flutter-shop-d0a51.appspot.com/o/avatar.jpg?alt=media&token=cdb54cc3-6514-4e4f-b69b-8794450d2da3';
  String dropdownValue = 'Male';
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _birthdayController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  bool init = true;
  bool isLoading = false;
  bool? shouldPop;
  DateTime selectedDate = DateTime.now();
  DateFormat formatDate = DateFormat('dd/MM/yyyy');
  bool isStrechedDropDown = false;

  Future<DateTime?> _selectDateTime(BuildContext context) => showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now());

  Future<void> uploadImage(ImageSource source) async {
    final user = Provider.of<User>(context, listen: false).user;
    final fireStorage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    String imagefilename = user.id + DateTime.now().toString();
    XFile? image;

    //Check permission
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      // ignore: deprecated_member_use
      image = await _picker.pickImage(source: source);
      if (image == null) {
        return;
      }
      var file = File(image.path);
      //Upload to Firebase
      var snapshot = await fireStorage.ref().child(imagefilename).putFile(file);
      var download = await snapshot.ref.getDownloadURL();
      setState(() {
        imageAvatar = download;
      });
    } else {
      print('Grant Permission and try again');
    }
  }

  @override
  void initState() {
    setState(() {
      shouldPop = widget.isSignUp ? false : true;
    });
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        isLoading = true;
      });
      Provider.of<AddressItems>(context, listen: false).deleteItem();
      await Provider.of<AddressItems>(context, listen: false).getDistrict();
      final user = Provider.of<User>(context, listen: false).user;
      // ignore: unnecessary_null_comparison
      if (user != null) {
        _nameController.text = user.fullName;
        _birthdayController.text = user.birthday;
        _phoneNumberController.text = user.phoneNumber;
        _addressController.text = user.address;
        if (user.avatar != '') {
          imageAvatar = user.avatar;
        }
        dropdownValue = user.gender ? 'Male' : 'Female';
      }
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context).userId;
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
    final user = Provider.of<User>(context, listen: false).user;
    return WillPopScope(
        onWillPop: () async {
          return shouldPop!;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'My Profile',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            actions: [
              if (!widget.isSignUp)
                PopupMenuButton(
                  onSelected: (listChoose selected) {
                    if (selected == listChoose.ChangePassword) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => ResetPassword()));
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      height: 5.h,
                      child: Text('Change Password',
                          style: Theme.of(context).textTheme.bodyText2),
                      value: listChoose.ChangePassword,
                    ),
                  ],
                  icon: Icon(Icons.more_vert),
                ),
            ],
          ),
          body: isLoading
              ? Center(
                  child: Lottie.asset('assets/images/loading_plane_paper.json'))
              : Form(
                  key: _formkey,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  height: 80.sp,
                                  width: 115.sp,
                                  child: Stack(
                                      fit: StackFit.expand,
                                      clipBehavior: Clip.none,
                                      children: [
                                        CircleAvatar(
                                            // backgroundImage:
                                            //     NetworkImage(imageAvatar),
                                            child: ClipOval(
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/images/circle.gif',
                                                image: imageAvatar,
                                                fit: BoxFit.cover,
                                                width: 110.0,
                                                height: 120.0,
                                              ),
                                            ),
                                            radius: 50),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            height: 6.h,
                                            width: 12.w,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  side: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Color(0xFFF5F6F9),
                                              ),
                                              onPressed: () =>
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              ListTile(
                                                                  leading: Icon(
                                                                      Icons
                                                                          .camera_alt,
                                                                      color: Colors
                                                                          .blue),
                                                                  title: Text(
                                                                      'Camera'),
                                                                  onTap: () => {
                                                                        Navigator.of(context)
                                                                            .pop(ImageSource.camera),
                                                                        uploadImage(
                                                                            ImageSource.camera),
                                                                      }),
                                                              ListTile(
                                                                  leading: Icon(
                                                                      Icons
                                                                          .image,
                                                                      color: Colors
                                                                          .amber),
                                                                  title: Text(
                                                                      'Gallery'),
                                                                  onTap: () => {
                                                                        Navigator.of(context)
                                                                            .pop(ImageSource.gallery),
                                                                        uploadImage(
                                                                            ImageSource.gallery),
                                                                      }),
                                                            ]);
                                                      }),
                                              child: SvgPicture.asset(
                                                  "assets/images/Camera Icon.svg"),
                                            ),
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.email,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            title('Full name:'),
                            BuildTextField(
                                Icon(LineAwesomeIcons.user_secret,
                                    color: Colors.red),
                                TextInputType.text,
                                false,
                                'Please enter your full name!',
                                _nameController,
                                'Ex: Nguyen Phu',
                                () {}),
                            title('Gender:'),
                            DropButtonCustom(dropdownValue, (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            }),
                            title('Birthday:'),
                            BuildTextField(
                                Icon(LineAwesomeIcons.birthday_cake,
                                    color: Colors.cyan),
                                TextInputType.text,
                                true,
                                'Please enter your birthday!',
                                _birthdayController,
                                'Ex: 18/09/2000', () async {
                              final selectedDate =
                                  await _selectDateTime(context);
                              if (selectedDate != null) {
                                setState(() {
                                  this.selectedDate = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                  );
                                  _birthdayController.text =
                                      formatDate.format(this.selectedDate);
                                });
                              }
                            }),
                            title('Phone Number:'),
                            BuildTextField(
                                Icon(LineAwesomeIcons.mobile_phone,
                                    color: Colors.purple),
                                TextInputType.number,
                                false,
                                'Please enter your phone number!',
                                _phoneNumberController,
                                'Ex: 0928598741',
                                () {}),
                            title('Address'),
                            BuildTextField(
                                Icon(LineAwesomeIcons.globe,
                                    color: Colors.green),
                                TextInputType.text,
                                true,
                                'Please enter your address!',
                                _addressController,
                                'Ex: Street 11, Long Thanh Ward, District 1, Ho Chi Minh City',
                                () {
                              return showModalBottomSheet(
                                  isScrollControlled: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SheetAddress();
                                  });
                            }),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colors.blue.shade800,
                                        Colors.blue.withOpacity(0.7)
                                      ]),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: TextButton(
                                    onPressed: () async {
                                      try {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        if (!_formkey.currentState!
                                            .validate()) {
                                          // Invalid!
                                          return;
                                        }
                                        _formkey.currentState!.save();
                                        final userData = UserItem(
                                          id: widget.isSignUp ? '' : user.id,
                                          email: widget.email,
                                          phoneNumber:
                                              _phoneNumberController.text,
                                          gender: dropdownValue == "Male"
                                              ? true
                                              : false,
                                          address: _addressController.text,
                                          fullName: _nameController.text,
                                          avatar: imageAvatar,
                                          idUser: userId!,
                                          birthday: _birthdayController.text,
                                        );
                                        final address = Address(
                                            id: '',
                                            idUser: userId,
                                            address: _addressController.text,
                                            fullName: _nameController.text,
                                            phoneNumber:
                                                _phoneNumberController.text,
                                            status: true);
                                        if (widget.isSignUp) {
                                          await Provider.of<Addresses>(context,
                                                  listen: false)
                                              .addAddress(address);
                                          await Provider.of<User>(context,
                                                  listen: false)
                                              .addUser(userData)
                                              .then((value) async => {
                                                    await Provider.of<Voucher>(
                                                            context,
                                                            listen: false)
                                                        .addVoucher(voucher10),
                                                    await Provider.of<Voucher>(
                                                            context,
                                                            listen: false)
                                                        .addVoucher(voucher20),
                                                    await Provider.of<Voucher>(
                                                            context,
                                                            listen: false)
                                                        .addVoucher(voucher05),
                                                    await Provider.of<User>(
                                                            context,
                                                            listen: false)
                                                        .getUser(),
                                                    setState(() {
                                                      isLoading = false;
                                                    }),
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder: (ctx) =>
                                                                    Scaffold(
                                                                        body:
                                                                            Stack(
                                                                      children: [
                                                                        DrawerScreen(),
                                                                        ProductsOverviewScreen(),
                                                                      ],
                                                                    ))))
                                                  });
                                        } else {
                                          await Provider.of<User>(context,
                                                  listen: false)
                                              .updateUser(userData)
                                              .then((value) async => {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: const Text(
                                                      'Update Profile Success!',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))),
                                                    await Provider.of<User>(
                                                            context,
                                                            listen: false)
                                                        .getUser(),
                                                    setState(() {
                                                      isLoading = false;
                                                    })
                                                  });
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  )),
                            )
                          ]),
                    ),
                  ),
                ),
        ));
  }
}
