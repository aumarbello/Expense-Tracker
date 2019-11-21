import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';
import 'graph_data.dart';

class PieChartWidget extends StatefulWidget {
  final GraphData data;
  final double centerSpaceRadius;
  final double spaceBetweenSections;

  PieChartWidget(this.data,
      {this.centerSpaceRadius = 40, this.spaceBetweenSections = 0});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartWidget> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: PieChart(
                PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
                      setState(() {
                        if (pieTouchResponse.touchInput is FlLongPressEnd ||
                            pieTouchResponse.touchInput is FlPanEnd) {
                          touchedIndex = -1;
                        } else {
                          touchedIndex = pieTouchResponse.touchedSectionIndex;
                        }
                      });
                    }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: widget.spaceBetweenSections,
                    centerSpaceRadius: widget.centerSpaceRadius,
                    sections: pieChartSections),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.data.items
                  .map((item) => Indicator(
                        color: item.color,
                        text: item.title,
                      ))
                  .toList(),
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> get pieChartSections {
    final mapData = widget.data.items;
    bool isTouched(GraphItem item) {
      return mapData.indexOf(item) == touchedIndex;
    }

    return mapData.where((item) => item.ratio != 0).map((item) {
      final categoryPercentage = item.ratio * 100;
        return PieChartSectionData(
          color: item.color,
          value: categoryPercentage,
          title: "${categoryPercentage.toString()}%",
          radius: isTouched(item) ? 60 : 50,
          titleStyle: TextStyle(
            fontSize: isTouched(item) ? 22 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      },
    ).toList();
  }
}
