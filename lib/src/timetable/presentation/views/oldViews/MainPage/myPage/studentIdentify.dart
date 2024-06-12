import 'package:flutter/material.dart';

class StudentIdentifyPage extends StatefulWidget {

  const StudentIdentifyPage({required this.updateStudentInfo, super.key});
  final Function(String, String) updateStudentInfo;

  @override
  _StudentIdentifyPageState createState() => _StudentIdentifyPageState();
}

class _StudentIdentifyPageState extends State<StudentIdentifyPage> {
  final TextEditingController _studentIdController = TextEditingController();

  void _identifyStudent() {
    final studentId = _studentIdController.text;
    // 학부와 입학년도 추출 로직
    final facultyName = _getFacultyName(studentId);
    final admissionYear = _getAdmissionYear(studentId);

    // 업데이트 함수 호출
    widget.updateStudentInfo(facultyName, admissionYear);
    Navigator.of(context).pop();
  }

  String _getFacultyName(String studentId) {
    final facultyMapping = <String, String>{
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
    final facultyCode = studentId.substring(0, 2);
    return facultyMapping[facultyCode] ?? '不明';
  }

  String _getAdmissionYear(String studentId) {
    // 임의의 로직으로 입학년도 추출
    return '2020年 04月 01日';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학생증 인증'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _studentIdController,
              decoration: const InputDecoration(labelText: '학생증 번호를 입력하세요'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _identifyStudent,
              child: const Text('인증하기'),
            ),
          ],
        ),
      ),
    );
  }
}
