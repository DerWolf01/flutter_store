import 'package:dart_persistence_api/database/annotations/sql_types/sql_type.dart';
import 'package:dart_persistence_api/database/utility/sql_command/select/clauses/sql_clause.dart';

import 'package:dart_persistence_api/model/dao/instance_field.dart';

class Wheres extends SQLClause {
  Wheres(this.wheres);
  List<Where> wheres = [];

  @override
  String toSQL() {
    return 'WHERE ${wheres.map((e) => e.toSQL()).join(' AND ')}';
  }

  String get pseudoWheres => wheres.map((e) => '${e.fieldName} = ?').join(', ');
  List<dynamic> get whereValues => wheres.map((e) => e.value).toList();
}

class Where extends SQLClause {
  Where(this.fieldName, this.whereValue);
  final String fieldName;
  final InstanceField<SQLType> whereValue;

  @override
  String toSQL() =>
      "${toSnakeCase(fieldName)} = ${whereValue.type.genSQLValue(whereValue.value)} ";

  dynamic get value => whereValue.type.genSQLValue(whereValue.value);
  String get sqlFieldName => toSnakeCase(fieldName);
}
