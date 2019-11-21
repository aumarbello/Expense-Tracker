import 'package:expense_tracker/provider/transactions_provider.dart';
import 'package:expense_tracker/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsList extends StatefulWidget {
  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  var _filter = TransactionFilter.ALL;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionsProvider>(context);

    return provider.items.isEmpty
        ? LayoutBuilder(
            builder: (_, constraints) {
              return Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "No transactions added yet!",
                      style: Theme.of(context).textTheme.title,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.7,
                      child: Image.asset(
                        "assets/images/waiting.png",
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () => _showFilterDialog(),
                  )
                ],
              ),
              ...provider.getFilteredTransactions(_filter).map((tx) {
                return TransactionItem(key: ValueKey(tx.id), transaction: tx);
              }).toList()
            ],
          );
  }

  void _showFilterDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Select filter"),
              content: Container(
                height: 180,
                child: Column(
                  children: TransactionFilter.values
                      .map((filter) => RadioListTile(
                            title: Text(formatEnum(filter)),
                            value: filter,
                            groupValue: _filter,
                            onChanged: (filter) => _updateFilter(filter),
                          ))
                      .toList(),
                ),
              ),
            ));
  }

  void _updateFilter(TransactionFilter filter) {
    setState(() {
      _filter = TransactionFilter.values.firstWhere((item) => item == filter);
      Navigator.of(context).pop();
    });
  }

  String formatEnum(TransactionFilter filter) {
    return filter.toString().replaceAll("TransactionFilter.", "");
  }
}
