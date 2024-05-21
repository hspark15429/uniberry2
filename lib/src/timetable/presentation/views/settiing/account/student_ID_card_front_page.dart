import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentIDCardFrontPage extends StatefulWidget {
  const StudentIDCardFrontPage({Key? key}) : super(key: key);

  @override
  _StudentIDCardFrontPageState createState() => _StudentIDCardFrontPageState();
}

class _StudentIDCardFrontPageState extends State<StudentIDCardFrontPage> {
  String studentName = '';
  String studentNumber = '';
  String department = '';
  String enrollmentDate = '';

  @override
  void initState() {
    super.initState();
    _loadStudentInfo();
  }

  void _loadStudentInfo() async {
    String filePath = '/Users/jjpark/dev/uniberry/assets/studentDB(PARK Jaejin).json';
    File file = File(filePath);
    if (await file.exists()) {
      String content = await file.readAsString();
      _parseStudentInfo(content);
    } else {
      debugPrint("파일을 찾을 수 없습니다.");
    }
  }

  void _parseStudentInfo(String content) {
    try {
      var jsonData = jsonDecode(content);
      studentName = jsonData['氏名'] ?? '';
      studentNumber = jsonData['学籍番号'] ?? '';
      department = jsonData['学部'] ?? '';
      enrollmentDate = jsonData['入学年度'] ?? '';
      setState(() {});
    } catch (e) {
      debugPrint("학생 정보 파싱 중 오류 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Card(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: screenWidth * 0.85,
            height: screenHeight * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF7E1951), Color(0xFFD62F5E)],
              ),
            ),
            child: Stack(
              children: [
                SchoolLogoSection(), // 학교 로고 및 학교명 섹션
                SchoolImageSection(), // 학교 사진 섹션
                StudentPhotoSection(), // 학생 사진 섹션
                StudentInfoSection( // 학생 정보 섹션
                  studentName: studentName,
                  studentNumber: studentNumber,
                  department: department,
                  enrollmentDate: enrollmentDate,
                ),
                AdditionalInfoSection(), // 추가 정보 섹션
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class SchoolLogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 가로 정렬을 중앙으로 변경
        children: [
          Text(
            "R",
            style: TextStyle(
              fontSize: 54,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(width: 10),
          Text(
            "立命館大学",
            style: GoogleFonts.yujiMai(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}


class SchoolImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 120,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: 1,
        child: Image.asset(
          '/Users/jjpark/dev/uniberry/assets/school1.png',
          fit: BoxFit.cover,
          height: 180,
        ),
      ),
    );
  }
}

class StudentPhotoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      top: 250,
      left: (screenWidth * 0.85 - 120) / 2,
      child: CircleAvatar(
        radius: 60,
        backgroundImage: AssetImage('/Users/jjpark/dev/uniberry/assets/PARKJAEJIN.jpg'),
      ),
    );
  }
}

class StudentInfoSection extends StatelessWidget {
  final String studentName;
  final String studentNumber;
  final String department;
  final String enrollmentDate;

  StudentInfoSection({
    required this.studentName,
    required this.studentNumber,
    required this.department,
    required this.enrollmentDate,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 370,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "氏名: $studentName",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "学籍番号: $studentNumber",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Text(
            "学部: $department",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Text(
            "入学年度: $enrollmentDate",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class AdditionalInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 510,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            "京都府京都市北区等持院北町56-1",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            "京都府京都市中京区西ノ京朱雀町１",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            "滋賀県草津市野路東1丁目1-1",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            "大阪府茨木市岩倉町2-150",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
