import 'dart:io';

import 'package:flutter/material.dart';

class Postwritepage extends StatelessWidget {
const Postwritepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: DropdownButton<String>(
          value: '게시물 작성',
          dropdownColor: Colors.black,
          items: ['게시물 작성', '설문조사 작성'].map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: null,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                hintText: '카테고리 선택',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onChanged: null,
              items: ['자유', '공지사항', '질문'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '제목',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: '내용',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File('dummy_image_path')),
              ),
            ),
            Wrap(
              spacing: 10,
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.black),
                  onPressed: null,
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.black),
                  onPressed: null,
                ),
                IconButton(
                  icon: const Icon(Icons.location_on, color: Colors.black),
                  onPressed: null,
                ),
                IconButton(
                  icon: const Icon(Icons.poll, color: Colors.black),
                  onPressed: null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: null,
              child: const Text('미리보기', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: null,
              child: const Text('게시물 작성', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
