import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:provider/provider.dart';
import 'package:tl_web_admin/constants/controllers.dart';
import 'package:tl_web_admin/helpers/reponsiveness.dart';
import 'package:tl_web_admin/providers/local.dart';
import 'package:tl_web_admin/providers/product.dart';
import 'package:tl_web_admin/providers/products.dart';
import 'package:tl_web_admin/widgets/custom_text.dart';

import 'create_product.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({
    Key key,
  }) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  String id = '';
  String dropdownValue = 'Men';
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isInit = true;
  // @override
  // void initState() {
  //   final product = Provider.of<Products>(context).editProduct;
  //   id = product.id;
  //   titleController.text = product.title;
  //   descriptionController.text = product.description;
  //   priceController.text = product.price.toString();
  //   imageUrlController.text = product.imageUrl;
  //   dropdownValue = product.type;
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final product = Provider.of<Products>(context).editProduct;
      id = product.id;
      titleController.text = product.title;
      descriptionController.text = product.description;
      priceController.text = product.price.toString();
      imageUrlController.text = product.imageUrl;
      dropdownValue = product.type;
      dropdownValue = product.type;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final products = Provider.of<Products>(context);
    final local = Provider.of<Local>(context);
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(
                () => Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                            top: ResponsiveWidget.isSmallScreen(context)
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
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Center(
                  child: Text('Edit Product',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.5,
                      )),
                ),
              ),
              BuildTextField(titleController, 'Product Name:',
                  placeholder: 'Ex: Converse Classic'),
              DropButtonCustom02(context, dropdownValue, (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              }, 'Type:'),
              BuildTextField(descriptionController, 'Description:',
                  placeholder: 'Ex: Color'),
              BuildTextField(priceController, 'Price:',
                  placeholder: 'Ex: 100', suffixText: '\$'),
              BuildTextField(imageUrlController, 'URL Image:',
                  placeholder: 'Ex: url'),
              Center(
                child: Container(
                  width: 550,
                  child: Row(
                    children: [
                      Container(),
                      Spacer(),
                      Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 15),
                          height: size.height / 15,
                          width: 80,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.red,
                                Colors.red.withOpacity(0.8)
                              ]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: TextButton(
                              onPressed: () async {
                                local.changeProductScreenStatus('Default');
                              },
                              child: Text('Cancel',
                                  style: TextStyle(color: Colors.white)))),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 15),
                          height: size.height / 15,
                          width: 120,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.orange,
                                Colors.orange.withOpacity(0.8)
                              ]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: _isLoading
                              ? CircularProgressIndicator()
                              : TextButton(
                                  onPressed: () async {
                                    if (_formkey.currentState.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      final product = new Product(
                                          id: id,
                                          title: titleController.text,
                                          description:
                                              descriptionController.text,
                                          price:
                                              int.parse(priceController.text),
                                          type: dropdownValue,
                                          imageUrl: imageUrlController.text,
                                          isFavorite: false);
                                      await products
                                          .updateProduct(id, product)
                                          .then((value) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: const Text(
                                          'Create Product Success!',
                                          style: TextStyle(color: Colors.white),
                                        )));
                                        local.changeProductScreenStatus(
                                            'Default');
                                      });
                                    }
                                  },
                                  child: Text('Edit',
                                      style: TextStyle(color: Colors.white)))),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
