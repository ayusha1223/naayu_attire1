import 'package:naayu_attire1/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<void> call(String name, String password) {
    return repository.updateProfile(name, password);
  }
}