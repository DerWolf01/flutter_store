import 'dart:convert';

import 'package:dart_persistence_api/model/model.dart';

class DTO extends Model {
  String toJson() => jsonEncode(toMap());
  DTO.fromJSON(String json) : super.fromMap(jsonDecode(json));
}
