import 'package:dart_persistence_api/database/utility/sql_command/select/clauses/where.dart';

class SelectOptions {
  const SelectOptions(
      {this.distinct,
      this.columns,
      this.wheres,
      this.groupBy,
      this.having,
      this.orderBy,
      this.limit,
      this.offset});
  final bool? distinct;
  final List<String>? columns;
  final Wheres? wheres;
  final String? groupBy;
  final String? having;
  final String? orderBy;
  final int? limit;
  final int? offset;
}
