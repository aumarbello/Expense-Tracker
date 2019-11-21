import 'package:expense_tracker/graph/bar_chart.dart';
import 'package:expense_tracker/graph/graph_data.dart';
import 'package:expense_tracker/graph/pie_chart.dart';
import 'package:expense_tracker/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesChart extends StatelessWidget {
  static final routeName = "/categories-chart";
  final colors = {
    "Clothing": Colors.pink,
    "Food": Colors.orange,
    "Transportation": Colors.redAccent,
    "Data": Colors.yellow,
    "Others": Colors.indigo,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
      ),
      body: SingleChildScrollView(
        child: Consumer<TransactionsProvider>(
          builder: (ctx, provider, _) {
            final data = GraphData(
                "Expenses",
                "By Categories",
                provider.totalExpenditure,
                provider.groupedTransactionsByCategories
                    .map((entry) => GraphItem(
                          entry["title"],
                          entry["percent"],
                          color: getCategoryColor(
                            entry["title"],
                          ),
                        ))
                    .toList());
            return Column(
              children: <Widget>[BarChartWidget(data), PieChartWidget(data)],
            );
          },
        ),
      ),
    );
  }

  Color getCategoryColor(String category) {
    return colors[category] ?? Colors.indigo;
  }
}
