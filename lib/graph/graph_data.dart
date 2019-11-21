import 'package:flutter/material.dart';

class GraphData {
  final String title;
  final String subtitle;
  final double totalExpenditure;
  final List<GraphItem> items;

  GraphData(this.title, this.subtitle, this.totalExpenditure, this.items);
}

class GraphItem {
  final String title;
  final double ratio;
  final Color color;

  GraphItem(this.title, this.ratio, {this.color = Colors.white});
}