import 'package:flutter/material.dart';

class SettingUserIdPage extends StatefulWidget {
  @override
  _SettingUserIdPageState createState() => _SettingUserIdPageState();
}

class _SettingUserIdPageState extends State<SettingUserIdPage> {
  final TextEditingController _idController = TextEditingController();
  bool _isIdSearchAllowed = false;
  bool _isIdSet = false; // ID가 설정되었는지의 여부를 추적

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('유저 아이디 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'ID',
                hintText: '설정할 ID를 입력하세요',
                border: OutlineInputBorder(),
                // ID가 설정되면 텍스트 필드를 비활성화
                enabled: !_isIdSet,
              ),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('상대방이 내 ID로 검색 허용'),
              value: _isIdSearchAllowed,
              onChanged: _isIdSet
                  ? null // ID가 설정되면 스위치를 비활성화
                  : (bool value) {
                      setState(() {
                        _isIdSearchAllowed = value;
                      });
                    },
            ),
            SizedBox(height: 20),
            Text('ID는 변경 후에는 수정할 수 없습니다.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isIdSet
                  ? null // ID가 이미 설정되었다면 버튼 비활성화
                  : () {
                      // ID 설정 로직 추가 (예: 서버에 저장)
                      setState(() {
                        _isIdSet = true; // ID 설정 완료
                      });
                    },
              child: Text('ID 설정'),
            ),
          ],
        ),
      ),
    );
  }
}
