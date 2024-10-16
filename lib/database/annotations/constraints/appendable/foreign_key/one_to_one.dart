import 'package:dart_persistence_api/database/annotations/constraints/appendable/foreign_key/connection.dart';
import 'package:dart_persistence_api/database/annotations/constraints/appendable/foreign_key/foreign_key.dart';
import 'package:dart_persistence_api/database/annotations/constraints/appendable/primary_key.dart';
import 'package:dart_persistence_api/database/annotations/constraints/custom_constraints/auto_increment.dart';
import 'package:dart_persistence_api/database/annotations/constraints/normal/not_null.dart';
import 'package:dart_persistence_api/database/annotations/constraints/normal/unique.dart';
import 'package:dart_persistence_api/database/annotations/sql_types/integer.dart';
import 'package:dart_persistence_api/database/annotations/sql_types/sql_type.dart';
import 'package:dart_persistence_api/model/dao/dao.dart';
import 'package:dart_persistence_api/model/dao/field.dart';
import '../../../../../../reflector/reflector.dart';

@reflector
class OneToOne<FROM extends DAO, TO extends DAO> extends ForeignKey<FROM, TO> {
  const OneToOne();

  @override
  Future<TO> query(int fromId) async {
    return (await super.query(fromId)).first;
  }

  @override
  ConnectionEntity getConnectionEntity<F extends DAO, T extends DAO>() {
    return OneToOneConnection<FROM, TO>(this);
  }
}

@reflector
class OneToOneConnection<FROM extends DAO, TO extends DAO>
    extends ConnectionEntity<OneToOne<FROM, TO>, FROM, TO> {
  OneToOneConnection(super.foreignKey);

  @override
  Field get idField => Field<Integer>('id', Integer(),
      constraints: [Unique(), NotNull(), AutoIncrement()]);
  @override
  Field get fromField => Field<Integer>('${from.snakeCaseName}_id', Integer(),
      constraints: [PrimaryKey()]);
  @override
  Field get toField => Field<Integer>('${to.snakeCaseName}_id', Integer(),
      constraints: [PrimaryKey()]);
}
