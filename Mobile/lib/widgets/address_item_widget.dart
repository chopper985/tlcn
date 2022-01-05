import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AddressItemWidget extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String address;
  final Function() handle;
  const AddressItemWidget({
    Key? key,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.handle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(5.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.green),
                  SizedBox(width: 1.w),
                  Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('Deliver address',
                            style: Theme.of(context).textTheme.subtitle1),
                        SizedBox(height: 0.5.h),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: name,
                              style: Theme.of(context).textTheme.subtitle2),
                          TextSpan(
                              text: ' | ',
                              style: Theme.of(context).textTheme.subtitle2),
                          TextSpan(
                              text: phoneNumber,
                              style: Theme.of(context).textTheme.subtitle2),
                        ])),
                        Container(
                          width: 80.w,
                          child: Text(
                            address,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subtitle2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ])),
                ],
              ),
              Spacer(),
              Icon(Icons.keyboard_arrow_right_rounded)
            ],
          )),
      onTap: handle,
    );
  }
}
