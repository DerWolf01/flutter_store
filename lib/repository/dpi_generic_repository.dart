import 'package:dart_persistence_api/database/utility/sql_command/select/clauses/select_options.dart';
import 'package:dart_persistence_api/model/dao/dao.dart';
import 'package:dart_persistence_api/model/model.dart';
import 'package:dart_persistence_api/model/reflector/model_class_mirror.dart';
import 'package:dart_persistence_api/repository/dpi_repository_interface.dart';

class DPIGenericRepository extends DPIRepositoryInterface {
  @override
  all(ModelClassMirror<Model> modelClassMirror) {
    // TODO: implement all
    throw UnimplementedError();
  }

  @override
  delete(DAO dao) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  save(DAO dao) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  update(DAO dao) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future query(Type dao, {SelectOptions? selectOptions}) {
    // TODO: implement query
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> queryMap(Type dao,
      {SelectOptions? selectOptions}) {
    // TODO: implement queryMap
    throw UnimplementedError();
  }
}
