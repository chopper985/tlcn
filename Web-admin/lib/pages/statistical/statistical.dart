import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tl_web_admin/constants/controllers.dart';
import 'package:tl_web_admin/helpers/reponsiveness.dart';
import 'package:tl_web_admin/pages/statistical/widget/order_section_large.dart';
import 'package:tl_web_admin/pages/statistical/widget/order_section_small.dart';
import 'package:tl_web_admin/providers/order.dart';
import 'package:tl_web_admin/widgets/custom_text.dart';
import 'package:get/get.dart';

class StatisticalPage extends StatefulWidget {
  const StatisticalPage({Key key}) : super(key: key);

  @override
  State<StatisticalPage> createState() => _StatisticalPageState();
}

class _StatisticalPageState extends State<StatisticalPage> {
  bool _isInit = true;
  bool _isLoading = false;
  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Order>(context, listen: false)
          .fetchAllOrder()
          .then((_) => _isLoading = false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Obx(
            () => Row(
              children: [
                Container(
                    margin: EdgeInsets.only(
                        top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                    child: CustomText(
                      text: menuController.activeItem.value,
                      size: 24,
                      weight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              if (!ResponsiveWidget.isSmallScreen(context))
                OrderSectionLarge()
              else
                OrderSectionSmall(),
            ],
          )),
        ],
      ),
    );
  }
}
