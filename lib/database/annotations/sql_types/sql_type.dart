import 'package:dart_persistence_api/database/annotations/sql_annotation.dart';

abstract class SQLType extends SQLAnnotation {
  const SQLType();
  toSQL();
  genSQLValue<T>(T value);
}
