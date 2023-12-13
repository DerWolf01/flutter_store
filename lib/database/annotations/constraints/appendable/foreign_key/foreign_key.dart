import 'package:dart_persistence_api/database/annotations/constraints/appendable/append_constraint.dart';
import 'package:dart_persistence_api/database/annotations/constraints/appendable/foreign_key/connection.dart';
import 'package:dart_persistence_api/database/database.dart';
import 'package:dart_persistence_api/database/utility/sql_command/delete.dart';
import 'package:dart_persistence_api/database/utility/sql_command/insert.dart';
import 'package:dart_persistence_api/database/utility/sql_command/select/clauses/select_options.dart';
import 'package:dart_persistence_api/database/utility/sql_command/select/clauses/where.dart';
import 'package:dart_persistence_api/database/utility/sql_command/select/select.dart';
import 'package:dart_persistence_api/model/dao/annotations/integer.dart';
import 'package:dart_persistence_api/model/dao/dao.dart';
import 'package:dart_persistence_api/model/dao/instance_field.dart';
import 'package:dart_persistence_api/model/reflector/model_class_mirror.dart';
import 'package:dart_persistence_api/reflector/reflector.dart';
import 'package:dart_persistence_api/model/model.dart';
import 'package:dart_persistence_api/repository/dpi_repository.dart';

import 'package:dart_persistence_api/repository/dpi_repository_interface.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const reflector = Reflector();

@reflector
abstract class ForeignKey<FROM extends DAO, TO extends DAO>
    extends AppendSQLConstraint {
  const ForeignKey(
      // this.fromType, this.toType
      );

  Future<SQLiteDatabase> get db async => await SQLiteDatabase.init();

  // final Type fromType;
  // final Type toType;
  ConnectionEntity getConnectionEntity<F extends DAO, T extends DAO>();

  Future queryMaps(int fromId) async {
    print("from id = $fromId");
    var connection = getConnectionEntity<FROM, TO>();
    var connections = (await connection.queryByFromModel(fromId));
    print("connections --> $connections");

    List<Map<String, dynamic>> result = [];

    for (var map in connections) {
      var data = await DPIRepository().queryMap(FROM,
          selectOptions: SelectOptions(
              wheres: Wheres([
            Where(
                'id',
                InstanceField(
                    'id', Integer(), map[connection.toField.name] as int))
          ])));
      print("query-map: $data");
      result.addAll(data);
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> queryMap(int fromId) async {
    print("from id = $fromId");
    var connection = getConnectionEntity<FROM, TO>();
    var connections = (await connection.queryByFromModel(fromId));
    print("connections --> $connections");

    List<Map<String, dynamic>> result = [];

    for (var map in connections) {
      var data = await DPIRepository().queryMap(TO,
          selectOptions: SelectOptions(
              wheres: Wheres([
            Where(
                'id',
                InstanceField(
                    'id', Integer(), map[connection.toField.name] as int))
          ])));
      print("query-map: $data");
      result.addAll(data);
    }

    return result;
  }

  Future query(int fromId) async {
    var mirror = ModelClassMirror(TO);
    return (await queryMap(fromId)).map((d) => mirror.fromMap(d)).toList();
  }

  Future<int> delete(FROM fromModel, TO toModel) async {
    var connection = getConnectionEntity<FROM, TO>();
    return await connection.delete(fromModel, toModel);
  }

  Future save(FROM fromModel, dynamic toModel) async {
    var database = (await db);
    if (toModel is List) {
      print("foreign field is list");
      for (var to in toModel) {
        to.id = (await Insert<TO>(database.db, to).execute()).id;
        var connection = getConnectionEntity<FROM, TO>();
        await connection.save(fromModel, to);
      }
    } else if (toModel is DAO) {
      toModel.id = (await Insert<TO>(database.db, toModel as TO).execute()).id;
      var connection = getConnectionEntity<FROM, TO>();
      await connection.save(fromModel, toModel);
    }

    return toModel;
  }

  ModelClassMirror<FROM> get fromModelClassMirror =>
      ModelClassMirror<FROM>(FROM);
  ModelClassMirror<TO> get toModelClassMirror => ModelClassMirror<TO>(TO);

  FROM fromModelFromMap(Map<String, dynamic> map) {
    return fromModelClassMirror.fromMap(map);
  }

  TO toModelFromMap(Map<String, dynamic> map) {
    return toModelClassMirror.fromMap(map);
  }

  void setToModel<T extends Model>(
      T model, String name, Map<String, dynamic> map) {
    model.set(name, toModelFromMap(map));
  }
}
