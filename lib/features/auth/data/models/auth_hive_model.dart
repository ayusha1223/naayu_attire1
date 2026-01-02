import 'package:hive/hive.dart';
import 'package:naayu_attire1/features/auth/domain/entities/auth_entity.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: 1)
class AuthHiveModel extends HiveObject {

  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? fullName;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? password;

  AuthHiveModel({
    this.id,
    this.fullName,
    this.email,
    this.password,
  });

  // 🔁 Hive → Entity
  AuthEntity toEntity() {
    return AuthEntity(
      id: id ?? '',
      fullName: fullName ?? '',
      email: email ?? '',
      password: password ?? '',
    );
  }

  // 🔁 Entity → Hive
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      id: entity.id.isEmpty ? null : entity.id,
      fullName: entity.fullName.isEmpty ? null : entity.fullName,
      email: entity.email.isEmpty ? null : entity.email,
      password: entity.password.isEmpty ? null : entity.password,
    );
  }
}
