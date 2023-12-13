import 'package:characters/characters.dart';
import 'package:dart_persistence_api/database/annotations/constraints/appendable/foreign_key/foreign_key.dart';
import 'package:dart_persistence_api/database/annotations/sql_annotation.dart';
import 'package:dart_persistence_api/database/database.dart';
import 'package:dart_persistence_api/model/dao/annotations/sql_type.dart';
import 'package:dart_persistence_api/reflector/reflector.dart';
import 'package:dart_persistence_api/model/model.dart';
import 'package:reflectable/reflectable.dart';

const reflector = Reflector();

abstract class DPIUtility extends Model {
  const DPIUtility();
  DPIUtility.fromMap(super.map) : super.fromMap();
  getAttributes(ClassMirror classMirror) {
    classMirror.typeVariables.map((e) => e.simpleName).toList();
  }

  String toSnakeCase(String attributeName) {
    String res = "";
    Characters name = attributeName.characters;
    int i = -1;
    for (String char in name) {
      i++;
      if (RegExp(r"[A-Z]").hasMatch(char) && i != 0) {
        print("is uppercase");
        res += '_${char.toLowerCase()}';
        continue;
      }
      res += char.toLowerCase();
    }
    return res;
  }

  Map<String, T> attributesByAnnotation<T>(ClassMirror classMirror) {
    Map<String, T> res = {};
    for (var dec in classMirror.declarations.entries) {
      T? dataTypeInstance;

      for (var meta in dec.value.metadata) {
        if (meta is T) {
          dataTypeInstance = meta as T;
          break;
        }
      }

      if (dataTypeInstance != null) {
        res[dec.key] = dataTypeInstance;
      }
    }
    return res;
  }

  Map<String, SQLAnnotation> getFields(ClassMirror model) {
    Map<String, SQLAnnotation> res = {};
    var declarations = model.declarations;
    for (var declarationName in declarations.keys) {
      var declaration = declarations[declarationName];
      if (declaration == null) {
        continue;
      }

      for (var annotation in declaration.metadata) {
        if (annotation is SQLAnnotation) {
          res[toSnakeCase(declaration.simpleName)] = annotation;
        }
      }
    }
    return res;
  }

  String getFieldsSQLFormat(ClassMirror classMirror) {
    var resMap = getFields(classMirror);
    resMap.removeWhere((key, value) => value is ForeignKey);

    String res = resMap
        .map((key, value) => MapEntry(key, '$toSnakeCase(key)'))
        .values
        .toList()
        .join(', ');
    return res;
  }

  String getSQLFieldsWithTypes(ClassMirror classMirror) {
    var resMap = attributesByAnnotation<SQLType>(classMirror);
    resMap.removeWhere((key, value) => value is ForeignKey);

    String res = resMap
        .map((key, value) =>
            MapEntry(key, '${toSnakeCase(key)} ${value.toSQL()}'))
        .values
        .toList()
        .join(', ');
    return res;
  }

  Map<String, dynamic> getInstanceTableFields<T extends Model>(
      InstanceMirror model) {
    var selfFields = attributesByAnnotation<SQLType>(
        reflector.reflectType(model.reflectee.runtimeType) as ClassMirror);
    Iterable<MapEntry<String, dynamic>>? entries =
        (model.invoke("toMap", []) as Map<String, dynamic>?)
            ?.entries
            .where((element) => selfFields.containsKey(element.key))
            .map((e) => MapEntry(toSnakeCase(e.key), e.value));
    var res =
        (entries != null) ? Map.fromEntries(entries) : <String, dynamic>{};

    res.remove("id");
    return res;
  }

  Future<SQLiteDatabase> initDB() async {
    return await SQLiteDatabase.init();
  }
}
