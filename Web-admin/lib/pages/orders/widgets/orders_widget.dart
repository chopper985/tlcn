import 'package:flutter/material.dart';
import 'package:tl_web_admin/constants/style.dart';

class InfoOrderCard extends StatelessWidget {
  final String title;
  final String value;
  final Color topColor;
  final bool isActive;
  final Function onTap;

  const InfoOrderCard(
      {Key key,
      @required this.title,
      @required this.value,
      this.isActive = false,
      @required this.onTap,
      this.topColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 85,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1,color: Colors.black),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 6),
                  color: lightGrey.withOpacity(.1),
                  blurRadius: 12)
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    color: topColor ?? active,
                    height: 5,
                  ))
                ],
              ),
              Expanded(child: Container()),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "$title\n",
                        style: TextStyle(
                            fontSize: 16,
                            color: isActive ? active : lightGrey)),
                    TextSpan(
                        text: "$value",
                        style: TextStyle(
                            fontSize: 40, color: isActive ? active : dark)),
                  ])),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
