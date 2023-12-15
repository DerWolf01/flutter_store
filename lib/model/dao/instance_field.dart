import 'package:dart_persistence_api/database/annotations/sql_types/sql_type.dart';
import 'package:dart_persistence_api/model/dao/field.dart';

class InstanceField<T extends SQLType> extends Field<T> {
  InstanceField(super.name, super.type, this.value, {super.constraints});
  final dynamic value;
}
