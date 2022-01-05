/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tl_web_admin/constants/style.dart';
import 'package:tl_web_admin/providers/order.dart';

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData(BuildContext context) {
    return new SimpleBarChart(
      _createSampleData(context),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData(
      BuildContext context) {
    var now = DateTime.now();
    final orders = Provider.of<Order>(context);
    final data = [
      new OrdinalSales(
          'Today', int.parse(orders.totalMoneyByDay(0).toString())),
      new OrdinalSales(
          'Yesterday', int.parse(orders.totalMoneyByDay(1).toString())),
      new OrdinalSales(
          DateFormat('dd-MM')
              .format(DateTime(now.year, now.month, now.day - 2)),
          int.parse(orders.totalMoneyByDay(2).toString())),
      new OrdinalSales(
          DateFormat('dd-MM')
              .format(DateTime(now.year, now.month, now.day - 3)),
          int.parse(orders.totalMoneyByDay(3).toString())),
      new OrdinalSales(
          DateFormat('dd-MM')
              .format(DateTime(now.year, now.month, now.day - 4)),
          int.parse(orders.totalMoneyByDay(4).toString())),
      new OrdinalSales(
          DateFormat('dd-MM')
              .format(DateTime(now.year, now.month, now.day - 5)),
          int.parse(orders.totalMoneyByDay(5).toString())),
      new OrdinalSales(
          DateFormat('dd-MM')
              .format(DateTime(now.year, now.month, now.day - 6)),
          int.parse(orders.totalMoneyByDay(6).toString())),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (OrdinalSales sales, __) {
          switch (sales.year) {
            case 'Today':
              {
                return charts.ColorUtil.fromDartColor(Colors.red);
              }

            case "Yesterday":
              {
                return charts.ColorUtil.fromDartColor(Colors.green);
              }
            default:
              {
                return charts.ColorUtil.fromDartColor(Colors.blue);
              }
          }
        },
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data.reversed.toList(),
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
