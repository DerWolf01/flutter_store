import 'package:dart_persistence_api/database/annotations/sql_types/sql_type.dart';

class Varchar extends SQLType {
  const Varchar();

  @override
  toSQL() => "VARCHAR";

  @override
  genSQLValue<T>(T value) {
    return "'$value'";
  }
}
