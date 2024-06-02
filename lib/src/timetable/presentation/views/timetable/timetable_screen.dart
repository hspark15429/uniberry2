import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniberry2/src/home/presentation/views/home_screen.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/Grade/grade_page.dart';
import 'package:uniberry2/src/timetable/presentation/views/Grade/grade_rate_chart_page.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable/timetableSetting.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable/timetable_coursesListPage.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable/timetable_detailPage.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  static const String routeName = '/timetable';

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  late Future<String> _semesterFuture;

  @override
  void initState() {
    super.initState();
    _semesterFuture = _initializeSemester();
  }

  Future<String> _initializeSemester() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSemester = prefs.getString('initialSemester');

    if (savedSemester == null) {
      final newSemester = _determineCurrentSemester();
      await prefs.setString('initialSemester', newSemester);
      return newSemester;
    } else {
      return savedSemester;
    }
  }

  String _determineCurrentSemester() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;

    if (month >= 3 && month <= 8) {
      return '$year년봄학기';
    } else {
      return '$year년가을학기';
    }
  }

  void _selectSchool(BuildContext context) {
    final List<String> availableSchools =
        context.read<TimetableCubit>().schools;
    String? selectedSchool = context.read<TimetableCubit>().selectedSchool;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('전공 선택'),
              content: SingleChildScrollView(
                child: Column(
                  children: availableSchools
                      .map((school) => RadioListTile<String>(
                            title: Text(school),
                            value: school,
                            groupValue: selectedSchool,
                            onChanged: (value) {
                              setState(() {
                                selectedSchool = value;
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedSchool != null) {
                      context
                          .read<TimetableCubit>()
                          .setSelectedSchool(selectedSchool!);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('저장'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onTimetableSelected(String semester) {
    setState(() {
      _semesterFuture = Future.value(semester);
    });
  }

  void _showTimetableList(BuildContext context, String semester) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<TimetableCubit, TimetableState>(
          builder: (context, state) {
            final List<String> timetableList =
                context.read<TimetableCubit>().timetables;
            final TextEditingController _controller = TextEditingController();

            void _addTimetable() {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('새 시간표 추가'),
                    content: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: '시간표 이름'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('추가',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            context
                                .read<TimetableCubit>()
                                .addTimetable(_controller.text);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      TextButton(
                        child: const Text('취소',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }

            final allTimetables = [semester, ...timetableList];

            return Column(
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
                        '시간표 목록',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _addTimetable,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: allTimetables.isEmpty
                      ? const Center(child: Text('시간표가 없습니다.'))
                      : ListView.builder(
                          itemCount: allTimetables.length,
                          itemBuilder: (context, index) {
                            final timetableName = allTimetables[index];
                            final isSelected = timetableName == semester;
                            return Dismissible(
                              key: Key(timetableName),
                              direction: index == 0
                                  ? DismissDirection.none
                                  : DismissDirection.endToStart,
                              onDismissed: (direction) {
                                if (timetableName != semester) {
                                  context
                                      .read<TimetableCubit>()
                                      .removeTimetable(timetableName);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('$timetableName가 삭제되었습니다'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: Card(
                                color: isSelected
                                    ? Colors.grey[300]
                                    : Colors.white,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 3,
                                child: ListTile(
                                  title: Text(timetableName,
                                      style:
                                          const TextStyle(color: Colors.black)),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      // 시간표 수정 로직 구현
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _onTimetableSelected(timetableName);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTimetableSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const TimetableSettingPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _semesterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final semester = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: GestureDetector(
                onTap: () => _showTimetableList(context, semester),
                child: Text(
                  semester,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    decoration: TextDecoration.underline, // 강조 표시
                  ),
                ),
              ),
              centerTitle: true, // 중앙 정렬
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.school, color: Colors.white),
                  onPressed: () => _selectSchool(context),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () => _showTimetableSettings(context),
                ),
              ],
            ),
            body: BlocListener<TimetableCubit, TimetableState>(
              listener: (context, state) {
                if (state is TimetableError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              child: BlocBuilder<TimetableCubit, TimetableState>(
                builder: (context, state) {
                  final timetableCubit = context.read<TimetableCubit>();
                  final int periods = timetableCubit.periods;
                  final bool includeSaturday = timetableCubit.includeSaturday;
                  final bool includeSunday = timetableCubit.includeSunday;

                  final List<String> days = ['月', '火', '水', '木', '金'];
                  if (includeSaturday) days.add('土');
                  if (includeSunday) days.add('日');

                  return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      _buildDayHeader(days),
                      ...List.generate(
                          periods,
                          (index) => _buildPeriodRow(
                              context, index, days, timetableCubit, semester)),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GradePage()),
                          );
                        },
                        child: _buildGradeStatusCard(),
                      ),
                      const SizedBox(height: 300),
                    ],
                  );
                },
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('No data')),
          );
        }
      },
    );
  }

  Widget _buildDayHeader(List<String> days) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 30), // 교시 번호를 위한 공간 크기 조정
          ...days
              .map((day) => Expanded(
                  child: Center(
                      child: Text(day,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)))))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildPeriodRow(BuildContext context, int periodIndex,
      List<String> days, TimetableCubit timetableCubit, String semester) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
              width: 30, // 교시 번호의 너비 조정
              child: Center(
                  child: Text('${periodIndex + 1}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)))),
          ...days
              .map((day) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0), // 좌우 여백 추가
                      child: _buildDayCell(context, periodIndex,
                          days.indexOf(day), timetableCubit, semester),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, int periodIndex, int dayIndex,
      TimetableCubit timetableCubit, String semester) {
    final List<String> days = ['月', '火', '水', '木', '金'];
    if (timetableCubit.includeSaturday) days.add('土');
    if (timetableCubit.includeSunday) days.add('日');

    String period = '${days[dayIndex]}${periodIndex + 1}';
    final course = timetableCubit.semesterTimetables[semester]?[period];

    return InkWell(
      onTap: () {
        if (course != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (newContext) => TimetableDetailPage(
                course: course,
                period: period,
                semester: semester,
              ),
            ),
          );
        } else {
          context.read<TimetableCubit>().searchCourses(period: period);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (newContext) => BlocProvider.value(
                value: BlocProvider.of<TimetableCubit>(context),
                child: CoursesListPage(
                  period: period,
                  school: context.read<TimetableCubit>().selectedSchool ??
                      '학部 선택 없음',
                  semester: semester, // 추가된 라인
                ),
              ),
            ),
          );
        }
      },
      child: Container(
        height: 100, // 교시 크기를 더 키움
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: course != null ? Colors.white : Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: course != null
            ? Text(course.titles.join(', '),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))
            : const Text(''), // 강의가 없으면 빈 텍스트
      ),
    );
  }

  //이수관리
  Widget _buildGradeStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '이수상황',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          GradeRateChartPage(
            totalRequiredCredits: 124.0,
            totalCompletedCredits: 0.0,
            cultureCreditsRequired: 24.0,
            cultureCreditsCompleted: 0.0,
            foreignLanguageCreditsRequired: 12.0,
            foreignLanguageCreditsCompleted: 0.0,
            majorCreditsRequired: 68.0,
            majorCreditsCompleted: 0.0,
          ),
        ],
      ),
    );
  }
}
