import 'package:dart_persistence_api/model/dao/annotations/sql_type.dart';
import 'package:dart_persistence_api/model/dao/field.dart';

class InstanceField<T extends SQLType?> extends Field<T> {
  InstanceField(super.name, super.type, this.value, {super.constraints});
  final dynamic value;
}
