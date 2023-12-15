import 'dart:convert';
import 'package:dart_persistence_api/model/model.dart';

class DTO extends Model {
  DTO(this.id);
  String toJson() => jsonEncode(toMap());
  DTO.fromJSON(String json) : super.fromMap(jsonDecode(json));

  int? id;
}
