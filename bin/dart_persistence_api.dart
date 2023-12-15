import 'package:dart_persistence_api/model/model.dart';
import 'package:dart_persistence_api/reflector/reflector.dart';
import 'package:reflectable/reflectable.dart';

import 'dart_persistence_api.reflectable.dart';

void main(List<String> arguments) async {
  initializeReflectable();

  ClassCollector.collect();
}

class ClassCollector {
  findByName(String name) => reflector.annotatedClasses
      .where((element) => element.simpleName == name)
      .firstOrNull;

  List<ClassMirror> findByType(Type type) =>
      reflector.annotatedClasses.where((element) {
        try {
          return element.isAssignableTo(reflector.reflectType(type));
        } catch (e) {
          return false;
        }
      }).toList();

  List<ClassMirror> findByAnnotationType(Type type) =>
      collectWhere((c) => c.isAssignableTo(reflector.reflectType(type)))
          .toList();

  static collect() {
    for (var lib in reflector.libraries.entries) {
      print(
          "---------------------------------------------------------------: ${lib.key} :---------------------------------------------------------------");
      print(lib.value);
      for (var dec in lib.value.declarations.entries) {
        try {
          if (dec.value is ClassMirror &&
              (dec.value as ClassMirror)
                  .isAssignableTo(reflector.reflectType(Model))) {
            print(
                "---------------------------------------------------------------: ${dec.key} :---------------------------------------------------------------");

            print(dec.value);
          }
        } catch (e) {
          print(e);
        }
      }
    }
  }

  static collectWhere(bool Function(ClassMirror classMirror) callback) {
    List<ClassMirror> res = [];
    for (var lib in reflector.libraries.entries) {
      // print(
      //     "---------------------------------------------------------------: ${lib.key} :---------------------------------------------------------------");
      // print(lib.value);
      for (var dec in lib.value.declarations.entries) {
        try {
          if (dec.value is ClassMirror && callback(dec.value as ClassMirror)) {
            // print(
            //     "---------------------------------------------------------------: ${dec.key} :---------------------------------------------------------------");
            res.add(dec.value as ClassMirror);
            // print(dec.value);
          }
        } catch (e) {
          print(e);
        }
      }
    }
    return res;
  }
}
