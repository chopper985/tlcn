import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/local.dart';
import 'package:provider/provider.dart';

class MethobPaymentWidget extends StatelessWidget {
  final int index;
  final String image;
  final String title;
  final String subtitle;
  const MethobPaymentWidget(
      {Key? key,
      required this.image,
      required this.title,
      required this.subtitle,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = Provider.of<Local>(context);
    return Card(
      child: ListTile(
          onTap: () {
            local.changeSelect(index);
          },
          leading: CircleAvatar(
            backgroundImage: AssetImage(image),
            radius: 25,
          ),
          title: Text(title),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 11),
          ),
          trailing: Icon(Icons.check_circle_outline,
              color: index != local.checkSelectPayment
                  ? Colors.grey
                  : Colors.green)),
    );
  }
}
