import 'package:dart_persistence_api/database/database.dart';
import 'package:dart_persistence_api/database/utility/sql_command/select/clauses/select_options.dart';
import 'package:dart_persistence_api/database/utility/sql_command/select/clauses/where.dart';
import 'package:dart_persistence_api/model/dao/annotations/integer.dart';
import 'package:dart_persistence_api/model/dao/instance_field.dart';
import 'package:dart_persistence_api/model/dao/test.dart';
import 'package:dart_persistence_api/model/dao/test1.dart';
import 'package:dart_persistence_api/repository/dpi_repository.dart';

import 'dart_persistence_api.reflectable.dart';

void main(List<String> arguments) async {
  initializeReflectable();

  var db = (await SQLiteDatabase.init());

  var test1 = Test1("not_name", [Test("h"), Test("12123")]);
  print(await DPIRepository().save(test1));

  print(((await DPIRepository().query(
    Test1,
  ))
          .firstOrNull as Test1)
      .test);
}
