import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/profile/domain/usecases/update_profile.dart';

class ProfileProvider extends ChangeNotifier {

  final UpdateProfile updateProfileUsecase;

  ProfileProvider(this.updateProfileUsecase);

  bool loading = false;

  Future<void> updateProfile(String name, String password) async {

    loading = true;
    notifyListeners();

    await updateProfileUsecase(name, password);

    loading = false;
    notifyListeners();
  }
}