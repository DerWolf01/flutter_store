import 'package:dart_persistence_api/database/annotations/sql_types/sql_type.dart';
import 'package:dart_persistence_api/database/utility/database_utility.dart';
import 'package:dart_persistence_api/database/utility/sql_command/create.dart';

import 'package:dart_persistence_api/model/dao/dao.dart';

class Insert<T extends DAO> extends DatabaseUtility {
  Insert(super.db, this.dao);
  final T dao;

  String get table =>
      toSnakeCase(dao.modelClassMirror.simpleName.replaceAll('DAO', ''));

  Map<String, dynamic> get instanceTableFieldsMap {
    var res = dao.getFieldsBySQLType<SQLType>().map(
        (key, value) => MapEntry(key, value.type.genSQLValue(value.value)));

    res.removeWhere((key, value) => key == "id");
    return res;
  }

  Future<T> execute() async {
    print("creating...");

    await Create(db, dao).execute();
    print("created...");
    print("inserting --> $table --> $instanceTableFieldsMap");
    var res = await db.insert(table, instanceTableFieldsMap);

    dao.id = res;
    print("insert result --> $res");
    return dao;
    // return db.insert(table, instanceTableFieldsMap);
  }
}
