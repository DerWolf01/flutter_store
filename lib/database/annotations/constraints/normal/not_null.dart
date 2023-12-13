import 'package:dart_persistence_api/database/annotations/constraints/constraint.dart';
import 'package:dart_persistence_api/database/annotations/constraints/normal/normal_constraint.dart';

class NotNull extends NormalSQLConstraint {
  const NotNull();
  @override
  String toSQL() => 'NOT NULL';
}
