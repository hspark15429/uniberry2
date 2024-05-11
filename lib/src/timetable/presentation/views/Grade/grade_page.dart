import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/presentation/views/Grade/grade_table_page.dart';

import 'grade_chart_page.dart';
import 'grade_rate_chart_page.dart';

class GradePage extends StatefulWidget {
  const GradePage({super.key});

  @override
  _GradePageState createState() => _GradePageState();
}

class _GradePageState extends State<GradePage> {
  int selectedSemester = 1; // 학기 선택을 위한 상태
  static const double totalRequiredCredits = 124; // 필요한 총 학점
  static const double totalCompletedCredits = 63; // 완료한 총 학점
  static const double cultureCreditsRequired = 24; // 필요한 교양 학점
  static const double cultureCreditsCompleted = 24; // 완료한 교양 학점
  static const double foreignLanguageCreditsRequired = 12; // 필요한 외국어 학점
  static const double foreignLanguageCreditsCompleted = 12; // 완료한 외국어 학점
  static const double majorCreditsRequired = 68; // 필요한 전공 학점
  static const double majorCreditsCompleted = 28; // 완료한 전공 학점

  final List<Map<String, double>> semesterGPAList = [
    {"1S": 3.46},
    {"1A": 4.18},
    {"2S": 3.87},
    {"2A": 4.0},
    {"3S": 3.7},
    {"3A": 4.8},
    {"4S": 4.2},
    {"4A": 4.6},
    // 추가 학기 데이터...
  ];

  final List<String> semesterNames = [
    "1S", "1A", "2S", "2A", "3S", "3A", "4S", "4A", "5S", "5A", "6S", "6A",
  ];

  Widget _buildSemesterButtons() {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: semesterNames.length,
        itemBuilder: (BuildContext contex, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedSemester = index + 1;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: selectedSemester == index + 1 ? Colors.white : Colors.redAccent, backgroundColor: selectedSemester == index + 1 ? Colors.redAccent: null,
                side: const BorderSide(color: Colors.redAccent),
              ),
              child: Text(
                semesterNames[index],
                style: TextStyle(
                  color: selectedSemester == index + 1 ? Colors.white : Colors.redAccent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGpaAndCreditsText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "累積GPA: 4.2/5.0",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          "取得単位: 76/124",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
  title: const Text('学期別履修状況', style: TextStyle(color: Colors.white)),
  backgroundColor: const Color(0xFFFF6B6B), // 코랄 색상을 RGB 코드로 정의
  iconTheme: const IconThemeData(
    color: Colors.white, // 여기에서 아이콘 색상을 하얀색으로 설정
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.help_outline),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("SとAの意味"),
              content: const Text("Sは春学期、Aは秋学期を意味します。　　　　　　　　　　　　　ex) 1S = 1年生の春学期, 1A = 1年生の秋学期"),
              actions: <Widget>[
                TextButton(
                  child: const Text("닫기"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    ),
  ],
),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSemesterButtons(),
          const SizedBox(height: 20),
          _buildGpaAndCreditsText(),
          const SizedBox(height: 20),
          GradeChartPage(semesterGPAList: semesterGPAList),
          const SizedBox(height: 20),
          GradeRateChartPage(
            totalRequiredCredits: totalRequiredCredits,
            totalCompletedCredits: totalCompletedCredits,
            cultureCreditsRequired: cultureCreditsRequired,
            cultureCreditsCompleted: cultureCreditsCompleted,
            foreignLanguageCreditsRequired: foreignLanguageCreditsRequired,
            foreignLanguageCreditsCompleted: foreignLanguageCreditsCompleted,
            majorCreditsRequired: majorCreditsRequired,
            majorCreditsCompleted: majorCreditsCompleted,
          ),
          const SizedBox(height: 20),
          const CustomDataTableWidget(
            // 성적 표
            semesterName: '2023 秋', // 예시 데이터, 필요에 따라 변경 가능
            gpa: 4.0,
            creditsEarned: 16,
          ),
        ],
      ),
    ),
  );
}
}