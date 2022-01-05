import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/aboutUs.dart';
import 'package:flutter_shop_application/providers/addresses.dart';
import 'package:flutter_shop_application/providers/auth.dart';
import 'package:flutter_shop_application/providers/product.dart';
import 'package:flutter_shop_application/providers/products.dart';
import 'package:flutter_shop_application/providers/user.dart';
import 'package:flutter_shop_application/screens/cart_screen.dart';
import 'package:flutter_shop_application/screens/drawer_screen.dart';
import 'package:flutter_shop_application/widgets/badge.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';

import 'auth_screen.dart';

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = "/products-overview";
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen>
    with SingleTickerProviderStateMixin {
  bool _showFavoritesOnly = false;
  bool _isInit = true;
  bool _isLoading = false;
  List<Product>? searchProducts;
  String keysearch = "";
  TextEditingController _keysearch = new TextEditingController();
  AnimationController? controller;
  String _isType = 'All';

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context)
          .fetchProducts()
          .then((_) => _isLoading = false);
      final isAuth = Provider.of<Auth>(context, listen: false).isAuth;
      final email = Provider.of<Auth>(context, listen: false).email;
      print(email);
      email != 'guest@guest.com'
          ? await Provider.of<User>(context, listen: false).getUser()
          // ignore: unnecessary_statements
          : null;
      await Provider.of<AboutUsInfor>(context, listen: false).fetchAboutUs();
      email != 'guest@guest.com'
          ? await Provider.of<Addresses>(context, listen: false).fetchAddresss()
          // ignore: unnecessary_statements
          : null;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshProducts() async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final auth = Provider.of<Auth>(context).isAuth;
    FocusScopeNode currentFocus = FocusScope.of(context);
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        title: Text(
          'My Shop',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        actions: [
          AnimatedIconButton(
            duration: Duration(milliseconds: 1000),
            size: 25,
            onPressed: () {
              auth == false
                  ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text(
                        'To perform the function please login! Click ->',
                        style: TextStyle(color: Colors.black),
                      ),
                      duration: Duration(seconds: 2),
                      backgroundColor: Color.fromRGBO(252, 207, 218, 1),
                      action: SnackBarAction(
                        label: 'LOGIN',
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AuthenScreen.routeName);
                        },
                      ),
                    ))
                  : setState(() {
                      _showFavoritesOnly = !_showFavoritesOnly;
                    });
            },
            icons: [
              AnimatedIconItem(icon: Icon(Icons.list_alt, color: Colors.black)),
              AnimatedIconItem(icon: Icon(Icons.favorite, color: Colors.red))
            ],
          ),
          Consumer<Cart>(
            builder: (_, value, ch) => Badge(
              child: ch!,
              value: value.cartItemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: GestureDetector(
          onTap: () {
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            children: [
              Container(
                height: size.height / 12,
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: _keysearch,
                  onSubmitted: (val) {
                    setState(() {
                      _keysearch.text = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search ?",
                    prefixIcon: Icon(
                      Icons.search,
                      size: 28,
                    ),
                    suffixIcon: _keysearch.text.length != 0
                        ? IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _keysearch.text = '';
                              });
                            })
                        : null,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                height: 6.h,
                width: double.infinity,
                child: Wrap(
                  spacing: 10.sp,
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            _isType = "All";
                          });
                        },
                        child: customChip('All', Icons.all_inclusive,
                            Colors.purple, _isType)),
                    InkWell(
                        onTap: () {
                          setState(() {
                            _isType = "Men";
                          });
                        },
                        child: customChip(
                            'Men', Icons.male, Colors.blue, _isType)),
                    InkWell(
                        onTap: () {
                          setState(() {
                            _isType = "Women";
                          });
                        },
                        child: customChip('Women', Icons.female,
                            Colors.pink.shade300, _isType)),
                    InkWell(
                        onTap: () {
                          setState(() {
                            _isType = "Kid";
                          });
                        },
                        child: customChip(
                            'Kid', Icons.child_care, Colors.green, _isType)),
                    // IconButton(
                    //     onPressed: () {}, icon: Icon(Icons.more_vert))
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _refreshProducts(),
                        child: ProductsGrid(
                          isType: _isType,
                          showFavs: _showFavoritesOnly,
                          keywords: _keysearch.text,
                        ),
                      ),
              )
            ],
          )),
    );
  }

  Chip customChip(String name, IconData icon, Color color, String ischeck) {
    return Chip(
      backgroundColor: ischeck == name ? color : Colors.grey,
      label: Text(name, style: TextStyle(color: Colors.white, fontSize: 15)),
      avatar: CircleAvatar(
        child: Icon(icon, color: ischeck == name ? color : Colors.grey),
        backgroundColor: Colors.white.withOpacity(0.8),
      ),
    );
  }
}
