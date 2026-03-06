import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:naayu_attire1/features/profile/presentation/provider/profile_provider.dart';
import 'package:naayu_attire1/features/profile/domain/usecases/update_profile.dart';

class MockUpdateProfile extends Mock implements UpdateProfile {}

void main() {

  late ProfileProvider provider;
  late MockUpdateProfile usecase;

  setUp(() {
    usecase = MockUpdateProfile();
    provider = ProfileProvider(usecase);
  });

  test("updateProfile should call usecase", () async {

    when(() => usecase("Ayusha", "123456"))
        .thenAnswer((_) async {});

    await provider.updateProfile("Ayusha", "123456");

    verify(() => usecase("Ayusha", "123456")).called(1);
  });

  test("loading should change during updateProfile", () async {

    when(() => usecase(any(), any()))
        .thenAnswer((_) async {});

    expect(provider.loading, false);

    final future = provider.updateProfile("Ayusha", "123456");

    expect(provider.loading, true);

    await future;

    expect(provider.loading, false);

  });

}