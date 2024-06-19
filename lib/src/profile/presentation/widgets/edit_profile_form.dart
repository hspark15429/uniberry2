import 'package:flutter/material.dart';
import 'package:uniberry/src/auth/domain/entities/user.dart';
import 'package:uniberry/src/profile/presentation/widgets/edit_profile_form_field.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    required this.fullNameController,
    required this.user,
    super.key,
  });

  final TextEditingController fullNameController;
  final LocalUser user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditProfileFormField(
          controller: fullNameController,
          hintText: user.fullName,
          fieldTitle: 'FULL NAME',
        ),
      ],
    );
  }
}
