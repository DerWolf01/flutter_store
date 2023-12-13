import 'package:dart_persistence_api/model/dao/annotations/sql_type.dart';

class Integer extends SQLType {
  const Integer();
  @override
  toSQL() => "INTEGER";

  @override
  genSQLValue<T>(T value) {
    return value.toString();
  }
}
