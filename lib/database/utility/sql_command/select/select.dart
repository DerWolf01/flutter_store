import 'package:dart_persistence_api/database/annotations/sql_types/sql_type.dart';
import 'package:dart_persistence_api/database/utility/sql_command/select/clauses/select_options.dart';
import 'package:dart_persistence_api/database/utility/sql_command/sql_command.dart';


class Select extends SQLCommandUsingType {
  Select(super.db, super.dao, {this.selectOptions, super.tableName});

  final SelectOptions? selectOptions;

  List<String> get fieldsToSelect => selectOptions?.columns?.isNotEmpty == true
      ? selectOptions!.columns!
      : daoMirror
          .attributesByAnnotation<SQLType>(daoMirror.classMirror)
          .keys
          .toList();

  @override
  Future<List<Map<String, Object?>>> execute() async {
    var query =
        "SELECT $fieldsToSelect FROM $table where:${selectOptions?.wheres?.pseudoWheres} args:${selectOptions?.wheres?.whereValues}";
    print(query);
    return await (db).query(table,
        columns: fieldsToSelect,
        where: selectOptions?.wheres?.pseudoWheres,
        whereArgs: selectOptions?.wheres?.whereValues);
  }
}
