import 'package:flutter/material.dart';
import 'package:tl_web_admin/constants/style.dart';
import 'package:tl_web_admin/controllers/menu_controller.dart';
import 'package:tl_web_admin/controllers/navigation_controller.dart';
import 'package:tl_web_admin/layout.dart';
import 'package:tl_web_admin/pages/404/error.dart';
import 'package:tl_web_admin/pages/authentication/authentication.dart';
import 'package:tl_web_admin/providers/auth.dart';
import 'package:tl_web_admin/providers/local.dart';
import 'package:tl_web_admin/providers/order.dart';
import 'package:tl_web_admin/providers/products.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/user.dart';
import 'routing/routes.dart';

void main() {
  Get.put(MenuController());
  Get.put(NavigationController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Local(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (_) => Products(),
              update: (_, auth, previousProducts) =>
                  previousProducts..update(auth.token, auth.userId)),
          ChangeNotifierProxyProvider<Auth, Order>(
              create: (_) => Order(),
              update: (_, auth, previousOrder) =>
                  previousOrder..update(auth.token, auth.userId)),
          ChangeNotifierProxyProvider<Auth, User>(
              create: (_) => User(),
              update: (_, auth, previousOrder) =>
                  previousOrder..update(auth.token, auth.userId)),
        ],
        child: GetMaterialApp(
          initialRoute: authenticationPageRoute,
          unknownRoute: GetPage(
              name: '/not-found',
              page: () => PageNotFound(),
              transition: Transition.fadeIn),
          getPages: [
            GetPage(
                name: rootRoute,
                page: () {
                  return SiteLayout();
                }),
            GetPage(
                name: authenticationPageRoute,
                page: () => AuthenticationPage()),
          ],
          debugShowCheckedModeBanner: false,
          title: 'Dashboard',
          theme: ThemeData(
            scaffoldBackgroundColor: light,
            textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: Colors.black),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            }),
            primarySwatch: Colors.blue,
          ),
          // home: AuthenticationPage(),
        ));
  }
}
