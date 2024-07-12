import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniberry/core/common/widgets/gradient_background.dart';
import 'package:uniberry/core/common/widgets/rounded_button.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/res/res.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/core/utils/core_utils.dart';
import 'package:uniberry/src/auth/presentation/cubit/authentication_cubit.dart';
import 'package:uniberry/src/auth/presentation/utils/authentication_heroes.dart';
import 'package:uniberry/src/auth/presentation/views/sign_up_screen.dart';
import 'package:uniberry/src/auth/presentation/widgets/sign_in_form.dart';
import 'package:uniberry/src/dashboard/presentation/views/dashboard.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) async {
          if (state is AuthenticationError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedIn) {
            context.read<UserProvider>().initUser(state.user);
            if (FirebaseAuth.instance.currentUser!.emailVerified) {
              unawaited(
                Navigator.pushReplacementNamed(context, Dashboard.routeName),
              );
            } else {
              CoreUtils.showSnackBar(
                context,
                'メールアドレスを確認してください',
              );
              await FirebaseAuth.instance.currentUser!.sendEmailVerification();
              await sl<SharedPreferences>().clear();
              await FirebaseAuth.instance.signOut();
              await Navigator.pushReplacementNamed(context, '/');
            }
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
                          'Welcome Back!',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 58,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Hero(
                          tag: AuthenticationHeroes.helperText,
                          child: Text(
                            '',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        Baseline(
                          baseline: 50,
                          baselineType: TextBaseline.alphabetic,
                          child: Hero(
                            tag: AuthenticationHeroes.redirectText,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  SignUpScreen.routeName,
                                );
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.person_add, // 계정 생성 아이콘
                                    size: 20,
                                  ),
                                  SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
                                  Text('アカウントを作成する'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SignInForm(
                      emailController: emailController,
                      passwordController: passwordController,
                      formKey: formKey,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: const Text('パスワード再設定'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Hero(
                      tag: AuthenticationHeroes.authButton,
                      child: state is AuthenticationLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : RoundedButton(
                              label: 'ログイン',
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                FirebaseAuth.instance.currentUser?.reload();
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthenticationCubit>().signIn(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                      );
                                }
                              },
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
