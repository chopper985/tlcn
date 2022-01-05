import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_web_admin/constants/controllers.dart';
import 'package:tl_web_admin/helpers/reponsiveness.dart';
import 'package:tl_web_admin/pages/orders/orders.dart';
import 'package:tl_web_admin/providers/order.dart';
import 'package:provider/provider.dart';
import 'package:tl_web_admin/routing/routes.dart';
import 'info_card_small.dart';

class OverviewCardsSmallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    final order = Provider.of<Order>(context);
    PageRoute _getPageRoute(Widget child) {
      return MaterialPageRoute(builder: (context) => child);
    }

    void switchOrder(String status) {
      order.setStatus(status);
      _getPageRoute(OrdersPage());
      menuController.changeActiveItemTo(ordersPageDisplayName);
      if (ResponsiveWidget.isSmallScreen(context)) Get.back();
      navigationController.navigateTo(ordersPageRoute);
    }

    return Container(
      height: 400,
      child: Column(
        children: [
          InfoCardSmall(
            title: "Ordered",
            value: order.listOrdered.length.toString(),
            onTap: () => switchOrder('Ordered'),
            isActive: true,
          ),
          SizedBox(
            height: _width / 64,
          ),
          InfoCardSmall(
            title: "Packed",
            value: order.listPacked.length.toString(),
            onTap: () => switchOrder('Packed'),
          ),
          SizedBox(
            height: _width / 64,
          ),
          InfoCardSmall(
            title: "In Transit",
            value: order.listIntransit.length.toString(),
            onTap: () => switchOrder('In transit'),
          ),
          SizedBox(
            height: _width / 64,
          ),
          InfoCardSmall(
            title: "Delivered",
            value: order.listDelivered.length.toString(),
            onTap: () => switchOrder('Delivered'),
          ),
        ],
      ),
    );
  }
}
