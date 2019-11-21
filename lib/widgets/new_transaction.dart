import 'package:expense_tracker/provider/transactions_provider.dart';
import 'package:expense_tracker/widgets/adaptive_flat_button.dart';
import 'package:expense_tracker/widgets/transaction_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewTransaction extends StatefulWidget {
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  var _category = "";
  DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                ),
                onSubmitted: (_) => _submit(),
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Amount",
                ),
                onSubmitted: (_) => _submit(),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? "No date chosen!"
                            : "Picked Date: ${DateFormat.yMMMEd().format(_selectedDate)}",
                      ),
                    ),
                    AdaptiveFlatButton("Choose Date", _displayDatePicker),
                  ],
                ),
              ),
              TransactionCategory(_setCategory),
              RaisedButton(
                child: Text(
                  "Add Transaction",
                ),
                onPressed: _submit,
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final amountTitle = double.parse(_amountController.text);

    if (enteredTitle.isEmpty ||
        amountTitle <= 0 ||
        _selectedDate == null ||
        _category.isEmpty) {
      return;
    }

    final provider = Provider.of<TransactionsProvider>(context, listen: false);
    provider.addTransaction(
        title: _titleController.text,
        amount: double.parse(
          _amountController.text,
        ),
        transactionTime: _selectedDate,
        category: _category);

    Navigator.of(context).pop();
  }

  void _displayDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate == null ? DateTime.now() : _selectedDate,
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          _selectedDate = selectedDate;
        });
      }
    });
  }

  void _setCategory(String category) {
    _category = category;
  }
}
