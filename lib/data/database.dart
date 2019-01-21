import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ezquiz_flutter/model/category.dart';
import 'package:ezquiz_flutter/model/coin.dart';

final String tableCategory = 'category';
final String tableCoin = 'coin';

final String _id = 'id';
final String _title = 'title';
final String _levelId = 'levelId';
final String _cost = 'cost';
final String _coin = 'coin';

class DBProvider {
  static final String databaseName = "ezquiz_jp.db";

  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'create table IF NOT EXISTS $tableCategory ($_id text primary key,$_title text not null,$_levelId integer not null)');
      await db.execute('create table IF NOT EXISTS $tableCoin ($_id text primary key,$_cost text not null,$_coin integer not null)');
    }, onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    return Future.value();
  }

  void insert(Category category) async {
    final db = await database;
    try {
      await db.insert(tableCategory, category.toMap());
    } on DatabaseException {
      await db.update(tableCategory, category.toMap());
    }
  }

  Future<Category> getCategory(String id) async {
    final db = await database;
    List<Map> maps = await db.query(tableCategory,
        columns: [_id, _title, _levelId], where: '$_id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return Category.fromMap(maps.first);
    } else
      return null;
  }

  Future<List<Category>> getCategoriesByLevel(String levelId) async {
    final db = await database;
    List<Map> maps = await db.query(tableCategory,
        columns: [_id, _title, _levelId],
        where: '$_levelId = ?',
        whereArgs: [levelId]);
    List<Category> results = List();
    if (maps.length > 0) {
      maps.forEach((map) {
        results.add(Category.fromMap(map));
      });
    }
    return results;
  }

  Future<List<String>> getLevels() async {
    final db = await database;
    List<Map> maps = await db.query(tableCategory,
        columns: [_levelId], groupBy: _levelId, orderBy: _levelId);
    List<String> results = List();
    maps.forEach((Map map) {
      results.add(map[_levelId]);
    });
    print("MAPPP $results");
    return results;
  }

  void delete(String id) async {
    final db = await database;
    await db.delete(tableCategory, where: '$_id = ?', whereArgs: [id]);
  }

  void update(Category todo) async {
    final db = await database;
    await db.update(tableCategory, todo.toMap(),
        where: '$_id = ?', whereArgs: [todo.id]);
  }

  void insertCoin(Coin coin) async {
    final db = await database;
    try {
      await db.insert(tableCoin, coin.toMap());
    } on DatabaseException {
      await db.update(tableCoin, coin.toMap());
    }
  }

  Future<List<Coin>> getListCoins() async {
    final db = await database;
    List<Map> maps = await db.query(tableCoin, columns: [_id, _coin, _cost]);
    List<Coin> results = List();
    if (maps.length > 0) {
      maps.forEach((map) {
        results.add(Coin.fromMap(map));
      });
    }
    return results;
  }

  void close() async {
    final db = await database;
    await db.close();
  }
}
