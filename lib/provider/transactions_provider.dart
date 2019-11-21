import 'package:expense_tracker/helper/DBHelper.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class TransactionsProvider with ChangeNotifier {
  final tableName = "transactions";

  final List<Transaction> _items = [];
  final categories = ["Clothing", "Food", "Transportation", "Data", "Others"];

  List<Transaction> get items {
    return [..._items];
  }

  List<Transaction> get _currentWeekTransactions {
    return _items.where((item) {
      return item.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  List<Transaction> get _currentMonthTransactions {
    final baseDate = DateTime.now().subtract(Duration(days: 30));
    return _items.where((item) => item.date.isAfter(baseDate)).toList();
  }

  List<Map<String, Object>> get groupedTransactionsByDays {
    final items = _currentWeekTransactions;

    var weekTotal = items.fold(0.0, (sum, item) {
      return sum + item.amount;
    });

    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (int i = 0; i < items.length; i++) {
        final currentTransaction = items[i];
        if (currentTransaction.date.day == weekDay.day &&
            currentTransaction.date.month == weekDay.month &&
            currentTransaction.date.year == weekDay.year) {
          totalSum += currentTransaction.amount;
        }
      }

      final percent = totalSum / weekTotal;
      return {
        "title": DateFormat.E().format(weekDay).substring(
              0,
              1,
            ),
        "amount": totalSum,
        "percent": percent.isNaN ? 0.0 : percent
      };
    }).reversed.toList();
  }

  List<Map<String, Object>> get groupedTransactionsByWeeks {
    final items = _currentMonthTransactions;

    var monthTotal = items.fold(0.0, (sum, item) {
      return sum + item.amount;
    });

    return List.generate(4, (index) {
      final weekDate = DateTime.now().subtract(Duration(days: ++index * 7));
      var weekTotal = 0.0;

      for (int i = 0; i < items.length; i++) {
        final currentTransaction = items[i];
        if (currentTransaction.date.difference(weekDate).inDays < 7) {
          weekTotal += currentTransaction.amount;
        }
      }

      final percent = weekTotal / monthTotal;
      return {
        "title": "Week ${5 - index}",
        "amount": weekTotal,
        "percent": percent.isNaN ? 0.0 : percent
      };
    }).reversed.toList();
  }

  List<Map<String, Object>> get groupedTransactionsByCategories {
    var total = _items.fold(0.0, (sum, item) {
      return sum + item.amount;
    });

    return List.generate(categories.length, (index) {
      var categoryTotal = 0.0;

      for (int i = 0; i < _items.length; i++) {
        final currentTransaction = _items[i];
        if (currentTransaction.category == categories[index]) {
          categoryTotal += currentTransaction.amount;
        }
      }

      final percent = categoryTotal / total;
      return {
        "title": categories[index],
        "amount": categoryTotal,
        "percent": percent.isNaN ? 0.0 : percent
      };
    }).reversed.toList();
  }

  double get totalExpenditure {
    return _items.fold(0.0, (sum, item) {
      return sum + item.amount;
    });
  }

  List<Transaction> getFilteredTransactions(TransactionFilter filter) {
    switch (filter) {
      case TransactionFilter.ALL:
        return [..._items];
      case TransactionFilter.MONTH:
        return _currentMonthTransactions;
      case TransactionFilter.WEEK:
        final baseDate = DateTime.now().subtract(Duration(days: 7));
        return _items.where((item) => item.date.isAfter(baseDate)).toList();
      default:
        return [..._items];
    }
  }

  Future<void> addTransaction({
    String title,
    DateTime transactionTime,
    double amount,
    String category,
  }) async {
    final newTransaction = Transaction(
      id: DateTime.now().toString(),
      title: title,
      date: transactionTime,
      amount: amount,
      category: category,
    );

    final data = {
      "title": newTransaction.title,
      "date": newTransaction.date.toIso8601String(),
      "amount": newTransaction.amount,
      "category": newTransaction.category,
      "id": newTransaction.id
    };

    await DBHelper.saveTransaction(data, tableName);

    _items.add(newTransaction);
    notifyListeners();
  }

  Future<bool> fetchAndSaveTransactions() async {
    _items.clear();

    final data = await DBHelper.getTransactions(tableName);
    data.forEach(
      (item) => _items.add(
        Transaction(
            id: item["id"],
            title: item["title"],
            amount: item["amount"],
            date: DateTime.parse(item["date"]),
            category: item["category"]),
      ),
    );

    notifyListeners();
    return true;
  }

  void deleteTransaction(String id) async {
    await DBHelper.deleteTransaction(tableName, id);

    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}

enum TransactionFilter { ALL, MONTH, WEEK }
