import 'package:dart_persistence_api/database/utility/sql_command/select/clauses/where.dart';
import 'package:dart_persistence_api/database/utility/sql_command/sql_command.dart';

class Delete extends SQLCommandUsingInstance {
  Delete(super.db, super.dao, this.wheres);

  Wheres wheres;
  @override
  Future<int> execute() async {
    return await db.delete(table,
        where: wheres.pseudoWheres, whereArgs: wheres.whereValues);
  }
}
