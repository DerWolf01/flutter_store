import 'dart:async';

import 'package:dart_persistence_api/database/annotations/constraints/appendable/foreign_key/foreign_key.dart';
import 'package:dart_persistence_api/database/annotations/constraints/appendable/primary_key.dart';
import 'package:dart_persistence_api/database/annotations/constraints/constraint.dart';
import 'package:dart_persistence_api/database/annotations/sql_types/integer.dart';
import 'package:dart_persistence_api/database/annotations/sql_types/sql_type.dart';
import 'package:dart_persistence_api/model/dao/annotations/lifecycles/delete.dart';
import 'package:dart_persistence_api/model/dao/annotations/lifecycles/save.dart';
import 'package:dart_persistence_api/model/dao/annotations/lifecycles/update.dart';
import 'package:dart_persistence_api/model/dao/field.dart';
import 'package:dart_persistence_api/model/dao/instance_field.dart';

import 'package:dart_persistence_api/utility/dpi_utility.dart';
import 'package:reflectable/reflectable.dart';


abstract class DAO extends DPIUtility {
  DAO();
  DAO.fromMap(super.map) : super.fromMap();
  Map<String, InstanceField<T>> getFieldsBySQLType<T extends SQLType>() {
    Map<String, InstanceField<T>> res = {};
    for (var dec in modelClassMirror.declarations.entries) {
      T? dataTypeInstance;

      for (var meta in dec.value.metadata) {
        if (meta is T) {
          dataTypeInstance = meta;
          break;
        }
      }

      if (dataTypeInstance != null) {

        res[dec.key] = InstanceField<T>(dec.key, dataTypeInstance, get(dec.key),
            constraints:
                dec.value.metadata.whereType<SQLConstraint>().toList());
      }
    }
    return res;
  }

  Map<String, InstanceField<SQLType>>
      getFieldsBySQLConstraint<T extends SQLConstraint>() {
    Map<String, InstanceField<SQLType>> res = {};
    for (var field in getFieldsBySQLType<SQLType>().entries) {
      if (field.value.constraints.whereType<T>().firstOrNull != null) {
        res[field.key] = field.value;
      }
    }
    return res;
  }

  String get table =>
      toSnakeCase(modelClassMirror.simpleName.replaceAll('DAO', ''));

  @PrimaryKey()
  @Integer()
  late int id;

  List<Field<SQLType>> get primaryKeyFields =>
      getFieldsBySQLConstraint<PrimaryKey>()
          .values
          .map(
              (e) => Field<SQLType>(e.name, e.type, constraints: e.constraints))
          .toList();

  String get primaryKeyConstraints =>
      "PRIMARY KEY( ${primaryKeyFields.map((e) => e.name).join(', ')}";

  Map<String, ForeignKey> get foreignFields =>
      attributesByAnnotation<ForeignKey>(modelClassMirror.classMirror);

  List<MethodMirror> methodsByAnnotation<T>() => modelClassMirror
      .classMirror.instanceMembers.values
      .where((element) => element.metadata.whereType<T>().firstOrNull != null)
      .toList();
  FutureOr callPreSave() async {
    for (var m in methodsByAnnotation<PreSave>()) {
      await modelInstanceMirror.call(m.simpleName, this);
    }
  }

  FutureOr callPostSave() async {
    for (var m in methodsByAnnotation<PostSave>()) {
      await modelInstanceMirror.call(m.simpleName, this);
    }
  }

  FutureOr callPreUpdate() async {
    for (var m in methodsByAnnotation<PreUpdate>()) {
      await modelInstanceMirror.call(m.simpleName, this);
    }
  }

  FutureOr callPostUpdate() async {
    for (var m in methodsByAnnotation<PostUpdate>()) {
      await modelInstanceMirror.call(m.simpleName, this);
    }
  }

  FutureOr callPreDelete() async {
    for (var m in methodsByAnnotation<PreDelete>()) {
      await modelInstanceMirror.call(m.simpleName, this);
    }
  }

  FutureOr callPostDelete() async {
    for (var m in methodsByAnnotation<PostDelete>()) {
      await modelInstanceMirror.call(m.simpleName, this);
    }
  }
}
