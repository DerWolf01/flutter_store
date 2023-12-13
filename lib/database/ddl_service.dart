import 'package:dart_persistence_api/database/annotations/constraints/appendable/foreign_key/foreign_key.dart';
import 'package:dart_persistence_api/database/utility/database_utility.dart';
import 'package:dart_persistence_api/reflector/reflector.dart';
import 'package:dart_persistence_api/model/model_collector.dart';
import 'package:dart_persistence_api/utility/dpi_utility.dart';
import 'package:reflectable/mirrors.dart';

const reflector = Reflector();

class DDLService extends DatabaseUtility {
  DDLService(super.db);

  // bool isEntity(ClassMirror classMirror) =>
  //     classMirror.metadata.whereType<Entity>().firstOrNull == null
  //         ? false
  //         : true;
  // Future<void> createTables() async {
  //   List<Type> models = ModelCollector.collectModels();
  //   for (var model in models) {
  //     ClassMirror classMirror = reflector.reflectType(model) as ClassMirror;

  //     if (!isEntity(classMirror)) {
  //       continue;
  //     }
  //     var createString = genCreateTableString(classMirror);
  //     print(createString);
  //     await db.execute(createString);
  //   }
  //   for (var model in models) {
  //     ClassMirror classMirror = reflector.reflectType(model) as ClassMirror;
  //     await createTableReferences(classMirror);
  //   }
  // }

  // String genCreateTableString(ClassMirror classMirror) {
  //   var tableName = toSnakeCase(classMirror.simpleName);
  //   var attributesString = "(${getSQLFieldsWithTypes(classMirror)})";
  //   return "CREATE TABLE IF NOT EXISTS $tableName $attributesString";
  // }

  // Future<void> createTableConnections(ClassMirror classMirror) async {
  //   Map<String, ForeignKey> foreignKeys =
  //       attributesByAnnotation<ForeignKey>(classMirror);
  //   for (var foreignKeyEntrie in foreignKeys.entries) {
  //     var foreignKey = foreignKeyEntrie.value;

  //     return await Connection(classMirror, foreignKeyEntrie.key, foreignKey)
  //         .createTable(db);
  //   }
  // }
}
