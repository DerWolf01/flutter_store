import 'package:dart_persistence_api/database/annotations/constraints/appendable/foreign_key/connection.dart';
import 'package:dart_persistence_api/database/annotations/constraints/appendable/foreign_key/foreign_key.dart';
import 'package:dart_persistence_api/model/dao/dao.dart';
import 'package:dart_persistence_api/reflector/reflector.dart';

const reflector = Reflector();

@reflector
class OneToMany<FROM extends DAO, TO extends DAO> extends ForeignKey<FROM, TO> {
  const OneToMany();

  @override
  ConnectionEntity getConnectionEntity<F extends DAO, T extends DAO>() {
    print(
        "--------------------------------------------------------- getConnectionEntity ---------------------------------------------------------");
    print(FROM);
    print(TO);
    return OneToManyConnection<FROM, TO>(this);
  }
}

@reflector
class OneToManyConnection<FROM extends DAO, TO extends DAO>
    extends ConnectionEntity<OneToMany<FROM, TO>, FROM, TO> {
  OneToManyConnection(super.foreignKey);
}
