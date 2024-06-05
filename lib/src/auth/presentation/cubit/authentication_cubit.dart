import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniberry2/core/enums/update_user_enum.dart';
import 'package:uniberry2/src/auth/data/models/user_model.dart';
import 'package:uniberry2/src/auth/domain/entities/user.dart';
import 'package:uniberry2/src/auth/domain/usecases/forgot_password.dart';
import 'package:uniberry2/src/auth/domain/usecases/sign_in.dart';
import 'package:uniberry2/src/auth/domain/usecases/sign_up.dart';
import 'package:uniberry2/src/auth/domain/usecases/update_user.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    required ForgotPassword forgotPassword,
    required SignIn signIn,
    required SignUp signUp,
    required UpdateUser updateUser,
  })  : _forgotPassword = forgotPassword,
        _signIn = signIn,
        _signUp = signUp,
        _updateUser = updateUser,
        super(const AuthenticationInitial());

  final ForgotPassword _forgotPassword;
  final SignIn _signIn;
  final SignUp _signUp;
  final UpdateUser _updateUser;

  Future<void> forgotPassword({required String email}) async {
    emit(const AuthenticationLoading());
    final result = await _forgotPassword(email);
    result.fold(
      (failure) => emit(AuthenticationError(failure.message)),
      (_) => emit(const ForgotPasswordSent()),
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthenticationLoading());

    final result =
        await _signIn(SignInParams(email: email, password: password));
    result.fold(
      (failure) => emit(AuthenticationError(failure.message)),
      (user) => emit(SignedIn(user)),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(const AuthenticationLoading());

    final result = await _signUp(
      SignUpParams(
        email: email,
        password: password,
        fullName: fullName,
      ),
    );
    result.fold(
      (failure) => emit(AuthenticationError(failure.message)),
      (user) => emit(const SignedUp()),
    );
  }

  Future<void> updateUser({
    required UpdateUserAction action,
    required String userData,
  }) async {
    emit(const AuthenticationLoading());

    final result = await _updateUser(
      UpdateUserParams(
        action: action,
        userData: userData,
      ),
    );
    result.fold(
      (failure) => emit(AuthenticationError(failure.message)),
      (user) => emit(const UserUpdated()),
    );
  }
}
