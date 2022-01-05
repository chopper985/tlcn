import 'package:flutter/material.dart';
import 'package:flutter_shop_application/screens/splash/components/size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          "CHALLENGE",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: Color.fromRGBO(143, 148, 251, 1),
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            text!,
            textAlign: TextAlign.center,
            style: TextStyle(letterSpacing: 1.5),
          ),
        ),
        Spacer(flex: 2),
        Image.asset(
          image!,
          height: getProportionateScreenHeight(265),
          width: getProportionateScreenWidth(235),
        ),
      ],
    );
  }
}
