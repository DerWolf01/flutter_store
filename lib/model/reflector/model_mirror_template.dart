import 'package:reflectable/reflectable.dart';

abstract class ModelMirrorTemplate {
  ModelMirrorTemplate(this.type);
  Type type;
  String get typeName;
  Map<String, DeclarationMirror> get declarations;
}
