import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniberry/core/common/widgets/i_field.dart';
import 'package:uniberry/core/utils/constants.dart';

class AddPostForm extends StatefulWidget {
  const AddPostForm({
    required this.titleController,
    required this.contentController,
    required this.linkController,
    required this.formKey,
    required this.imageController,
    required this.tagController,
    required this.typeController,
    super.key,
  });

  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextEditingController linkController;
  final ValueNotifier<dynamic> imageController;
  final ValueNotifier<int> tagController;
  final ValueNotifier<int> typeController;
  final GlobalKey<FormState> formKey;

  @override
  State<AddPostForm> createState() => _AddPostFormState();
}

class _AddPostFormState extends State<AddPostForm> {
  late List<String> tags;
  late List<String> types;
  late String pickedImagePath = '';

  File? pickedImage;

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        widget.contentController.value = TextEditingValue(
          text: image.path,
        );
        widget.imageController.value = File(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tags = kPostTags;
    types = kPostTypes;
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
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: types.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FilterChip(
                    label: Text(
                      types[index],
                      style: TextStyle(
                        color: widget.typeController.value == index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    selected: widget.typeController.value == index,
                    selectedColor: Colors.black,
                    backgroundColor: Colors.white,
                    onSelected: (bool selected) {
                      setState(() {
                        widget.typeController.value = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 5),
          if (widget.typeController.value == 0)
            IField(
              controller: widget.contentController,
              hintText: 'Content',
              textStyle: const TextStyle(color: Colors.black),
              maxlines: 15,
              filled: true,
              fillColour: Colors.white, // 입력 필드 배경색을 흰색으로 설정
            ),
          if (widget.typeController.value == 1) ...[
            if (widget.imageController.value != null)
              Image.file(
                widget.imageController.value as File,
                height: 200,
                width: 200,
              ),
            Center(
              child: IconButton(
                onPressed: pickImage,
                icon: Icon(
                  (pickedImage != null) ? Icons.edit : Icons.add_a_photo,
                  color: Colors.black,
                ),
              ),
            ),
          ],
          if (widget.typeController.value == 2)
            IField(
              controller: widget.linkController,
              hintText: 'Link URL',
              textStyle: const TextStyle(color: Colors.black),
              filled: true,
              fillColour: Colors.white, // 입력 필드 배경색을 흰색으로 설정
              keyboardType: TextInputType.url,
              overrideValidator: true,
              validator: (value) {
                if (value!.startsWith('http://') ||
                    value.startsWith('https://')) {
                  return null;
                }
                return 'Invalid URL';
              },
            ),
        ],
      ),
    );
  }
}
