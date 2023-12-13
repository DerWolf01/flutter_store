import 'package:dart_persistence_api/database/annotations/constraints/appendable/append_constraint.dart';
import 'package:dart_persistence_api/database/annotations/constraints/constraint.dart';
import 'package:dart_persistence_api/database/annotations/constraints/normal/normal_constraint.dart';
import 'package:dart_persistence_api/database/annotations/sql_annotation.dart';
import 'package:dart_persistence_api/database/annotations/sql_types/sql_type.dart';
import 'package:dart_persistence_api/model/model.dart';

class Field<T extends SQLType?> extends Model {
  Field(this.name, this.type, {List<SQLConstraint>? constraints})
      : constraints = constraints ?? [];
  String name;
  final T type;

  List<SQLConstraint> constraints = [];

  List<NormalSQLConstraint> get normalSQLConstraints =>
      constraints.whereType<NormalSQLConstraint>().toList();

  List<AppendSQLConstraint> get appendableSQLConstraints =>
      constraints.whereType<AppendSQLConstraint>().toList();

  String get schema =>
      "$name ${type?.toSQL()} ${normalSQLConstraints.map((e) => e.toSQL()).join(' ')}";
}
