import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_web_admin/constants/controllers.dart';
import 'package:tl_web_admin/helpers/reponsiveness.dart';
import 'package:tl_web_admin/pages/orders/orders.dart';
import 'package:tl_web_admin/pages/overview/widgets/info_card.dart';
import 'package:tl_web_admin/providers/order.dart';
import 'package:provider/provider.dart';
import 'package:tl_web_admin/routing/routes.dart';

class OverviewCardsMediumScreen extends StatelessWidget {
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
      if (ResponsiveWidget.isMediumScreen(context)) Get.back();
      navigationController.navigateTo(ordersPageRoute);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            InfoCard(
              title: "Ordered",
              value: order.listOrdered.length.toString(),
              onTap: () => switchOrder('Ordered'),
              topColor: Colors.orange,
            ),
            SizedBox(
              width: _width / 64,
            ),
            InfoCard(
              title: "Packed",
              value: order.listPacked.length.toString(),
              topColor: Colors.lightGreen,
              onTap: () => switchOrder('Packed'),
            ),
          ],
        ),
        SizedBox(
          height: _width / 64,
        ),
        Row(
          children: [
            InfoCard(
              title: "In Transit",
              value: order.listIntransit.length.toString(),
              topColor: Colors.redAccent,
              onTap: () => switchOrder('In transit'),
            ),
            SizedBox(
              width: _width / 64,
            ),
            InfoCard(
              title: "Delivered",
              value: order.listDelivered.length.toString(),
              onTap: () => switchOrder('Delivered'),
            ),
          ],
        ),
      ],
    );
  }
}
