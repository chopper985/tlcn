import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:provider/provider.dart';
import 'package:tl_web_admin/constants/controllers.dart';
import 'package:tl_web_admin/helpers/reponsiveness.dart';
import 'package:tl_web_admin/pages/products/products.dart';
import 'package:tl_web_admin/providers/local.dart';
import 'package:tl_web_admin/providers/product.dart';
import 'package:tl_web_admin/providers/products.dart';
import 'package:tl_web_admin/widgets/custom_text.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({Key key}) : super(key: key);

  @override
  _CreateProductState createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  String dropdownValue = 'Men';
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
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
                  child: Text('Create New Product',
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
                          height: size.height / 13,
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
                      SizedBox(width: 10),
                      Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 15),
                          height: size.height / 13,
                          width: 120,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.green,
                                Colors.green.withOpacity(0.8)
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
                                          id: '',
                                          title: titleController.text,
                                          description:
                                              descriptionController.text,
                                          price:
                                              int.parse(priceController.text),
                                          type: dropdownValue,
                                          imageUrl: imageUrlController.text,
                                          isFavorite: false);
                                      await products
                                          .addProduct(product)
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
                                  child: Text('Create',
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

Center BuildTextField(TextEditingController nameController, String title,
    {Widget icon,
    String suffixText,
    TextInputType tyle,
    String vali,
    String placeholder,
    Function() handle}) {
  return Center(
    child: Container(
      width: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 05, 20, 05),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 05, 20, 05),
            child: TextFormField(
              keyboardType: tyle,
              onTap: handle,
              controller: nameController,
              validator: (val) =>
                  val.trim().length == 0 ? 'Do not empty' : null,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
              decoration: InputDecoration(
                fillColor: Colors.black,
                hintText: placeholder,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.5,
                ),
                suffixText: suffixText,
                prefixIcon: icon,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.black, width: 1)),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Center DropButtonCustom02(BuildContext context, String dropdownValue,
    Function(String) handle, String title) {
  final size = MediaQuery.of(context).size;
  return Center(
    child: Container(
      width: 600,
      height: size.height / 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 05, 20, 05),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 05, 20, 05),
            child: DropdownButtonFormField<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 18,
              elevation: 0,
              style: const TextStyle(color: Colors.deepPurple),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.black, width: 1)),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.5,
                ),
              ),
              onChanged: handle,
              items: <String>['Men', 'Women', 'Kid']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      value == 'Men'
                          ? Icon(Icons.male, color: Colors.blue)
                          : value == 'Women'
                              ? Icon(Icons.female, color: Colors.pink.shade300)
                              : Icon(Icons.child_care, color: Colors.green),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}
