import 'package:expense_tracker/provider/transactions_provider.dart';
import 'package:expense_tracker/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chart extends StatefulWidget {
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  var _showDays = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 4),
                height: constraints.maxHeight * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(_showDays ? "Days" : "Weeks"),
                    Switch(
                      activeColor: Theme.of(context).accentColor,
                      value: _showDays,
                      onChanged: (val) {
                        setState(() {
                          _showDays = val;
                        });
                      },
                    ),
                  ],
                )),
            Consumer<TransactionsProvider>(
              builder: (ctx, provider, _) => Container(
                height: constraints.maxHeight * 0.75,
                child: Card(
                  elevation: 6,
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _showDays
                          ? _buildChartItems(provider.groupedTransactionsByDays)
                          : _buildChartItems(
                              provider.groupedTransactionsByWeeks),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildChartItems(List<Map<String, dynamic>> items) {
    return items.map((item) {
      return Flexible(
        fit: FlexFit.tight,
        child: ChartBar(
          item["title"],
          item["amount"],
          item["percent"],
        ),
      );
    }).toList();
  }
}
