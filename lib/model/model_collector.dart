import 'package:characters/characters.dart';
import 'package:dart_persistence_api/model/dao/test.dart';
import 'package:dart_persistence_api/model/dao/test1.dart';
import 'package:dart_persistence_api/model/model.dart';

class ClassCollector {
  static final List<Type> models = [];
  static final Map<String, Type> modelsMap = {"Test": Test, "Test1": Test1};
  String getTableName() {
    String res = "";
    Characters name = runtimeType.toString().characters;
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

  static Type? getModel(String name) {
    return modelsMap[name];
  }

  static List<Type> collectModels() {
    return models;
  }
}
