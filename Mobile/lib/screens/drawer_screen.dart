import 'package:flutter/material.dart';
import 'package:flutter_shop_application/helper/custom_route.dart';
import 'package:flutter_shop_application/providers/auth.dart';
import 'package:flutter_shop_application/providers/user.dart';
import 'package:flutter_shop_application/screens/auth_screen.dart';
import 'package:flutter_shop_application/screens/order_screen.dart';
import 'package:flutter_shop_application/screens/products_overview_screen.dart';
import 'package:flutter_shop_application/screens/profile_screen.dart';
import 'package:flutter_shop_application/screens/setting_screen.dart';
import 'package:flutter_shop_application/screens/user_product_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'about_us_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      try {
        final email = Provider.of<Auth>(context, listen: false).email;
        print(email);
        email != 'guest@guest.com'
            ? await Provider.of<User>(context, listen: false).getUser()
            // ignore: unnecessary_statements
            : null;
      } catch (error) {}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context).user;
    return isLoading
        ? Center(child: Lottie.asset('assets/images/loading_plane_paper.json'))
        : Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: ClipRRect(
              child: Drawer(
                child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0)),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: double.infinity,
                          color: Color.fromRGBO(143, 148, 251, 1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    user.avatar == ''
                                        ? 'https://firebasestorage.googleapis.com/v0/b/flutter-shop-d0a51.appspot.com/o/avatar.jpg?alt=media&token=cdb54cc3-6514-4e4f-b69b-8794450d2da3'
                                        : user.avatar,
                                    scale: 1.0),
                                radius: 50.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                user.fullName == '' ? 'Guest' : user.fullName,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                  user.email == ''
                                      ? 'Guest@guest.com'
                                      : user.email,
                                  style: Theme.of(context).textTheme.subtitle2),
                            ],
                          ),
                        ),
                      ),
                      user.email == ''
                          ? Container(
                              margin: EdgeInsets.only(top: 40.0),
                              child: Column(children: [
                                ListTile(
                                  onTap: () {
                                    Provider.of<Auth>(context, listen: false)
                                        .logOut();
                                    Provider.of<User>(context, listen: false)
                                        .logout();
                                  },
                                  leading: Icon(Icons.lock),
                                  title: Text('Login'),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(AboutUsScreen.routeName);
                                  },
                                  leading: Icon(Icons.info),
                                  title: Text('About'),
                                ),
                              ]))
                          : Container(
                              margin: EdgeInsets.only(top: 40.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName);
                                    },
                                    leading: Icon(Icons.task),
                                    title: Text('Home'),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileScreen(
                                                    email: user.email,
                                                    isSignUp: false,
                                                  )));
                                    },
                                    leading: Icon(Icons.account_box),
                                    title: Text('Profile'),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(CustomRoute(
                                          builder: (ctx) => OrderScreen()));
                                    },
                                    leading: Icon(Icons.task),
                                    title: Text('Order'),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed(SettingScreen.routeName);
                                    },
                                    leading: Icon(Icons.settings),
                                    title: Text('Languages'),
                                  ),
                                  ListTile(
                                      leading: Icon(Icons.info),
                                      title: Text('About us'),
                                      onTap: () {
                                        Navigator.of(context).push(CustomRoute(
                                            builder: (ctx) => AboutUsScreen()));
                                      }),
                                  ListTile(
                                    leading: Icon(Icons.logout),
                                    title: Text('Log out'),
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
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(
                                                      width: 15.0,
                                                    ),
                                                    Text('Are you sure?')
                                                  ],
                                                ),
                                                content: Text(
                                                    'Do you want to sign out of the app?'),
                                                actions: [
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: const Text('No')),
                                                  // ignore: deprecated_member_use
                                                  FlatButton(
                                                      onPressed: () {
                                                        Provider.of<Auth>(
                                                                context,
                                                                listen: false)
                                                            .logOut();
                                                        Provider.of<User>(
                                                                context,
                                                                listen: false)
                                                            .logout();
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: const Text('Yes')),
                                                ],
                                              ));
                                    },
                                  ),
                                ],
                              ))
                    ])),
              ),
            ),
          );
  }
}
