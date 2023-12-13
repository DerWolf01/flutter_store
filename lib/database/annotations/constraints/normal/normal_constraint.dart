import 'package:dart_persistence_api/database/annotations/constraints/constraint.dart';

abstract class NormalSQLConstraint extends SQLConstraint {
  const NormalSQLConstraint();
  String toSQL();
}
