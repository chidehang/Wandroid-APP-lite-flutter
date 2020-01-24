import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wandroid_app_flutter/model/bean/search_key_bean.dart';
import 'package:wandroid_app_flutter/model/db/database_manager.dart';

class SearchKeyDao {

  static const String SEARCH_KEY_TABLE = "searchkey_table";

  static FutureOr<void> createTable(Database db, int version) async {
    debugPrint("createTable");
    return await db.execute("CREATE TABLE $SEARCH_KEY_TABLE(name TEXT PRIMARY KEY, id INTEGER, link TEXT, visible INTEGER)");
  }

  insert(SearchKeyBean bean) async {
    final db = await DatabaseManager.getInstance().getDatabase();
    await db.insert(SEARCH_KEY_TABLE, bean.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SearchKeyBean>> queryAll() async {
    final db = await DatabaseManager.getInstance().getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(SEARCH_KEY_TABLE);
    return List.generate(maps.length, (i) {
      return SearchKeyBean.fromMap(maps[i]);
    });
  }

  deleteAll() async {
    final db = await DatabaseManager.getInstance().getDatabase();
    await db.delete(SEARCH_KEY_TABLE);
  }
}