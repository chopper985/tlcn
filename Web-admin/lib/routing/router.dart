import 'package:flutter/material.dart';
import 'package:tl_web_admin/pages/clients/clients.dart';
import 'package:tl_web_admin/pages/orders/orders.dart';
import 'package:tl_web_admin/pages/overview/overview.dart';
import 'package:tl_web_admin/pages/products/products.dart';
import 'package:tl_web_admin/pages/statistical/statistical.dart';
import 'package:tl_web_admin/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case overviewPageRoute:
      return _getPageRoute(OverviewPage());
    case statisticalPageRoute:
      return _getPageRoute(StatisticalPage());
    case productsPageRoute:
      return _getPageRoute(ProductsPage());
    case ordersPageRoute:
      return _getPageRoute(OrdersPage());
    case clientsPageRoute:
      return _getPageRoute(ClientsPage());

    default:
      return _getPageRoute(OverviewPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
