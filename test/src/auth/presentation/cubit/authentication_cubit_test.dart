import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry/core/enums/update_user_enum.dart';
import 'package:uniberry/core/errors/failures.dart';
import 'package:uniberry/src/auth/data/models/user_model.dart';
import 'package:uniberry/src/auth/domain/usecases/forgot_password.dart';
import 'package:uniberry/src/auth/domain/usecases/sign_in.dart';
import 'package:uniberry/src/auth/domain/usecases/sign_up.dart';
import 'package:uniberry/src/auth/domain/usecases/update_user.dart';
import 'package:uniberry/src/auth/presentation/cubit/authentication_cubit.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late MockSignIn signIn;
  late MockSignUp signUp;
  late MockForgotPassword forgotPassword;
  late MockUpdateUser updateUser;
  late AuthenticationCubit cubit;

  const tPassword = 'password';
  const tEmail = 'email';
  const tFullName = 'fullName';
  const tUpdateUserAction = UpdateUserAction.password;
  const tUpdateUserParams = UpdateUserParams(
    action: tUpdateUserAction,
    userData: tPassword,
  );
  const tSignUpParams = SignUpParams(
    email: tEmail,
    password: tPassword,
    fullName: tFullName,
  );
  const tSignInParams = SignInParams(
    email: tEmail,
    password: tPassword,
  );

  setUpAll(() {
    registerFallbackValue(tUpdateUserParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tSignInParams);
  });

  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    forgotPassword = MockForgotPassword();
    updateUser = MockUpdateUser();
    cubit = AuthenticationCubit(
      signIn: signIn,
      signUp: signUp,
      forgotPassword: forgotPassword,
      updateUser: updateUser,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test(
    'initialState should be AuthInitial',
    () async {
      expect(cubit.state, const AuthenticationInitial());
    },
  );

  final tServerFailure = ServerFailure(
    statusCode: 'user-not-found',
    message: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted.',
  );

  group('signIn', () {
    const tUser = LocalUserModel.empty();
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [AuthLoading, SignedIn] when SignIn succeeds',
      build: () {
        when(() => signIn(any())).thenAnswer(
          (_) async => const Right(tUser),
        );
        return cubit;
      },
      act: (cubit) => cubit.signIn(email: tEmail, password: tPassword),
      expect: () => [
        const AuthenticationLoading(),
        const SignedIn(tUser),
      ],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [AuthenticationLoading, ForgotPasswordSent] when '
      'ForgotPassword succeeds',
      build: () {
        when(() => signIn(any())).thenAnswer(
          (_) async => Left(tServerFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.signIn(email: tEmail, password: tPassword),
      expect: () => [
        const AuthenticationLoading(),
        AuthenticationError(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
  });

  group('forgotPassword', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [AuthenticationLoading, ForgotPasswordSent] when '
      'ForgotPassword succeeds',
      build: () {
        when(() => forgotPassword(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return cubit;
      },
      act: (cubit) => cubit.forgotPassword(email: tEmail),
      expect: () => [
        const AuthenticationLoading(),
        const ForgotPasswordSent(),
      ],
      verify: (_) {
        verify(() => forgotPassword(tEmail)).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [AuthenticationLoading, AuthenticationError] when '
      'ForgotPassword fails',
      build: () {
        when(() => forgotPassword(any())).thenAnswer(
          (_) async => Left(tServerFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.forgotPassword(email: tEmail),
      expect: () => [
        const AuthenticationLoading(),
        AuthenticationError(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => forgotPassword(tEmail)).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });

  group('signUp', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [AuthenticationLoading, SignedUp] when SignUp succeeds',
      build: () {
        when(() => signUp(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return cubit;
      },
      act: (cubit) => cubit.signUp(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
      expect: () => [
        const AuthenticationLoading(),
        const SignedUp(),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [AuthenticationLoading, AuthenticationError] when '
      'SignUp fails',
      build: () {
        when(() => signUp(any())).thenAnswer(
          (_) async => Left(tServerFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.signUp(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
      expect: () => [
        const AuthenticationLoading(),
        AuthenticationError(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
  });

  group('updateUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [AuthenticationLoading, UserUpdated] when UpdateUser succeeds',
      build: () {
        when(() => updateUser(any())).thenAnswer(
          (_) async => const Right(null),
        );
        return cubit;
      },
      act: (cubit) => cubit.updateUser(
        action: tUpdateUserAction,
        userData: tPassword,
      ),
      expect: () => [
        const AuthenticationLoading(),
        const UserUpdated(),
      ],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [AuthenticationLoading, AuthenticationError] when '
      'UpdateUser fails',
      build: () {
        when(() => updateUser(any())).thenAnswer(
          (_) async => Left(tServerFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.updateUser(
        action: tUpdateUserAction,
        userData: tPassword,
      ),
      expect: () => [
        const AuthenticationLoading(),
        AuthenticationError(tServerFailure.message),
      ],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
