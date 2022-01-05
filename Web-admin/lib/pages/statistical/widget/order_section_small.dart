import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:tl_web_admin/constants/style.dart';
import 'package:tl_web_admin/providers/order.dart';

class OrderSectionSmall extends StatefulWidget {
  OrderSectionSmall({Key key}) : super(key: key);

  @override
  _OrderSectionSmallState createState() => _OrderSectionSmallState();
}

class _OrderSectionSmallState extends State<OrderSectionSmall> {
  List<GDPData> _chartData;
  List<GDPData> _chartData02;
  TooltipBehavior _tooltipBehavior;
  String year = DateFormat('yyyy').format(DateTime(DateTime.now().year));

  @override
  void initState() {
    _chartData = getChartData(context);
    _chartData02 = getChartData02(context);
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 6),
                    color: lightGrey.withOpacity(.1),
                    blurRadius: 12)
              ],
              border: Border.all(color: lightGrey, width: .5),
            ),
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 600,
            width: 300,
            child: _chartData.isEmpty
                ? Center(
                    child: Text(
                      'There are currently no orders placed for $year.',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : SfCircularChart(
                    title: ChartTitle(
                        text: 'Number of orders by month in ${year}! '),
                    legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap),
                    tooltipBehavior: _tooltipBehavior,
                    series: <CircularSeries>[
                      PieSeries<GDPData, String>(
                          dataSource: _chartData,
                          xValueMapper: (GDPData data, _) => data.continent,
                          yValueMapper: (GDPData data, _) => data.gdp,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          enableTooltip: true)
                    ],
                  ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 6),
                    color: lightGrey.withOpacity(.1),
                    blurRadius: 12)
              ],
              border: Border.all(color: lightGrey, width: .5),
            ),
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 600,
            width: 300,
            child: _chartData02.isEmpty
                ? Center(
                    child: Text(
                      'No products ordered for $year.',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : SfCircularChart(
                    title: ChartTitle(
                        text:
                            'Number of products ordered by month in ${year}! '),
                    legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap),
                    tooltipBehavior: _tooltipBehavior,
                    series: <CircularSeries>[
                      PieSeries<GDPData, String>(
                          dataSource: _chartData02,
                          xValueMapper: (GDPData data, _) => data.continent,
                          yValueMapper: (GDPData data, _) => data.gdp,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          enableTooltip: true)
                    ],
                  ),
          ),
        ],
      ),
    ));
  }

  List<GDPData> getChartData02(BuildContext context) {
    final order = Provider.of<Order>(context, listen: false);

    final List<GDPData> chartData02 = [
      if (order.countProductInMonth(1) != 0)
        GDPData('January', order.countProductInMonth(1)),
      if (order.countProductInMonth(2) != 0)
        GDPData('February', order.countProductInMonth(2)),
      if (order.countProductInMonth(3) != 0)
        GDPData('March', order.countProductInMonth(3)),
      if (order.countProductInMonth(4) != 0)
        GDPData('April', order.countProductInMonth(4)),
      if (order.countProductInMonth(5) != 0)
        GDPData('May', order.countProductInMonth(5)),
      if (order.countProductInMonth(6) != 0)
        GDPData('June', order.countProductInMonth(6)),
      if (order.countProductInMonth(7) != 0)
        GDPData('July', order.countProductInMonth(7)),
      if (order.countProductInMonth(8) != 0)
        GDPData('August', order.countProductInMonth(8)),
      if (order.countProductInMonth(9) != 0)
        GDPData('Septemple', order.countProductInMonth(9)),
      if (order.countProductInMonth(10) != 0)
        GDPData('October', order.countProductInMonth(10)),
      if (order.countProductInMonth(11) != 0)
        GDPData('November', order.countProductInMonth(11)),
      if (order.countProductInMonth(12) != 0)
        GDPData('December', order.countProductInMonth(12)),
    ];
    return chartData02;
  }

  List<GDPData> getChartData(BuildContext context) {
    final order = Provider.of<Order>(context, listen: false);

    final List<GDPData> chartData = [
      if (order.countOrderByMonth(1) != 0)
        GDPData('January', order.countOrderByMonth(1)),
      if (order.countOrderByMonth(2) != 0)
        GDPData('February', order.countOrderByMonth(2)),
      if (order.countOrderByMonth(3) != 0)
        GDPData('March', order.countOrderByMonth(3)),
      if (order.countOrderByMonth(4) != 0)
        GDPData('April', order.countOrderByMonth(4)),
      if (order.countOrderByMonth(5) != 0)
        GDPData('May', order.countOrderByMonth(5)),
      if (order.countOrderByMonth(6) != 0)
        GDPData('June', order.countOrderByMonth(6)),
      if (order.countOrderByMonth(7) != 0)
        GDPData('July', order.countOrderByMonth(7)),
      if (order.countOrderByMonth(8) != 0)
        GDPData('August', order.countOrderByMonth(8)),
      if (order.countOrderByMonth(9) != 0)
        GDPData('Septemple', order.countOrderByMonth(9)),
      if (order.countOrderByMonth(10) != 0)
        GDPData('October', order.countOrderByMonth(10)),
      if (order.countOrderByMonth(11) != 0)
        GDPData('November', order.countOrderByMonth(11)),
      if (order.countOrderByMonth(12) != 0)
        GDPData('December', order.countOrderByMonth(12)),
    ];
    return chartData;
  }
}

class GDPData {
  GDPData(this.continent, this.gdp);
  final String continent;
  final int gdp;
}
