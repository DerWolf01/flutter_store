import 'package:dart_persistence_api/database/annotations/constraints/appendable/foreign_key/one_to_many.dart';
import 'package:dart_persistence_api/database/annotations/constraints/appendable/primary_key.dart';
import 'package:dart_persistence_api/database/annotations/sql_types/integer.dart';
import 'package:dart_persistence_api/database/annotations/sql_types/varchar.dart';
import 'package:dart_persistence_api/model/dao/annotations/lifecycles/save.dart';
import 'package:dart_persistence_api/model/dao/dao.dart';
import 'package:dart_persistence_api/model/dao/test.dart';
import '../../../reflector/reflector.dart';

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

  @PreSave()
  Future preSave(Test1 dao) async {
    print("pre saving $dao");
  }

  @PostSave()
  Future postSave(Test1 dao) async {
    print("post saving $dao");
  }
}
