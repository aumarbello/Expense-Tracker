import 'dart:math';

import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
  }) : super(key: key);

  final Transaction transaction;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;

  @override
  void initState() {
    const colors = [
      Colors.grey,
      Colors.red,
      Colors.purple,
      Colors.green,
      Colors.amber,
    ];

    _bgColor = colors[Random().nextInt(5)];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;
    final provider = Provider.of<TransactionsProvider>(context, listen: false);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                "₦${widget.transaction.amount}",
              ),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          "Date added: ${DateFormat.yMMMEd().format(widget.transaction.date)}\nCategory: ${widget.transaction.category}",
        ),
        trailing: mediaQuerySize.width > 450
            ? FlatButton.icon(
                onPressed: () =>
                    provider.deleteTransaction(widget.transaction.id),
                icon: const Icon(Icons.delete_forever),
                label: const Text("Delete"),
                textColor: Theme.of(context).errorColor,
              )
            : IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () =>
                    provider.deleteTransaction(widget.transaction.id),
                color: Theme.of(context).errorColor,
              ),
      ),
    );
  }
}
