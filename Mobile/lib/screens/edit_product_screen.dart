import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/product.dart';
import 'package:flutter_shop_application/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: 'null', title: '', description: '', price: 0, imageUrl: '',type:'Men');
  var _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    _imageUrlNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlNode.removeListener(_updateImage);
    _imageUrlNode.dispose();
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (!_imageUrlNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != 'null') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        return showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text('Something went wrong'),
                  actions: [
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Okay'))
                  ],
                ));
      }).then((_) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Product',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save_alt))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _editedProduct.title,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintStyle: TextStyle(fontSize: 12.0),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value!,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                          type: _editedProduct.type
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct.price.toString(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Price',
                        hintStyle: TextStyle(fontSize: 12.0),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: int.parse(value!),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                          type: _editedProduct.type
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct.description,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintStyle: TextStyle(fontSize: 12.0),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value!,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                          type: _editedProduct.type
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 30.0, right: 10.0),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text(
                                    'Enter a URL',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  )
                                : Container(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.contain,
                                    ),
                                  )),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid image URL';
                              }
                              if (!value.endsWith('.jpg') &&
                                  !value.endsWith('.png') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Image',
                              hintStyle: TextStyle(fontSize: 12.0),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.0),
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            focusNode: _imageUrlNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value!,
                                isFavorite: _editedProduct.isFavorite,
                                type: _editedProduct.type
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
