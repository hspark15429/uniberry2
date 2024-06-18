import 'package:flutter/material.dart';
import 'package:uniberry2/core/common/widgets/i_field.dart';
import 'package:uniberry2/core/utils/constants.dart';

class AddPostForm extends StatefulWidget {
  const AddPostForm({
    required this.titleController,
    required this.contentController,
    required this.formKey,
    required this.tagController,
    super.key,
  });

  final TextEditingController titleController;
  final TextEditingController contentController;
  final ValueNotifier<int> tagController;
  final GlobalKey<FormState> formKey;

  @override
  State<AddPostForm> createState() => _AddPostFormState();
}

class _AddPostFormState extends State<AddPostForm> {
  late List<String> tags;

  @override
  void initState() {
    super.initState();
    tags = kPostTags;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            controller: widget.titleController,
            hintText: 'Title',
            textStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColour: Colors.white, // 입력 필드 배경색을 흰색으로 설정
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tags.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FilterChip(
                    label: Text(
                      tags[index],
                      style: TextStyle(
                        color: widget.tagController.value == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: widget.tagController.value == index,
                    selectedColor: Colors.black,
                    backgroundColor: Colors.white,
                    onSelected: (bool selected) {
                      setState(() {
                        widget.tagController.value = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 5),
          IField(
            controller: widget.contentController,
            hintText: 'Content',
            textStyle: const TextStyle(color: Colors.black),
            maxlines: 15,
            filled: true,
            fillColour: Colors.white, // 입력 필드 배경색을 흰색으로 설정
          ),
        ],
      ),
    );
  }
}