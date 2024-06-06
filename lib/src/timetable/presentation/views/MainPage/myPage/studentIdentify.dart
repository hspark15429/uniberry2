import 'package:flutter/material.dart';

class StudentIdentifyPage extends StatefulWidget {
  final Function(String, String) updateStudentInfo;

  const StudentIdentifyPage({Key? key, required this.updateStudentInfo}) : super(key: key);

  @override
  _StudentIdentifyPageState createState() => _StudentIdentifyPageState();
}

class _StudentIdentifyPageState extends State<StudentIdentifyPage> {
  TextEditingController _studentIdController = TextEditingController();

  void _identifyStudent() {
    String studentId = _studentIdController.text;
    // 학부와 입학년도 추출 로직
    String facultyName = _getFacultyName(studentId);
    String admissionYear = _getAdmissionYear(studentId);

    // 업데이트 함수 호출
    widget.updateStudentInfo(facultyName, admissionYear);
    Navigator.of(context).pop();
  }

  String _getFacultyName(String studentId) {
    Map<String, String> facultyMapping = {
      '11': '法学部',
      '12': '経済学部',
      '13': '経営学部',
      '14': '産業社会学部',
      '15': '国際関係学部',
      '16': '文学部',
      '17': '文学部',
      '18': '政策科学部',
      '19': '映像学部',
      '20': '総合心理学部',
      '21': '理工学部',
      '22': '理工学部',
      '23': '理工学部',
      '24': '欠番',
      '25': '食マネジメント学部',
      '26': '情報理工学部',
      '27': '生命科学部',
      '28': '薬学部',
      '29': 'スポーツ健康科学部',
    };
    String facultyCode = studentId.substring(0, 2);
    return facultyMapping[facultyCode] ?? '不明';
  }

  String _getAdmissionYear(String studentId) {
    // 임의의 로직으로 입학년도 추출
    return "2020年 04月 01日";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('학생증 인증'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _studentIdController,
              decoration: InputDecoration(labelText: '학생증 번호를 입력하세요'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _identifyStudent,
              child: Text('인증하기'),
            ),
          ],
        ),
      ),
    );
  }
}
