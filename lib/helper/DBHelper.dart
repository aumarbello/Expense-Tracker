import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<int> saveTransaction(Map<String, dynamic> data, String tableName) async {
    final db = await _getDatabase(tableName);
    return db.insert(tableName, data);
  }

  static Future<Database> _getDatabase(String tableName) async {
    final dbPath = path.join(await getDatabasesPath(), "expense_tracker.db");

    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute("CREATE TABLE $tableName (id TEXT PRIMARY KEY, title TEXT, amount REAL, date TEXT, category TEXT)");
    });
  }

  static Future<List<Map<String, dynamic>>> getTransactions(String tableName) async {
    final db = await _getDatabase(tableName);

    return db.query(tableName);
  }

  static Future<int> deleteTransaction(String tableName, String id) async {
    final db = await _getDatabase(tableName);

    return db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }
}