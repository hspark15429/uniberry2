import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentIDCardBackPage extends StatefulWidget {
  const StudentIDCardBackPage({required this.enrollmentDate, super.key});
  final String enrollmentDate;

  @override
  _StudentIDCardBackPageState createState() => _StudentIDCardBackPageState();
}

class _StudentIDCardBackPageState extends State<StudentIDCardBackPage> {
  String studentName = '';
  String studentNumber = '';
  String department = '';
  String enrollmentDate = '';

  @override
  void initState() {
    super.initState();
    _loadStudentInfo();
  }

  Future<void> _loadStudentInfo() async {
    const filePath =
        '/Users/jjpark/dev/uniberry/assets/studentDB(PARK Jaejin).json';
    final file = File(filePath);
    if (await file.exists()) {
      final content = await file.readAsString();
      _parseStudentInfo(content);
    } else {
      debugPrint('파일을 찾을 수 없습니다.');
    }
  }

  void _parseStudentInfo(String content) {
    try {
      final jsonData = jsonDecode(content);

      studentName = jsonData['氏名'] as String? ?? '';
      studentNumber = jsonData['学籍番号'] as String? ?? '';
      department = jsonData['学部'] as String? ?? '';
      final fullEnrollmentDate = jsonData['入学年度'] as String? ?? '';

      final splitDate = fullEnrollmentDate.split('年');
      var yearString = splitDate[0].trim();
      enrollmentDate = yearString;

      setState(() {});
    } catch (e) {
      debugPrint('학생 정보 파싱 중 오류 발생: $e');
    }
  }

  void _showLargeQRCode() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Image.asset(
              '/Users/jjpark/dev/uniberry/assets/qrcodeex.png',
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  String calculateExpirationDate(String enrollmentDate) {
    final admissionYear = int.tryParse(enrollmentDate) ?? 0;
    final expirationYear = admissionYear + 4;
    final expirationDate = DateTime(expirationYear, 3, 31);
    return '${expirationDate.year}年 ${expirationDate.month}月 ${expirationDate.day}日';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: screenWidth * 0.85,
            height: screenHeight * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF7E1951), Color(0xFFD62F5E)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'R',
                        style: TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '立命館大学',
                        style: GoogleFonts.yujiMai(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 70),
                GestureDetector(
                  onTap: _showLargeQRCode,
                  child: Container(
                    width: 140,
                    height: 140, // 크게 만듭니다.
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), // 모양을 둥글게 합니다.
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      '/Users/jjpark/dev/uniberry/assets/qrcodeex.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '学生認証コードは５分間有効です。',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      '氏名: $studentName',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '学籍番号: $studentNumber',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '学部: $department',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '有効期限: ${calculateExpirationDate(enrollmentDate)}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}