import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tl_web_admin/constants/style.dart';
import 'package:tl_web_admin/pages/overview/widgets/bar_chart.dart';
import 'package:tl_web_admin/pages/overview/widgets/revenue_info.dart';
import 'package:tl_web_admin/providers/order.dart';
import 'package:tl_web_admin/widgets/custom_text.dart';

class RevenueSectionLarge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Order>(context);
    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 6),
              color: lightGrey.withOpacity(.1),
              blurRadius: 12)
        ],
        border: Border.all(color: lightGrey, width: .5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText(
                  text: "Revenue Chart",
                  size: 20,
                  weight: FontWeight.bold,
                  color: lightGrey,
                ),
                Container(
                    width: 600,
                    height: 200,
                    child: SimpleBarChart.withSampleData(context)),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 120,
            color: lightGrey,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    RevenueInfo(
                      title: "Today\'s revenue",
                      amount: orders.totalMoneyToday().toString(),
                    ),
                    RevenueInfo(
                      title: "Last 7 days",
                      amount: orders.totalMoneyWeekly().toString(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    RevenueInfo(
                      title: "Last 30 days",
                      amount: orders.totalMoneyMonth().toString(),
                    ),
                    RevenueInfo(
                      title: "Last 12 months",
                      amount: orders.totalMoneyYear().toStringAsFixed(0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
