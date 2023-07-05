import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'model.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'Contact.db');
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
    await db.execute(
      "CREATE TABLE phonebook(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL,contact TEXT)",
    );
  }

  Future<Contact> insert(Contact contactModel) async {
    var dbClient = await db;
    await dbClient?.insert("phonebook", contactModel.toMap());
    return contactModel;
  }

  Future<List<Contact>> getDataList() async {
    await db;
    final List<Map<String, Object?>> queryresult =
        await _db!.rawQuery("SELECT  * FROM phonebook");

    return queryresult.map((e) => Contact.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete("phonebook", where: 'id=?', whereArgs: [id]);
  }

  Future<int> update(Contact contactModel) async {
    var dbClient = await db;
    return await dbClient!.update("phonebook", contactModel.toMap(),
        where: 'id=?', whereArgs: [contactModel.id]);
  }
}
