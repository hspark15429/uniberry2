import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/oldViews/Grade/widgets/CustomDataTableWidget.dart';
import 'package:uniberry2/src/timetable/presentation/views/oldViews/Grade/widgets/grade_rate_chart_page.dart';

class GradePage extends StatefulWidget {
  const GradePage({super.key});

  @override
  _GradePageState createState() => _GradePageState();
}

class _GradePageState extends State<GradePage> {
  int selectedSemester = 0;
  double requiredTotalCredits = 124;
  double totalCompletedCredits = 0;
  double cultureCreditsCompleted = 0;
  double foreignLanguageCreditsCompleted = 0;
  double majorCreditsCompleted = 0;
  double cumulativeGPA = 0.0;

  double requiredMajorCredits = 68;
  double requiredForeignLanguageCredits = 12;
  double requiredCultureCredits = 24;

  final List<Map<String, double>> semesterGPAList = [];
  List<Map<String, dynamic>> courses = [];

  final List<String> semesterNames = [
    '1S',
    '1A',
    '2S',
    '2A',
    '3S',
    '3A',
    '4S',
    '4A',
    '5S',
    '5A',
    '6S',
    '6A',
  ];

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final TextEditingController majorController =
            TextEditingController(text: requiredMajorCredits.toString());
        final TextEditingController foreignLanguageController =
            TextEditingController(
                text: requiredForeignLanguageCredits.toString());
        final TextEditingController cultureController =
            TextEditingController(text: requiredCultureCredits.toString());
        final TextEditingController totalController =
            TextEditingController(text: requiredTotalCredits.toString());

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '졸업 요건 설정',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: majorController,
                decoration: const InputDecoration(
                  labelText: '전공 학점',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: foreignLanguageController,
                decoration: const InputDecoration(
                  labelText: '외국어 학점',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: cultureController,
                decoration: const InputDecoration(
                  labelText: '교양 학점',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: totalController,
                decoration: const InputDecoration(
                  labelText: '총 학점',
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    requiredMajorCredits =
                        double.tryParse(majorController.text) ??
                            requiredMajorCredits;
                    requiredForeignLanguageCredits =
                        double.tryParse(foreignLanguageController.text) ??
                            requiredForeignLanguageCredits;
                    requiredCultureCredits =
                        double.tryParse(cultureController.text) ??
                            requiredCultureCredits;
                    requiredTotalCredits =
                        double.tryParse(totalController.text) ??
                            requiredTotalCredits;
                  });
                  Navigator.pop(context);
                },
                child: const Text('저장'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _loadTimetable(BuildContext context) {
    showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BlocBuilder<TimetableCubit, TimetableState>(
          builder: (context, state) {
            final List<String> timetableList =
                context.read<TimetableCubit>().timetables;
            final TextEditingController _controller = TextEditingController();

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Text(
                          '시간표선택',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    child: timetableList.isEmpty
                        ? const Center(child: Text('시간표가 없습니다.'))
                        : ListView.builder(
                            itemCount: timetableList.length,
                            itemBuilder: (context, index) {
                              final timetableName = timetableList[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 3,
                                child: ListTile(
                                  title: Text(timetableName,
                                      style:
                                          const TextStyle(color: Colors.black)),
                                  onTap: () {
                                    Navigator.pop(context, timetableName);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        _loadCoursesFromTimetable(result);
      }
    });
  }

  void _loadCoursesFromTimetable(String timetableName) {
    setState(() {
      courses = [
        {'name': '数学', 'credits': 2, 'grade': '', 'type': ''},
        {'name': '英語', 'credits': 2, 'grade': '', 'type': ''},
      ];
      _calculateGPA();
    });
  }

  void _updateCourse(
      int index, String name, int credits, String grade, String type) {
    setState(() {
      courses[index] = {
        'name': name,
        'credits': credits,
        'grade': grade,
        'type': type,
      };
      _calculateGPA();
    });
  }

  void _deleteCourse(int index) {
    setState(() {
      courses.removeAt(index);
      _calculateGPA();
    });
  }

  void _calculateGPA() {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var course in courses) {
      double gradeValue = _convertGradeToPoints(course['grade'] as String);
      totalPoints += gradeValue * (course['credits'] as int);
      totalCredits += course['credits'] as int;
    }

    setState(() {
      cumulativeGPA = totalCredits > 0 ? totalPoints / totalCredits : 0.0;
    });
  }

  double _convertGradeToPoints(String grade) {
    switch (grade) {
      case 'A+':
        return 4.5;
      case 'A':
        return 4.0;
      case 'B':
        return 3.0;
      case 'C':
        return 2.0;
      case 'F':
        return 0.0;
      default:
        return 0.0;
    }
  }

  void _addManualCourse() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        int credits = 1;
        String grade = 'A+';
        String type = '専門科目';

        return AlertDialog(
          title: const Text('手動で科目を追加'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: '科目名'),
                ),
                DropdownButtonFormField<int>(
                  value: credits,
                  onChanged: (value) {
                    setState(() {
                      credits = value!;
                    });
                  },
                  items: List.generate(5, (index) => index + 1)
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.toString()),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: '単位数'),
                ),
                DropdownButtonFormField<String>(
                  value: grade,
                  onChanged: (value) {
                    setState(() {
                      grade = value!;
                    });
                  },
                  items: ['A+', 'A', 'B', 'C', 'F']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: '成績'),
                ),
                DropdownButtonFormField<String>(
                  value: type,
                  onChanged: (value) {
                    setState(() {
                      type = value!;
                    });
                  },
                  items: ['専門科目', '教養科目', '外国語']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: '区分'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  courses.add({
                    'name': nameController.text,
                    'credits': credits,
                    'grade': grade,
                    'type': type,
                  });
                });
                Navigator.of(context).pop();
                _calculateGPA();
              },
              child: const Text('追加'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
              ),
            ),
          ],
        );
      },
    );
  }

  void _applyGrades() {
    if (courses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('성적을 반영하기 전에 과목을 추가하세요.'),
        ),
      );
      return;
    }

    double semesterGPA = cumulativeGPA;
    int semesterCredits =
        courses.fold(0, (sum, course) => sum + (course['credits'] as int));

    setState(() {
      totalCompletedCredits += semesterCredits;
      cumulativeGPA =
          (cumulativeGPA * (totalCompletedCredits - semesterCredits) +
                  semesterGPA * semesterCredits) /
              totalCompletedCredits;

      for (var course in courses) {
        int credits = course['credits'] as int;
        switch (course['type']) {
          case '専門科目':
            majorCreditsCompleted += credits;
            break;
          case '教養科目':
            cultureCreditsCompleted += credits;
            break;
          case '外国語':
            foreignLanguageCreditsCompleted += credits;
            break;
          default:
            break;
        }
      }

      semesterGPAList
          .add({'GPA': semesterGPA, 'Credits': semesterCredits.toDouble()});
      courses.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('성적이 반영되었습니다. 누락된 과목이 없는지 확인하세요.'),
      ),
    );
  }

  void _resetGrades() {
    setState(() {
      totalCompletedCredits = 0;
      cultureCreditsCompleted = 0;
      foreignLanguageCreditsCompleted = 0;
      majorCreditsCompleted = 0;
      cumulativeGPA = 0.0;
      semesterGPAList.clear();
      courses.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('성적이 초기화되었습니다.'),
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('エラー'),
          content: const Text('성적을 반영해주십시오.'),
          actions: <Widget>[
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSemesterButtons() {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: semesterNames.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedSemester = index + 1;
                  courses.clear();
                  cumulativeGPA = 0.0;
                  totalCompletedCredits = 0;
                  cultureCreditsCompleted = 0;
                  foreignLanguageCreditsCompleted = 0;
                  majorCreditsCompleted = 0;
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: selectedSemester == index + 1
                    ? Colors.white
                    : const Color(0xFF007AFF),
                backgroundColor: selectedSemester == index + 1
                    ? const Color(0xFF007AFF)
                    : null,
                side: const BorderSide(color: Color(0xFF007AFF)),
              ),
              child: Text(
                semesterNames[index],
                style: TextStyle(
                  color: selectedSemester == index + 1
                      ? Colors.white
                      : const Color(0xFF007AFF),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGpaAndCreditsText() {
    return Column(
      children: [
        Text(
          '累積GPA: ${cumulativeGPA.toStringAsFixed(1)}/5.0',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Text(
          '取得単位: ${totalCompletedCredits.toInt()}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Text(
          '専門科目: $majorCreditsCompleted / $requiredMajorCredits',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Text(
          '教養科目: $cultureCreditsCompleted / $requiredCultureCredits',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Text(
          '外国語: $foreignLanguageCreditsCompleted / $requiredForeignLanguageCredits',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学期別履修状況', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF007AFF),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('SとAの意味'),
                    content: const Text(
                        'Sは春学期、Aは秋学期を意味します。　　　　　　　　　　　　　ex) 1S = 1年生の春学期, 1A = 1年生の秋学期'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('닫기'),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSemesterButtons(),
            const SizedBox(height: 20),
            _buildGpaAndCreditsText(),
            const SizedBox(height: 20),
            // grade_chart.GradeChartPage(semesterGPAList: semesterGPAList),
            const SizedBox(height: 20),
            GradeRateChartPage(
              totalRequiredCredits: requiredTotalCredits,
              totalCompletedCredits: totalCompletedCredits,
              cultureCreditsRequired: requiredCultureCredits,
              cultureCreditsCompleted: cultureCreditsCompleted,
              foreignLanguageCreditsRequired: requiredForeignLanguageCredits,
              foreignLanguageCreditsCompleted: foreignLanguageCreditsCompleted,
              majorCreditsRequired: requiredMajorCredits,
              majorCreditsCompleted: majorCreditsCompleted,
            ),
            const SizedBox(height: 20),
            if (selectedSemester > 0)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => _loadTimetable(context),
                        child: const Text('시간표를 불러오기'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _addManualCourse,
                        child: const Text('手動で科目を追加'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                        ),
                      ),
                    ],
                  ),
                  CustomDataTableWidget(
                    semesterName: semesterNames[selectedSemester - 1],
                    gpa: cumulativeGPA,
                    creditsEarned: totalCompletedCredits.toInt(),
                    courses: courses,
                    onUpdateCourse: _updateCourse,
                    onDeleteCourse: _deleteCourse,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _applyGrades,
                        child: const Text('성적 반영하기'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _resetGrades,
                        child: const Text('초기화'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
