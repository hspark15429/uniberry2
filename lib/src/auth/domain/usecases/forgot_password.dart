import 'package:uniberry2/core/usecases/usecases.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/auth/domain/repository/authentication_repository.dart';

class ForgotPassword extends UsecaseWithParams<void, String> {
  const ForgotPassword(this._repo);

  final AuthenticationRepository _repo;

  @override
  ResultFuture<void> call(String params) => _repo.forgotPassword(params);
}
