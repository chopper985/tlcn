import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaymentWidget extends StatelessWidget {
  final String title;
  final String imgUrl;
  final int price;
  final int quanlity;
  final String id;
  final String productId;

  PaymentWidget({
    required this.title,
    required this.imgUrl,
    required this.price,
    required this.quanlity,
    required this.id,
    required this.productId,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 6.0),
                ],
              ),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    '\$$price',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ),
            Spacer(),
            Text(
              'x$quanlity',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
    );
  }
}
