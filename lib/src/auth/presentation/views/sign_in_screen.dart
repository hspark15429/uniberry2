import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/core/common/widgets/gradient_background.dart';
import 'package:uniberry2/core/common/widgets/rounded_button.dart';
import 'package:uniberry2/core/providers/user_provider.dart';
import 'package:uniberry2/core/res/res.dart';
import 'package:uniberry2/core/utils/core_utils.dart';
import 'package:uniberry2/src/auth/presentation/cubit/authentication_cubit.dart';
import 'package:uniberry2/src/auth/presentation/utils/authentication_heroes.dart';
import 'package:uniberry2/src/auth/presentation/views/sign_up_screen.dart';
import 'package:uniberry2/src/auth/presentation/widgets/sign_in_form.dart';
import 'package:uniberry2/src/dashboard/presentation/views/dashboard_screen.dart';

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
      appBar: AppBar(),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedIn) {
            context.read<UserProvider>().initUser(state.user);
            Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
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
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Hero(
                          tag: AuthenticationHeroes.helperText,
                          child: Text(
                            'Sign in to your account',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Baseline(
                          baseline: 100,
                          baselineType: TextBaseline.alphabetic,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                SignUpScreen.routeName,
                              );
                            },
                            child: const Text('Register account?'),
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
                        child: const Text('Forgot password?'),
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
                              label: 'Sign In',
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
