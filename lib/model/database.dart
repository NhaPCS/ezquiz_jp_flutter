import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'category.dart';
import 'dart:async';
import 'dart:io';

final String tableCategory = 'category';
final String _id = 'id';
final String _title = 'title';
final String _levelId = 'levelId';

class DBProvider {
  static final String DATABASE_NAME = "ezquiz_jp.db";

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
    String path = join(documentsDirectory.path, DATABASE_NAME);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableCategory ( 
  ${_id} text primary key, 
  $_title text not null,
  $_levelId integer not null)
''');
    });
  }

  void insert(Category category) async {
    final db = await database;
    await db.insert(tableCategory, category.toMap());
  }

  void insertList(List<Category> categories) async {
    final db = await database;
    categories.forEach((Category category) async {
      await db.insert(tableCategory, category.toMap());
    });
  }

  Future<Category> getCategory(String id) async {
    final db = await database;
    List<Map> maps = await db.query(tableCategory,
        columns: [_id, _title, _levelId], where: '$_id = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return Category.fromMap(maps.first);
    } else return null;
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
        columns: [_levelId],
        groupBy: _levelId,
        orderBy: _levelId);
    List<String> results = List();
    print("MAPPP ${maps}");
    return results;
  }

  void delete(String id) async {
    final db = await database;
    await db
        .delete(tableCategory, where: '$_id = ?', whereArgs: [id]);
  }

  void update(Category todo) async {
    final db = await database;
    await db.update(tableCategory, todo.toMap(),
        where: '$_id = ?', whereArgs: [todo.id]);
  }

  void close() async {
    final db = await database;
    await db.close();
  }
}
