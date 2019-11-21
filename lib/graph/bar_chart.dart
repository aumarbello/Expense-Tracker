import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'graph_data.dart';

class BarChartWidget extends StatefulWidget {
  final GraphData data;
  final double barWidth;

  const BarChartWidget(this.data, {this.barWidth = 22});

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {
  final Color barBackgroundColor = const Color(0xff72d8bf);

  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: const Color(0xff81e5cd),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.data.title,
              ),
              SizedBox(
                height: 8,
              ),
              if (widget.data.subtitle != null)
                Text(
                  widget.data.subtitle,
                  style: TextStyle(fontSize: 18),
                ),
              SizedBox(
                height: 20,
              ),
              AspectRatio(
                aspectRatio: 1,
                child: BarChart(
                  barChartData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build individual bars
  BarChartGroupData makeGroupData(
    int index,
    double percentage,
    bool isTouched,
  ) {
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          y: isTouched ? percentage + 1 : percentage,
          //todo Make each bar color dynamic?
          color: isTouched ? Colors.yellow : Colors.white,
          width: widget.barWidth,
          isRound: true,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            //Total bar value
            y: widget.data.totalExpenditure,
            color: barBackgroundColor,
          ),
        ),
      ],
    );
  }

  BarChartData get barChartData {
    return BarChartData(
      barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (_, groupIndex, rod, rodIndex) => createToolTip(
                  groupIndex)), // Toast to be displayed when bar is long pressed
          touchCallback: (barTouchResponse) {
            setState(() {
              if (barTouchResponse.spot != null &&
                  barTouchResponse.touchInput is! FlPanEnd &&
                  barTouchResponse.touchInput is! FlLongPressEnd) {
                touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
              } else {
                touchedIndex = -1;
              }
            });
          }), //Bar LongPressed click listener
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
            showTitles: true,
            textStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            getTitles: (value) => createShortTitle(value.toInt())
            ),
        leftTitles: const SideTitles(
          showTitles: false,
        ),
      ), //Bar information (top, bottom, left and right)
      borderData: FlBorderData(
        show: false,
      ), //Bar area border
      barGroups: widget.data.items.map((item) {
        int index(GraphItem item) {
          return widget.data.items.indexOf(item);
        }

        bool isTouched(GraphItem item) {
          return index(item) == touchedIndex;
        }

        return makeGroupData(index(item), (item.ratio * widget.data.totalExpenditure), isTouched(item));
      }).toList(), // Individual bars, index, percentage and touch state
    );
  }

  BarTooltipItem createToolTip(int index) {
    final item = widget.data.items[index];
    return BarTooltipItem("${item.title} \n ${(item.ratio * widget.data.totalExpenditure).toString()}",
        TextStyle(color: Colors.yellow));
  }

  String createShortTitle(int index) {
    return widget.data.items[index].title.toString().substring(0, 1);
  }
}
