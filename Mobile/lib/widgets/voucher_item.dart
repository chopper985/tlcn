import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/voucher.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class VoucherItemScreen extends StatelessWidget {
  final String title;
  final int maxDiscount;
  final int percent;
  final bool check;
  const VoucherItemScreen(
      {Key? key,
      required this.title,
      required this.maxDiscount,
      required this.percent,
      required this.check})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
          // ignore: unnecessary_null_comparison
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Stack(children: [
       if(check) Positioned(
          right: 0,
          top: 0,
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(
              Icons.check,
              color: Colors.red.shade400,
              size: 24,
            ),
            radius: 13,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: CircleAvatar(
                child: Text(
                  '${percent.toString()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                backgroundColor: Colors.black,
                radius: 30,
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 15.sp,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Up to ${maxDiscount.toString()}\$',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 11.sp,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/giayImage.jpg'),
                radius: 25,
              ),
            )
          ],
        ),
      ]),
    );
  }
}
