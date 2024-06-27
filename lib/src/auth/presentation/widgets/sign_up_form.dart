import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:uniberry/core/common/widgets/i_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
    required this.fullNameController,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController fullNameController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            controller: widget.fullNameController,
            hintText: 'ニックネーム',
            fillColour: Colors.grey.withOpacity(0.2),
            prefixIcon: const Icon(Icons.perm_identity, color: Colors.black),
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 25),
          IField(
            controller: widget.emailController,
            hintText: '大学のメールアドレス',
            fillColour: Colors.grey.withOpacity(0.2),
            prefixIcon: const Icon(Icons.mail_outline, color: Colors.black),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'メールアドレスを入力してください';
              } else if (!value.contains('@ed.ritsumei.ac.jp')) {
                return '学校のメールアドレスである必要があります';
              }
              return null;
            },
          ),
          const SizedBox(height: 25),
          IField(
            controller: widget.passwordController,
            hintText: 'パスワード',
            fillColour: Colors.grey.withOpacity(0.2),
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
            obscureText: obscurePassword,
            keyboardType: TextInputType.visiblePassword,
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
          const SizedBox(height: 25),
          IField(
            controller: widget.confirmPasswordController,
            hintText: 'パスワード再確認',
            fillColour: Colors.grey.withOpacity(0.2),
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
            obscureText: obscureConfirmPassword,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureConfirmPassword = !obscureConfirmPassword;
                });
              },
              icon: Icon(
                obscureConfirmPassword ? IconlyLight.show : IconlyLight.hide,
                color: Colors.grey,
              ),
            ),
            validator: (value) {
              if (value != widget.passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
