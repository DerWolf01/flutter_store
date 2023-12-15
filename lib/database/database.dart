import 'dart:io';

import '../../reflector/reflector.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path;

Directory mainPath = Directory.current;

class SQLiteDatabase {
  SQLiteDatabase._init(this.db);
  final Database db;
  static SQLiteDatabase? _instance;
  static Future<SQLiteDatabase> init() async {
    sqfliteFfiInit();

    var databaseFactory = databaseFactoryFfi;

    var appDocPath = mainPath.path;

    _instance ??= SQLiteDatabase._init(
        await databaseFactory.openDatabase(path.join(appDocPath, 'server.db'),
            options: OpenDatabaseOptions(
              version: 1,
              onCreate: (db, version) {
                print("Server Database created!");
                print(db);
              },
            )));

    return _instance as SQLiteDatabase;
  }

  static SQLiteDatabase? getInstance() {
    return _instance;
  }

  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    return await db.update(table, values,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm);
  }

  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    return await db.insert(table, values,
        nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);
  }

  Future<int> delete(String table,
      {String? where, List<Object?>? whereArgs}) async {
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    return await db.query(table,
        columns: columns,
        distinct: distinct,
        groupBy: groupBy,
        having: having,
        limit: limit,
        offset: offset,
        orderBy: orderBy,
        where: where,
        whereArgs: whereArgs);
  }
}
