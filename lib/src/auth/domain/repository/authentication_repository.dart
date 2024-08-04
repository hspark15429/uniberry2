import 'package:uniberry/core/enums/update_user_enum.dart';
import 'package:uniberry/core/utils/typedefs.dart';
import 'package:uniberry/src/auth/domain/entities/user.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  });

  ResultFuture<void> signUp({
    required String email,
    required String fullName,
    required String password,
  });

  ResultFuture<void> forgotPassword(String email);

  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}
