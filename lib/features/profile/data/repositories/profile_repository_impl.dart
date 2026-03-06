import 'package:naayu_attire1/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:naayu_attire1/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {

  final ProfileRemoteDatasource datasource;

  ProfileRepositoryImpl(this.datasource);

  @override
  Future<void> updateProfile(String name, String password) {
    return datasource.updateProfile(name, password);
  }
}