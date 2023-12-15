import 'package:dart_persistence_api/database/database.dart';
import 'package:dart_persistence_api/database/utility/sql_command/delete.dart';
import 'package:dart_persistence_api/database/utility/sql_command/insert.dart';
import 'package:dart_persistence_api/database/utility/sql_command/select/clauses/select_options.dart';
import 'package:dart_persistence_api/database/utility/sql_command/select/clauses/where.dart';
import 'package:dart_persistence_api/database/utility/sql_command/select/select.dart';
import 'package:dart_persistence_api/database/annotations/sql_types/integer.dart';
import 'package:dart_persistence_api/model/dao/dao.dart';
import 'package:dart_persistence_api/model/dao/instance_field.dart';
import 'package:dart_persistence_api/model/model.dart';
import 'package:dart_persistence_api/model/reflector/model_class_mirror.dart';
import 'package:dart_persistence_api/repository/dpi_repository_interface.dart';

class DPIRepository<T extends DAO> extends DPIRepositoryInterface<T> {
  all(ModelClassMirror modelClassMirror) {}

  @override
  Future<int> delete(T dao) async {
    await dao.callPreDelete();
    var db = await initDB();
    for (var foreignField in dao.foreignFields.entries) {
      dao.set(foreignField.key,
          await foreignField.value.delete(dao.get(foreignField.key), dao));
    }

    var res = await Delete(
            db.db,
            dao,
            Wheres(
                [Where('id', InstanceField<Integer>('id', Integer(), dao.id))]))
        .execute();

    await dao.callPostDelete();
    return res;
  }

  @override
  Future<T> save(T dao) async {
    await dao.callPreSave();
    var db = (await SQLiteDatabase.init()).db;
    dao.set("id", (await Insert<T>(db, dao).execute()).id);

    for (var foreignField in dao.foreignFields.entries) {
      dao.set(foreignField.key,
          await foreignField.value.save(dao, dao.get(foreignField.key)));
    }
    print(dao);
    print(dao.id);
    await dao.callPostSave();

    return dao;
  }

  @override
  Future<List<Map<String, dynamic>>> queryMap(Type dao,
      {SelectOptions? selectOptions}) async {
    var mirror = ModelClassMirror<Model>(dao);
    var db = (await SQLiteDatabase.init()).db;
    List<Map<String, dynamic>> res = [];
    var daos = (await Select(db, dao, selectOptions: selectOptions).execute());
    for (var d in daos) {
      Map<String, List<Map<String, dynamic>>> foreignFields = {};
      for (var foreignKey in mirror.foreignFields.entries) {
        foreignFields[foreignKey.key] =
            await foreignKey.value.queryMap(d["id"] as int);
      }

      res.add(<String, dynamic>{...d, ...foreignFields});
    }
    return res;
  }

  @override
  Future<List<T>> query(Type dao, {SelectOptions? selectOptions}) async {
    var mirror = ModelClassMirror<Model>(dao);

    return (await queryMap(dao, selectOptions: selectOptions))
        .map((m) => mirror.fromMap(m) as T)
        .toList();
  }

  @override
  Future<int> update(T dao) async {
    await dao.callPreUpdate();
    await dao.callPostUpdate();
    return 0;
  }
}
