import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:uniberry/core/common/widgets/i_field.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            controller: widget.emailController,
            hintText: '大学のメールアドレス',
            fillColour: Colors.grey.withOpacity(0.2),
            prefixIcon: const Icon(Icons.mail_outline, color: Colors.black),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 25),
          IField(
            controller: widget.passwordController,
            hintText: 'パスワード',
            fillColour: Colors.grey.withOpacity(0.2),
            obscureText: obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword ? IconlyLight.show : IconlyLight.hide,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
