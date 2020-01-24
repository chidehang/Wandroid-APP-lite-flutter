import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wandroid_app_flutter/model/db/search_key_dao.dart';

/// 数据库管理
class DatabaseManager {

  DatabaseManager._();

  static DatabaseManager _instance;

  static DatabaseManager getInstance() {
    if (_instance == null) {
      _instance = DatabaseManager._();
    }
    return _instance;
  }

  factory DatabaseManager() => getInstance();

  static const String DATABASE_NAME = "wandroid_database.db";
  static const int DATABASE_VERSION = 1;

  Database db;

  Future<Database> getDatabase() async {
    if (db == null) {
      db = await _openAppDatabase();
    }
    return db;
  }

  Future<Database> _openAppDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_NAME),
      version: DATABASE_VERSION,
      onCreate: (db, version) {
        SearchKeyDao.createTable(db, version);
      }
    );
  }
}