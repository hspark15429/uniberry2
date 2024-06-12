import 'package:flutter/material.dart';

class ChatMenuSettingPage extends StatelessWidget {
  const ChatMenuSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅 설정'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 대화 상대 추가
            ListTile(
              title: const Text('대화 상대 추가'),
              // 대화 상대 추가 기능 구현
              trailing: IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () {
                  // 대화 상대 추가 기능 구현
                },
              ),
            ),
            const Divider(),
            // 알림 설정
            ListTile(
              title: const Text('알림 설정'),
              // 알림 설정 기능 구현
              trailing: Switch(
                value: true, // 알림 설정이 켜져 있는지 여부
                onChanged: (value) {
                  // 알림 설정 변경 기능 구현
                },
              ),
            ),
            const Divider(),
            // 대화창 배경 설정
            ListTile(
              title: const Text('대화창 배경 설정'),
              // 대화창 배경 설정 기능 구현
              trailing: IconButton(
                icon: const Icon(Icons.palette),
                onPressed: () {
                  // 대화창 배경 설정 페이지로 이동
                },
              ),
            ),
            const Divider(),
            // 채팅 기록 삭제 (볼트체 + 빨간 글씨)
            ListTile(
              title: const Text(
                '채팅 기록 삭제',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              // 채팅 기록 삭제 기능 구현
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // 채팅 기록 삭제 기능 구현
                },
              ),
            ),
            const Divider(),
            // 차단
            ListTile(
              title: const Text('차단'),
              // 차단 기능 구현
              trailing: IconButton(
                icon: const Icon(Icons.block),
                onPressed: () {
                  // 차단 기능 구현
                },
              ),
            ),
            const Divider(),
            // 신고
            ListTile(
              title: const Text('신고'),
              // 신고 기능 구현
              trailing: IconButton(
                icon: const Icon(Icons.report),
                onPressed: () {
                  // 신고 기능 구현
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
