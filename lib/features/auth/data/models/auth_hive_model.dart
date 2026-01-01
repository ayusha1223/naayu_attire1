import 'package:hive/hive.dart';
import 'package:naayu_attire1/features/auth/domain/entities/auth_entity.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: 1)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String fullName;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password;

  AuthHiveModel({
    required this.fullName,
    required this.email,
    required this.password,
  });

  // Convert Hive → Entity
  AuthEntity toEntity() {
    return AuthEntity(
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  // Convert Entity → Hive
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
    );
  }
}
