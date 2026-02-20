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

  @HiveField(4)
  final String? token;   

  @HiveField(5)
  final String? role;    

  AuthHiveModel({
    this.id,
    this.fullName,
    this.email,
    this.password,
    this.token,
    this.role,
  });

  // 🔁 Hive → Entity
  AuthEntity toEntity() {
    return AuthEntity(
      id: id ?? '',
      fullName: fullName ?? '',
      email: email ?? '',
      password: password ?? '',
      token: token ?? '',
      role: role ?? 'user',
    );
  }

  // 🔁 Entity → Hive
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      id: entity.id.isEmpty ? null : entity.id,
      fullName: entity.fullName.isEmpty ? null : entity.fullName,
      email: entity.email.isEmpty ? null : entity.email,
      password: entity.password.isEmpty ? null : entity.password,
      token: entity.token.isEmpty ? null : entity.token,
      role: entity.role.isEmpty ? null : entity.role,
    );
  }
}