import 'package:dart_persistence_api/model/model.dart';
import 'package:dart_persistence_api/model/reflector/model_class_mirror.dart';
import 'package:dart_persistence_api/reflector/reflector.dart';
import 'package:reflectable/reflectable.dart';

const reflector = Reflector();

class ModelInstanceMirror<T extends Model> extends ModelClassMirror {
  ModelInstanceMirror(T model) : super(model.runtimeType) {
    instanceMirror = reflector.reflect(model);
  }
  late InstanceMirror instanceMirror;
  late T instance;
  Map<String, VariableMirror> get instanceMembers {
    if (!instanceMirror.hasReflectee) {
      return {};
    }

    var classMirror;
    try {
      classMirror = instanceMirror.type;
    } catch (e) {
      classMirror = reflector.reflectType(instanceMirror.reflectee.runtimeType)
          as ClassMirror;
    }

    Map<String, VariableMirror> res = {};

    for (var dec in declarations.entries) {
      if (dec.value is VariableMirror &&
          !((dec.value as VariableMirror).isStatic)) {
        res[dec.key] = (dec.value as VariableMirror);
      }
    }
    return res;
  }

  VariableMirror? instanceMemberByName(String name) {
    return instanceMembers[name];
  }

  void operator []=(String name, dynamic value) {
    print("invoking setter $name $value");
    instanceMirror.invokeSetter(name, value);
  }

  dynamic operator [](String name) {
    var res;
    try {
      res = instanceMirror.invokeGetter(name);
    } catch (e) {
      print(e);
      res = null;
    }
    return res;
  }
}
