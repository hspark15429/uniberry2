import 'package:flutter/material.dart';

class DMUserSearchPage extends StatelessWidget {
  const DMUserSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('유저 검색'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          decoration: const InputDecoration(
            hintText: '검색...',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            // 검색 로직을 여기에 구현
          },
        ),
      ),
    );
  }
}
