import 'package:dart_persistence_api/database/annotations/constraints/appendable/primary_key.dart';
import 'package:dart_persistence_api/database/annotations/constraints/normal/not_null.dart';
import 'package:dart_persistence_api/database/annotations/constraints/appendable/foreign_key/foreign_key.dart';
import 'package:dart_persistence_api/database/annotations/sql_types/integer.dart';
import 'package:dart_persistence_api/database/annotations/sql_types/sql_type.dart';
import 'package:dart_persistence_api/database/database.dart';
import 'package:dart_persistence_api/database/utility/sql_command/delete.dart';
import 'package:dart_persistence_api/database/utility/sql_command/select/clauses/select_options.dart';
import 'package:dart_persistence_api/database/utility/sql_command/select/clauses/where.dart';
import 'package:dart_persistence_api/database/utility/sql_command/select/select.dart';
import 'package:dart_persistence_api/model/dao/dao.dart';
import 'package:dart_persistence_api/model/dao/field.dart';
import 'package:dart_persistence_api/model/dao/instance_field.dart';
import 'package:dart_persistence_api/model/reflector/model_class_mirror.dart';
import '../../../../../../reflector/reflector.dart';
import 'package:dart_persistence_api/utility/alphabet_utility.dart';

@reflector
abstract class ConnectionEntity<RelationType extends ForeignKey,
    FROM extends DAO, TO extends DAO> extends DAO {
  ConnectionEntity(this.foreignKey);

  final RelationType foreignKey;
  ModelClassMirror get from => foreignKey.fromModelClassMirror;
  ModelClassMirror get to => foreignKey.toModelClassMirror;

  @override
  String get table => '${AlphabetUtility().orderByAlphabet([
            from.snakeCaseName,
            to.snakeCaseName
          ]).join('_')}_connection';

  Field get idField =>
      Field<Integer>('id', Integer(), constraints: [PrimaryKey()]);
  Field get fromField => Field<Integer>('${from.snakeCaseName}_id', Integer(),
      constraints: [NotNull()]);
  Field get toField => Field<Integer>('${to.snakeCaseName}_id', Integer(),
      constraints: [NotNull()]);

  List<Field> get fields => [idField, fromField, toField];

  String get fieldsString =>
      fields.map((e) => '${e.name} ${e.type.toSQL()}').join(', ');

  String get foreignKeyConstraints => '''
FOREIGN KEY(${from.snakeCaseName}_id) REFERENCES ${from.snakeCaseName}(id) ,
FOREIGN KEY(${to.snakeCaseName}_id) REFERENCES ${to.snakeCaseName}(id)
''';

  @override
  String get primaryKeyConstraints =>
      'PRIMARY KEY(${from.snakeCaseName}_id,${to.snakeCaseName}_id)';

  String get createTableStatement =>
      "CREATE TABLE IF NOT EXISTS $table ( $fieldsString , $primaryKeyConstraints , $foreignKeyConstraints ) ";

  Future<int> delete(FROM from, TO to) async {
    return await Delete(
        (await initDB()).db,
        this,
        Wheres([
          Where(
              '${this.from.snakeCaseName}_id',
              InstanceField<Integer>(
                  from.modelClassMirror.simpleName, Integer(), from.id)),
          Where(
              '${this.to.snakeCaseName}_id',
              InstanceField<Integer>(
                  to.modelClassMirror.simpleName, Integer(), to.id))
        ])).execute();
  }

  Future<int> save(FROM from, TO to) async {
    var db = (await initDB()).db;
    await db.execute(createTableStatement);
    var connectionInsert = await db.insert(table, {
      '${this.from.snakeCaseName}_id': from.id,
      '${this.to.snakeCaseName}_id': to.id
    });
    print("Inserted connection --> $connectionInsert");
    return connectionInsert;
  }

  Future<void> create() async {
    var db = await SQLiteDatabase.init();
    print(createTableStatement);
    db.db.execute(createTableStatement);
  }

  Future<List<Map<String, Object?>>> queryByToModel(TO model) async {
    return await Select(((await initDB()).db), runtimeType,
        tableName: table,
        selectOptions: SelectOptions(
            columns: ['id', fromField.name, toField.name],
            wheres: Wheres([
              Where(toField.name,
                  InstanceField<Integer>(toField.name, Integer(), model.id))
            ]))).execute();
  }

  Future<List<Map<String, Object?>>> queryByFromModel(int fromModelId) async {
    var res = await Select(((await initDB()).db), runtimeType,
        tableName: table,
        selectOptions: SelectOptions(
            columns: ['id', fromField.name, toField.name],
            wheres: Wheres([
              Where(
                  fromField.name,
                  InstanceField<Integer>(
                      fromField.name, Integer(), fromModelId))
            ]))).execute();
    return res;
  }
}
