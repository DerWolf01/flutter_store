import 'package:dart_persistence_api/database/annotations/constraints/normal/normal_constraint.dart';
import 'package:dart_persistence_api/database/utility/sql_command/sql_command.dart';
import 'package:dart_persistence_api/model/dao/annotations/sql_type.dart';

class Create extends SQLCommandUsingInstance {
  Create(super.db, super.dao, {this.fields});

  final String? fields;
  String get fieldsString {
    if (fields != null) {
      return fields!;
    }
    return dao
        .getFieldsBySQLType<SQLType>()
        .map((key, value) {
          return MapEntry(
              key,
              "$key ${value.type.toSQL()} ${value.constraints.whereType<NormalSQLConstraint>().map((e) {
                return e.toSQL();
              }).join(' ')}");
        })
        .values
        .join(', ');
  }

  String get primaryKeyConstraints => dao.primaryKeyConstraints.isNotEmpty
      ? "PRIMARY KEY( ${dao.primaryKeyFields.map((e) => toSnakeCase(e.name)).join(', ')} )"
      : '';

  // String get foreingKeyConstraints =>
  //     " ${dao.getFieldsBySQLType<SQLType>().entries.where((entry) => entry.value.constraints.whereType<ForeignKey>().firstOrNull != null).map((value) {
  //       return "{value.type.getConnectionEntity().to}";
  //     })}";
  @override
  execute() async {
    print(
        "CREATE TABLE IF NOT EXISTS $table ( $fieldsString,  $primaryKeyConstraints )");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $table ( $fieldsString,  $primaryKeyConstraints )");
  }
}
