import 'package:expense_tracker/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionCategory extends StatefulWidget {
  final void Function(String) setCategory;

  TransactionCategory(this.setCategory);

  @override
  _TransactionCategoryState createState() => _TransactionCategoryState();
}

class _TransactionCategoryState extends State<TransactionCategory> {
  var _categories = [];
  var _selectedCategory = "Clothing";

  @override
  Widget build(BuildContext context) {
    _categories = Provider.of<TransactionsProvider>(context, listen: false).categories;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Category"),
        DropdownButton(
          hint: Text("Select category"),
            underline: Container(),
            value: _selectedCategory,
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                widget.setCategory(value);
                _selectedCategory = value;
              });
            })
      ],
    );
  }
}
