import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry/core/common/widgets/gradient_background.dart';
import 'package:uniberry/core/common/widgets/rounded_button.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/res/res.dart';
import 'package:uniberry/core/utils/constants.dart';
import 'package:uniberry/core/utils/core_utils.dart';
import 'package:uniberry/src/auth/presentation/cubit/authentication_cubit.dart';
import 'package:uniberry/src/auth/presentation/utils/authentication_heroes.dart';
import 'package:uniberry/src/auth/presentation/views/sign_in_screen.dart';
import 'package:uniberry/src/auth/presentation/widgets/sign_up_form.dart';
import 'package:uniberry/src/dashboard/presentation/views/dashboard.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedUp) {
            context.read<AuthenticationCubit>().signIn(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
          } else if (state is SignedIn) {
            context.read<UserProvider>().initUser(state.user);
            Navigator.pushReplacementNamed(context, '/');
          }
        },
        builder: (context, state) {
          return GradientBackground(
            image: Res.authGradientBackground,
            child: SafeArea(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const Hero(
                      tag: AuthenticationHeroes.pageTitle,
                      child: Padding(
                        padding: EdgeInsets.only(right: 80),
                        child: Text(
                          'はじめまして',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 52,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Hero(
                      tag: AuthenticationHeroes.helperText,
                      child: Text(
                        'アカウントを作成する',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Hero(
                      tag: AuthenticationHeroes.redirectText,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              SignInScreen.routeName,
                            );
                          },
                          child: const Text('既にアカウントをお持ちですか?'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SignUpForm(
                      emailController: emailController,
                      passwordController: passwordController,
                      fullNameController: fullNameController,
                      confirmPasswordController: confirmPasswordController,
                      formKey: formKey,
                    ),
                    const SizedBox(height: 30),
                    Hero(
                      tag: AuthenticationHeroes.authButton,
                      child: state is AuthenticationLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : RoundedButton(
                              label: '会員登録',
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthenticationCubit>().signUp(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                        fullName:
                                            fullNameController.text.trim(),
                                      );
                                }
                              },
                            ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'アカウントを作成することにより、',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: '利用規約 (EULA)',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                CoreUtils.launchWebpage(
                                  Uri.parse(kTermsOfUseWebUrl),
                                );
                              },
                          ),
                          const TextSpan(
                            text: ' および ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: 'プライバシーポリシー',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                CoreUtils.launchWebpage(
                                  Uri.parse(kPrivacyWebUrl),
                                );
                              },
                          ),
                          const TextSpan(
                            text: 'ポリシーに同意したことになります。',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
