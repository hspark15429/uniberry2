import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry/core/enums/update_user_enum.dart';
import 'package:uniberry/src/auth/domain/repository/authentication_repository.dart';
import 'package:uniberry/src/auth/domain/usecases/update_user.dart';

import 'mock_authentication_repository.dart';

void main() {
  late AuthenticationRepository repo;
  late UpdateUser usecase;

  setUp(() {
    repo = MockAuthenticationRepository();
    usecase = UpdateUser(repo);
    registerFallbackValue(UpdateUserAction.email);
  });

  test(
    'should call the [AuthRepo]',
    () async {
      when(
        () => repo.updateUser(
          action: any(named: 'action'),
          userData: any<dynamic>(named: 'userData'),
        ),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase(
        const UpdateUserParams(
          action: UpdateUserAction.email,
          userData: 'Test email',
        ),
      );

      expect(result, const Right<dynamic, void>(null));

      verify(
        () => repo.updateUser(
          action: UpdateUserAction.email,
          userData: 'Test email',
        ),
      ).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
