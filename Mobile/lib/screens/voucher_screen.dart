import 'package:flutter/material.dart';
import 'package:flutter_shop_application/common/voucherDefaulse.dart';
import 'package:flutter_shop_application/providers/voucher.dart';
import 'package:flutter_shop_application/widgets/voucher_item.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:sizer/sizer.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final voucher = Provider.of<Voucher>(context).items;
    final defaultIndexVoucher = Provider.of<Voucher>(context).indexDefault;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Your Voucher',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          actions: [
            if (voucher != [])
              IconButton(
                  onPressed: () {
                    Provider.of<Voucher>(context, listen: false)
                        .selectDefault(voucher[defaultIndexVoucher].id);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                      'You Chosen ${voucher[defaultIndexVoucher].title}!',
                      style: TextStyle(color: Colors.white),
                    )));
                  },
                  icon: Icon(Icons.save))
          ],
        ),
        body: ListView.builder(
            itemCount: voucher.length,
            itemBuilder: (ctx, index) => InkWell(
                onTap: () {
                  Provider.of<Voucher>(context, listen: false)
                      .selectIndexDefault(index);
                },
                child: VoucherItemScreen(
                    check: (defaultIndexVoucher == index) ? true : false,
                    title: voucher[index].title,
                    maxDiscount: voucher[index].maxDiscount,
                    percent: voucher[index].percent))));
  }
}
