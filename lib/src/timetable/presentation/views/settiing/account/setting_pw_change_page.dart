import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPwChangePage extends StatefulWidget {
  @override
  _SettingPwChangePageState createState() => _SettingPwChangePageState();
}

class _SettingPwChangePageState extends State<SettingPwChangePage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();
  late TapGestureRecognizer _tapGestureRecognizer; // 여기에 추가

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        // 탭 액션 구현, 예: 비밀번호 복구 페이지로 이동
        print('비밀번호 복구 페이지로 이동');
      };
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    _tapGestureRecognizer.dispose(); // 여기에 추가
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 변경'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '현재 비밀번호',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(
                hintText: '현재 비밀번호',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
RichText(
  text: TextSpan(
    style: TextStyle(fontSize: 12, color: Colors.black),
    children: <TextSpan>[
      TextSpan(
        text: '*현재 비밀번호가 기억이 나지 않는 경우, ',
        style: TextStyle(color: Colors.grey),
      ),
     TextSpan(
        text: '여기',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        recognizer: TapGestureRecognizer()..onTap = () {
          // 액션 구현: 탐색, 대화상자 표시 등
          print('비밀번호 복구 액션');
          // 예를 들어, 웹 링크를 여는 경우:
          launch('https://yourpasswordrecoverylink.com');
        },
      ),
      TextSpan(
        text: '를 클릭하세요.',
        style: TextStyle(color: Colors.grey),
      ),
    ],
  ),
),


            SizedBox(height: 20),
            Text(
              '새 비밀번호',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                hintText: '새 비밀번호',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _confirmNewPasswordController,
              decoration: InputDecoration(
                hintText: '새 비밀번호 재확인',
              ),
              obscureText: true,
            ),
            Text(
              '영문, 숫자, 특수 문자를 포함한 8자~20자 이내로 작성하세요.',
              style: TextStyle(color: Colors.grey),
            ),
           SizedBox(height: 20),
RichText(
  text: TextSpan(
    style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12), // 기본 텍스트 스타일에 폰트 사이즈 12 적용
    children: <TextSpan>[
      TextSpan(
        text: '※주의 사항\n1. 유니베리의 이용약관에 따라 타인 및 제 3자에게 계정 양도 및 대여는 엄격하게 금지하고 있습니다. 모니터링 시스템을 통해 계정 양도 및 대여가 적발될 경우 해당 계정은 영구 정지, 탈퇴 등의 조치가 가해지며, 계정 양도로 인한 ',
        style: TextStyle(color: Colors.grey)
      ),
      TextSpan(
        text: '불법 행위가 발생할 경우 관련법에 의거하여 법적 처벌을 받을 수 있습니다.',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 12), // 볼드체, 빨간색, 폰트 사이즈 12 적용
      ),
    ],
  ),
),


            SizedBox(height: 20),
           ElevatedButton(
  onPressed: () {
    // 현재 비밀번호가 입력되지 않은 경우
    if (_currentPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('현재 비밀번호를 입력해주세요.')),
      );
    }
    // 새 비밀번호와 새 비밀번호 재확인이 일치하지 않는 경우
    else if (_newPasswordController.text != _confirmNewPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('새 비밀번호가 일치하지 않습니다.')),
      );
    }
    // 모든 조건을 만족하는 경우 (여기에 비밀번호 변경 로직을 구현)
    else {
      // 비밀번호 변경 로직
      print('비밀번호 변경 로직 실행');
      // 예: 서버에 비밀번호 변경 요청 보내기
    }
  },
  child: Text('비밀번호 변경'),
),

          ],
        ),
      ),
    );
  }
}

