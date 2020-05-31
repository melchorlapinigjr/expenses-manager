import 'dart:async' show Future;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' show Database, openDatabase;
import 'dart:io' as io;

import 'package:dailybudgetapp/models/transaction_model.dart';

class DatabaseHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "budget_manager.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: onCreate);
    return ourDb;
  }

  void onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE transactionT(id INTEGER PRIMARY KEY AUTOINCREMENT,transaction_name TEXT,amount DOUBLE,type TEXT)");
    print("table Transaction created.");
  }

  Future<List<Transactions>> getTransaction() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query("transactionT",
        columns: ['id', 'transaction_name', 'amount', 'type']);
    List<Transactions> transactions = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        transactions.add(Transactions.fromMap(maps[i]));
      }
    }
    return transactions;
  }

  Future<int> saveTransaction(Transactions transaction) async {
    int response;
    try {
      var dbClient = await db;
      response = await dbClient.insert("transactionT", transaction.toMap());
    } catch (e) {
      print(e);
    }
    return response;
  }

  Future<int> deleteTransaction(int transaction) async {
    int response;
    try {
      var dbClient = await db;
      response = await dbClient.delete(
        "transactionT",
        where: 'id = ?',
        whereArgs: [transaction],
      );
    } catch (e) {
      print(e);
    } 
    return response;
  }

  Future<int> updateTransaction(Transactions transaction) async {
    var dbClient = await db;
    return await dbClient.update("transactionT", transaction.toMap(),
        where: 'id = ?', whereArgs: [transaction.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
