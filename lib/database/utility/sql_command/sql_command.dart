import 'package:dart_persistence_api/database/utility/database_utility.dart';
import 'package:dart_persistence_api/model/dao/annotations/sql_type.dart';
import 'package:dart_persistence_api/model/dao/dao.dart';
import 'package:dart_persistence_api/model/reflector/model_class_mirror.dart';

abstract class SQLCommand extends DatabaseUtility {
  const SQLCommand(super.db);

  String get table;

  // Map<String, dynamic> get instanceTableFieldsMap;
  Future execute();
}

abstract class SQLCommandUsingType extends SQLCommand {
  const SQLCommandUsingType(super.db, this.type, {this.tableName});
  final Type type;

  final String? tableName;

  ModelClassMirror get daoMirror => ModelClassMirror(type);

  @override
  String get table => tableName ?? daoMirror.snakeCaseName;

  // Map<String, dynamic> get instanceTableFieldsMap {
  //   return dao.getFieldsBySQLType<SQLType>().map(
  //       (key, value) => MapEntry(key, value.type.genSQLValue(value.value)));
  // }
}

abstract class SQLCommandUsingInstance extends SQLCommand {
  const SQLCommandUsingInstance(super.db, this.dao);
  final DAO dao;

  @override
  String get table => dao.table;

  Map<String, dynamic> get instanceTableFieldsMap {
    return dao.getFieldsBySQLType<SQLType>().map(
        (key, value) => MapEntry(key, value.type.genSQLValue(value.value)));
  }
}
