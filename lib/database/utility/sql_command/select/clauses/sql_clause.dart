import 'package:dart_persistence_api/utility/dpi_utility.dart';

abstract class SQLClause extends DPIUtility {
  SQLClause();
  String toSQL();
}
