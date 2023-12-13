import 'dart:async';

import 'package:dart_persistence_api/database/annotations/constraints/appendable/foreign_key/foreign_key.dart';
import 'package:dart_persistence_api/database/annotations/constraints/appendable/foreign_key/one_to_many.dart';
import 'package:dart_persistence_api/model/dao/dao.dart';
import 'package:dart_persistence_api/model/model_collector.dart';
import 'package:dart_persistence_api/model/reflector/model_class_mirror.dart';
import 'package:dart_persistence_api/model/reflector/model_instance_mirror.dart';
import 'package:dart_persistence_api/reflector/reflector.dart';
import 'package:dart_persistence_api/utility/dpi_utility.dart';
import 'package:reflectable/reflectable.dart';

const reflector = Reflector();

@reflector
abstract class Model {
  const Model();
  Map<String, dynamic> toMap() {
    Map<String, dynamic> res = instanceMembers
        .map((key, value) => MapEntry(key, genMapEntryValue(get(key))));
    res["type"] = modelClassMirror.simpleName;
    print("${modelClassMirror.simpleName} --> to-map --> $res");
    return res;
  }

  Model.fromMap(Map<String, dynamic> map) {
    print("map:");
    print(map);
    for (var attr in instanceMembers.entries) {
      var value;
      var rawValue = map[attr.key];
      var attrType = attr.value.reflectedType;
      print(
          "setting ${attr.key} --> ${(attr.value.reflectedType)} --> ${map[attr.key]}");

      var foreignKey = attr.value.metadata.whereType<ForeignKey>().firstOrNull;
      if (rawValue == null || rawValue == "null") {
        print("no value available for ${attr.key}");
        if (attrType == List) {
          rawValue = [];
        }
        if (rawValue == String) {
          rawValue = "";
        }
      } else if (foreignKey != null) {
        var mirror = foreignKey.fromModelClassMirror;
        print(mirror.classMirror.typeArguments);
        if (foreignKey is OneToMany && rawValue is List) {
          value = rawValue.map((e) => foreignKey.toModelFromMap(e)).toList();
        } else {
          value = foreignKey.toModelFromMap(rawValue);
        }
      } else {
        value = rawValue;
      }

      // ignore:
      modelInstanceMirror[attr.key] = value;
    }
  }

  dynamic genMapEntryValue(dynamic value) {
    var res = value;
    if (value is Model) {
      res = value.toMap();
    } else if (value is List<Model>) {
      res = value.map((e) => e.toMap()).toList();
    } else if (value is int || value is double) {
      res = value;
    } else {
      res = value.toString();
    }
    return res;
  }

  ModelClassMirror get modelClassMirror {
    print("getting model class mirror for $this");
    return ModelClassMirror(runtimeType);
  }

  ModelInstanceMirror get modelInstanceMirror {
    return ModelInstanceMirror(this);
  }

  Map<String, VariableMirror> get instanceMembers {
    return modelInstanceMirror.instanceMembers;
  }

  void set(String name, dynamic value) {
    modelInstanceMirror[name] = value;
  }

  dynamic get(String name) => modelInstanceMirror[name];

  // T getType<T extends IMessage>(T type);
  // Type type;

  // static ClassMirror? classMirrorByName(String name) {
  //   dynamic type = types[name];
  //   if (type == null) {
  //     return null;
  //   }

  //   var typeMirror = reflector.reflectType(type) as ClassMirror;

  //   return typeMirror;
  // }
}
