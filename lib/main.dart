import 'dart:io';

import 'package:expense_tracker/provider/transactions_provider.dart';
import 'package:expense_tracker/widgets/categories_chart.dart';
import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:expense_tracker/widgets/transactions_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: TransactionsProvider(),
      child: MaterialApp(
        title: "Personal Expenses",
        theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.deepOrange,
            fontFamily: "Gt-Walsheim",
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  button: TextStyle(color: Colors.white),
                ),
            appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      title: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            )),
        routes: {
          CategoriesChart.routeName: (_) => CategoriesChart()
        },
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(
              "Personal Expenses",
            ),
            trailing: Row(
              children: <Widget>[
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => startAddNewTransaction(context),
                ),
                GestureDetector(
                  child: const Icon(Icons.insert_chart),
                  onTap: () => Navigator.of(context).pushNamed(CategoriesChart.routeName),
                ),
              ],
            ),
          )
        : AppBar(
            title: const Text(
              "Personal Expenses",
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => startAddNewTransaction(context),
              ),
              IconButton(
                icon: const Icon(Icons.insert_chart),
                onPressed: () => Navigator.of(context).pushNamed(CategoriesChart.routeName),
              ),
            ],
          );

    final mediaQuery = MediaQuery.of(context);
    final mediaQuerySize = mediaQuery.size;
    final transactionsWidget = Container(
        child: TransactionsList(),
        height: (mediaQuerySize.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7);

    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final body = SafeArea(
      child: FutureBuilder(
        future: Provider.of<TransactionsProvider>(context, listen: false)
            .fetchAndSaveTransactions(),
        builder: (_, state) => state.data == true
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    if (!isPortrait)
                      ..._buildLandscapeContent(
                        mediaQuery,
                        appBar,
                        transactionsWidget,
                      ),
                    if (isPortrait)
                      ..._buildPortraitContent(
                        mediaQuery,
                        appBar,
                        transactionsWidget,
                      ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: body,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => startAddNewTransaction(context),
                  ),
          );
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget transactions) {
    return [
      Container(
        child: Chart(),
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
      ),
      transactions,
    ];
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar, Widget txWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Show Chart",
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              child: Chart(),
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.75,
            )
          : txWidget
    ];
  }

  void startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewTransaction();
        });
  }
}
