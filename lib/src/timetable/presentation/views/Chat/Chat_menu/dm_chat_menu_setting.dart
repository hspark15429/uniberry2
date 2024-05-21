import 'package:flutter/material.dart';

class ChatMenuSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅 설정'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 대화 상대 추가
            ListTile(
              title: Text('대화 상대 추가'),
              // 대화 상대 추가 기능 구현
              trailing: IconButton(
                icon: Icon(Icons.person_add),
                onPressed: () {
                  // 대화 상대 추가 기능 구현
                },
              ),
            ),
            Divider(),
            // 알림 설정
            ListTile(
              title: Text('알림 설정'),
              // 알림 설정 기능 구현
              trailing: Switch(
                value: true, // 알림 설정이 켜져 있는지 여부
                onChanged: (value) {
                  // 알림 설정 변경 기능 구현
                },
              ),
            ),
            Divider(),
            // 대화창 배경 설정
            ListTile(
              title: Text('대화창 배경 설정'),
              // 대화창 배경 설정 기능 구현
              trailing: IconButton(
                icon: Icon(Icons.palette),
                onPressed: () {
                  // 대화창 배경 설정 페이지로 이동
                },
              ),
            ),
            Divider(),
            // 채팅 기록 삭제 (볼트체 + 빨간 글씨)
            ListTile(
              title: Text(
                '채팅 기록 삭제',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              // 채팅 기록 삭제 기능 구현
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // 채팅 기록 삭제 기능 구현
                },
              ),
            ),
            Divider(),
            // 차단
            ListTile(
              title: Text('차단'),
              // 차단 기능 구현
              trailing: IconButton(
                icon: Icon(Icons.block),
                onPressed: () {
                  // 차단 기능 구현
                },
              ),
            ),
            Divider(),
            // 신고
            ListTile(
              title: Text('신고'),
              // 신고 기능 구현
              trailing: IconButton(
                icon: Icon(Icons.report),
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
