import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DataBaseManager {
  DataBaseManager._private();
  static DataBaseManager instace = DataBaseManager._private();
  Database? _db;
  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db!;
  }

  Future _initDb() async {
    Directory docDir = await getApplicationDocumentsDirectory();

    String path = join(docDir.path, "bookMark.db");
    return await openDatabase(path, version: 1,
        onCreate: (database, version) async {
      return await database.execute('''
            CREATE TABLE BookMark (
              id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              surah TEXT NOT NULL,
              ayat INTEGER NOT NULL,
              juz INTEGER NOT NULL,
              via TEXT NOT NULL,
              index_ayat TEXT NOT NULL,
              last_read INTEGER DEFAULT 0
             )

''');
    });
  }

  Future closeDb() async {
    _db = await instace.db;
    _db!.close();
  }
}
