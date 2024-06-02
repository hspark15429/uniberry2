import 'package:flutter/material.dart';

class SettingEmailChangePage extends StatefulWidget {
  @override
  _SettingEmailChangePageState createState() => _SettingEmailChangePageState();
}

class _SettingEmailChangePageState extends State<SettingEmailChangePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이메일 변경'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이메일',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: '본인의 이메일 입력',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            Text(
              '계정 비밀번호',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: '계정 비밀번호',
              ),
              obscureText: true, // 비밀번호를 숨김 처리
            ),
            SizedBox(height: 20),
            Text(
              '※반드시 본인의 이메일을 입력해주세요.\n※계정 분실 시 아이디/비밀번호 찾기, 개인정보 관련 주요 고지사항 안내 등에 사용됩니다.',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
  onPressed: () {
    // 이메일 입력하지 않은 경우
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일을 입력해주세요.')),
      );
    }
    // 비밀번호를 입력하지 않은 경우
    else if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('계정 비밀번호를 입력해주세요.')),
      );
    }
    // 모든 조건을 만족하는 경우 (이메일 변경 로직 구현)
    else {
      // 이메일 변경 로직
      print('이메일 변경 로직 실행');
      // 예: 서버에 이메일 변경 요청 보내기
    }
  },
  child: Text('이메일 변경'),
),

          ],
        ),
      ),
    );
  }
}
