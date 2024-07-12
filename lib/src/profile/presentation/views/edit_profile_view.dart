import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniberry/core/common/providers/tab_navigator.dart';
import 'package:uniberry/core/common/widgets/title_text.dart';
import 'package:uniberry/core/enums/update_user_enum.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/core/utils/core_utils.dart';
import 'package:uniberry/src/auth/domain/entities/user.dart';
import 'package:uniberry/src/auth/presentation/cubit/authentication_cubit.dart';
import 'package:uniberry/src/profile/presentation/widgets/edit_profile_form.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final auth = FirebaseAuth.instance;

  final fullNameController = TextEditingController();

  late LocalUser user;

  bool get nameChanged =>
      user.fullName.trim() != fullNameController.text.trim();

  bool get nothingChanged =>
      user.fullName.trim() == fullNameController.text.trim();

  @override
  void initState() {
    user = context.read<UserProvider>().user!;
    fullNameController.text = user.fullName.trim();
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          CoreUtils.showSnackBar(context, '変更内容が更新されました。');
          context.read<TabNavigator>().pop();
        } else if (state is AuthenticationError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (_, state) {
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                context.read<TabNavigator>().pop();
              },
            ),
            title: const TitleText(text: 'ニックネーム変更'),
            actions: [
              IconButton(
                icon: state is AuthenticationLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : StatefulBuilder(
                        builder: (_, refresh) {
                          // add listeners for the controllers and refresh
                          fullNameController.addListener(() => refresh(() {}));
                          return Icon(
                            Icons.check,
                            color: nothingChanged ? Colors.grey : Colors.white,
                          );
                        },
                      ),
                onPressed: () {
                  context.read<AuthenticationCubit>().updateUser(
                        action: UpdateUserAction.displayName,
                        userData: fullNameController.text.trim(),
                      );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              EditProfileForm(
                fullNameController: fullNameController,
                user: user,
              ),
              Center(
                child: SizedBox(
                  width: 170,
                  child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthenticationCubit>().updateUser(
                              action: UpdateUserAction.blockedUids,
                              userData: List<String>.empty(),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                      ),
                      child: const Text('ブロック一括解除')),
                ),
              ),
              FirebaseUIActions(
                actions: [
                  AccountDeletedAction((context, user) async {
                    // Do something after the account is deleted.
                    await sl<SharedPreferences>().clear();
                    await auth.signOut();

                    CoreUtils.showSnackBar(context, 'アカウントが削除されました');
                    unawaited(
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      ),
                    );
                  }),
                ],
                child: Center(
                  child: DeleteAccountButton(
                    auth: auth,
                    showDeleteConfirmationDialog: true,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
