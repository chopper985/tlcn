import 'package:flutter/material.dart';
import 'package:tl_web_admin/helpers/reponsiveness.dart';
import 'package:tl_web_admin/constants/controllers.dart';
import 'package:tl_web_admin/pages/statistical/widget/order_section_large.dart';
import 'package:tl_web_admin/pages/statistical/widget/order_section_small.dart';
import 'package:tl_web_admin/pages/overview/widgets/overview_cards_large.dart';
import 'package:tl_web_admin/pages/overview/widgets/overview_cards_medium.dart';
import 'package:tl_web_admin/pages/overview/widgets/overview_cards_small.dart';
import 'package:tl_web_admin/pages/overview/widgets/revenue_section_large.dart';
import 'package:tl_web_admin/providers/order.dart';
import 'package:tl_web_admin/providers/user.dart';
import 'package:tl_web_admin/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'widgets/revenue_section_small.dart';

class OverviewPage extends StatefulWidget {
  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  bool _isLoading = false;
  bool _isInit = true;
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
              if (ResponsiveWidget.isLargeScreen(context) ||
                  ResponsiveWidget.isMediumScreen(context))
                if (ResponsiveWidget.isCustomSize(context))
                  OverviewCardsMediumScreen()
                else
                  OverviewCardsLargeScreen()
              else
                OverviewCardsSmallScreen(),
              if (!ResponsiveWidget.isSmallScreen(context))
                RevenueSectionLarge()
              else
                RevenueSectionSmall(),
         
            ],
          ))
        ],
      ),
    );
  }
}
