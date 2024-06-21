import 'package:flutter/material.dart';
import 'package:uniberry/core/common/widgets/i_field.dart';

class EditProfileFormField extends StatelessWidget {
  const EditProfileFormField({
    required this.controller,
    required this.hintText,
    required this.fieldTitle,
    this.readOnly = false,
    super.key,
  });

  final TextEditingController controller;
  final String? hintText;
  final String fieldTitle;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(fontWeight: FontWeight.w700, fontSize: 12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(fieldTitle, style: titleStyle),
        ),
        const SizedBox(height: 10),
        IField(controller: controller, hintText: hintText, readOnly: readOnly),
        const SizedBox(height: 30),
      ],
    );
  }
}
