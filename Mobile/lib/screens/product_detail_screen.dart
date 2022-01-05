import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/auth.dart';
import 'package:flutter_shop_application/providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int activeSize = 0;

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                )
              ], borderRadius: BorderRadius.circular(30), color: Colors.white),
              child: Stack(
                children: <Widget>[
                  //image
                    FadeInDown(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2.5,
                        child: ClipRRect(
                          child: Image.network(
                            loadedProduct.imageUrl,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  SafeArea(
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FadeInDown(
              delay: Duration(milliseconds: 350),
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Text(
                  loadedProduct.title,
                  style: TextStyle(
                      fontSize: 35, fontWeight: FontWeight.w600, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FadeInDown(
              delay: Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Text(
                  "\$ " + '${loadedProduct.price}',
                  style: TextStyle(
                      fontSize: 35, fontWeight: FontWeight.w500, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FadeInDown(
                      delay: Duration(milliseconds: 450),
                      child: Text(
                        "Size",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    FadeInDown(
                      delay: Duration(milliseconds: 450),
                      child: Text(
                        "Size Guide",
                        style: TextStyle(
                            fontSize: 15, color: Colors.black.withOpacity(0.7)),
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: 25,
            ),
            FadeInDown(
              delay: Duration(milliseconds: 500),
              child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 25),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(4, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              activeSize = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 15, bottom: 5, left: 5, top: 5),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                  color: activeSize == index
                                      ? Colors.black
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 0.5,
                                        blurRadius: 1,
                                        color: Colors.black.withOpacity(0.1))
                                  ]),
                              child: Center(
                                child: Text(
                                  '41',
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: activeSize == index
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  )),
            ),
            SizedBox(
              height: 50,
            ),
            FadeInDown(
              delay: Duration(milliseconds: 550),
              child: Padding(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  children: <Widget>[
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 0.5,
                                  blurRadius: 1,
                                  color: Colors.black.withOpacity(0.1))
                            ],
                            color: Colors.grey.shade100),
                        child: loadedProduct.isFavorite
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite,
                                color: Colors.grey,
                              )),
                    SizedBox(
                      width: 15,
                    ),
                    Flexible(
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            color: Colors.black,
                            onPressed: () {},
                            child: Container(
                              height: 50,
                              child: Center(
                                child: Text(
                                  "ADD TO CART",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
