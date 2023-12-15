import 'package:dart_persistence_api/database/annotations/constraints/appendable/primary_key.dart';
import 'package:dart_persistence_api/database/annotations/sql_types/integer.dart';
import 'package:dart_persistence_api/database/annotations/sql_types/varchar.dart';

import 'package:dart_persistence_api/model/dao/dao.dart';


class Test extends DAO {
  Test(this.name);
  Test.fromMap(super.map) : super.fromMap();
  @override
  @PrimaryKey()
  @Integer()
  late int id = 0;

  @Varchar()
  late String name;
}
