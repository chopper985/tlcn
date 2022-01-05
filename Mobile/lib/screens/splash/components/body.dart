import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/auth.dart';
import 'package:flutter_shop_application/screens/splash/components/size_config.dart';
import 'package:flutter_shop_application/screens/splash/components/splashContent.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Challenge, Let’s shop!",
      "image": "assets/images/splash_1.png"
    },
    {
      "text": "We help people conect with store \naround Ho Chi Minh City",
      "image": "assets/images/splash_2.png"
    },
    {
      "text": "We show the easy way to shop. \nJust stay at home with us",
      "image": "assets/images/splash_3.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 2),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        child: Text('Continue'),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/products-overview');
                        },
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(fontSize: 16),
                          backgroundColor: Color.fromRGBO(143, 148, 251, 1),
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Provider.of<Auth>(context, listen: false).changeSplash();
                      },
                      child: Text('Go to Login or Sign Up'),
                      textColor: Color.fromRGBO(143, 148, 251, 1),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 8),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index
            ? Color.fromRGBO(143, 148, 251, 1)
            : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
