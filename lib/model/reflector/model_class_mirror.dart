import 'package:dart_persistence_api/database/annotations/constraints/appendable/foreign_key/foreign_key.dart';
import 'package:dart_persistence_api/model/model.dart';
import 'package:dart_persistence_api/model/model_collector.dart';
import 'package:dart_persistence_api/model/reflector/model_instance_mirror.dart';
import 'package:dart_persistence_api/reflector/reflector.dart';
import 'package:dart_persistence_api/utility/dpi_utility.dart';
import 'package:reflectable/reflectable.dart';

const reflector = Reflector();

class ModelClassMirror<T extends Model> extends DPIUtility {
  ModelClassMirror(this.type)
      : classMirror = reflector.reflectType(type) as ClassMirror;
  Type type;
  ClassMirror classMirror;

  String get simpleName {
    return classMirror.simpleName;
  }

  String get snakeCaseName => toSnakeCase(simpleName.replaceAll('DAO', ''));

  Map<String, DeclarationMirror> get declarations {
    ClassMirror? classMirror = this.classMirror;
    Map<String, DeclarationMirror> decs = {};
    bool hasSuperClass = true;
    while (classMirror != null) {
      decs.addAll(classMirror.declarations);
      try {
        classMirror = classMirror.superclass;
      } catch (e) {
        print(e);
        classMirror = null;
      }
    }
    return decs;
  }

  T fromMap(Map<String, dynamic> map) {
    return classMirror.newInstance('fromMap', [map]) as T;
  }

  Map<String, ForeignKey> get foreignFields =>
      attributesByAnnotation<ForeignKey>(classMirror);
}
