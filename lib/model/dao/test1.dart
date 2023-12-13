import 'package:dart_persistence_api/database/annotations/constraints/appendable/foreign_key/one_to_many.dart';
import 'package:dart_persistence_api/database/annotations/constraints/appendable/primary_key.dart';
import 'package:dart_persistence_api/model/dao/annotations/integer.dart';
import 'package:dart_persistence_api/model/dao/annotations/varchar.dart';
import 'package:dart_persistence_api/model/dao/dao.dart';
import 'package:dart_persistence_api/model/dao/test.dart';
import 'package:dart_persistence_api/reflector/reflector.dart';

const reflector2 = Reflector();
const oneToMany = OneToMany<Test1, Test>();

@reflector2
class Test1 extends DAO {
  Test1(this.name, this.test);
  Test1.fromMap(super.map) : super.fromMap();

  @override
  @PrimaryKey()
  @Integer()
  late int id = 0;

  @Varchar()
  late String name;

  @oneToMany
  late List<DAO> test = [];
}
