import 'package:dart_persistence_api/utility/dpi_utility.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseUtility extends DPIUtility {
  const DatabaseUtility(this.db);

  final Database db;
}
