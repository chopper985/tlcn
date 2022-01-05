import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/aboutUs.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AboutUsScreen extends StatelessWidget {
  static const routeName = "/aboutus";
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final about = Provider.of<AboutUsInfor>(context).about;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'About us',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(about.image),
                    radius: 40,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(about.name,
                    style: TextStyle(
                        fontSize: 25,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold)),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('v.1.0.0+1',
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.normal)),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Introduce:',
                style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  about.introduce,
                  style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.normal),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Address:',
                style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(8),
                height: 14.h,
                child: ListView.builder(
                    itemBuilder: (context, index) => Text(
                          '${index + 1}. ${about.address[index]}',
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.normal),
                        ),
                    itemCount: about.address.length)),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phone number:',
                    style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    about.phoneNumber,
                    style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Email:',
                  style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold),
                )),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  about.email,
                  style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.normal),
                )),
          ],
        ),
      ),
    );
  }
}
