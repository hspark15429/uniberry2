import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/src/auth/domain/repository/authentication_repository.dart';
import 'package:uniberry2/src/auth/domain/usecases/forgot_password.dart';

import 'mock_authentication_repository.dart';

void main() {
  late AuthenticationRepository repo;
  late ForgotPassword usecase;

  setUp(() {
    repo = MockAuthenticationRepository();
    usecase = ForgotPassword(repo);
  });

  test(
    'should call the [AuthRepo.forgotPassword]',
    () async {
      when(() => repo.forgotPassword(any())).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase('email');

      expect(result, equals(const Right<dynamic, void>(null)));

      verify(() => repo.forgotPassword('email')).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
