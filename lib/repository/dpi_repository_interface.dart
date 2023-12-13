import 'package:dart_persistence_api/database/utility/sql_command/select/clauses/select_options.dart';
import 'package:dart_persistence_api/model/dao/dao.dart';
import 'package:dart_persistence_api/utility/dpi_utility.dart';

abstract class DPIRepositoryInterface<T extends DAO> extends DPIUtility {
  Future<DAO> save(T dao);
  Future<int> update(T dao);
  Future<int> delete(T dao);
  Future query(Type dao, {SelectOptions? selectOptions});
  Future<List<Map<String, dynamic>>> queryMap(Type dao,
      {SelectOptions? selectOptions});
}
