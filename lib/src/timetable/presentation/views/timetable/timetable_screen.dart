import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniberry2/src/dashboard/presentation/views/dashboard_screen.dart';
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

class _TimetableScreenState extends State<TimetableScreen>
    with SingleTickerProviderStateMixin {
  late Future<String> _semesterFuture;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isMajorSelected = false;
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _semesterFuture = _initializeSemester();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      setState(() {
        _isFirstLaunch = true;
      });
      await prefs.setBool('isFirstLaunch', false);
    } else {
      final selectedSchool = prefs.getString('selectedSchool');
      setState(() {
        _isFirstLaunch = false;
        _isMajorSelected = selectedSchool != null && selectedSchool.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    TextEditingController searchController = TextEditingController();
    List<String> filteredSchools = availableSchools;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void filterSchools(String query) {
              if (query.isNotEmpty) {
                setState(() {
                  filteredSchools = availableSchools
                      .where((school) =>
                          school.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                });
              } else {
                setState(() {
                  filteredSchools = availableSchools;
                });
              }
            }

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: searchController,
                    onChanged: filterSchools,
                    decoration: InputDecoration(
                      hintText: '전공 검색',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredSchools.length,
                      itemBuilder: (context, index) {
                        final school = filteredSchools[index];
                        return ListTile(
                          title: Text(school,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          leading: Radio<String>(
                            value: school,
                            groupValue: selectedSchool,
                            onChanged: (value) {
                              setState(() {
                                selectedSchool = value;
                              });
                            },
                          ),
                          onTap: () {
                            setState(() {
                              selectedSchool = school;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('취소',
                            style: TextStyle(color: Colors.red)),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedSchool != null) {
                            context
                                .read<TimetableCubit>()
                                .setSelectedSchool(selectedSchool!);
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString(
                                'selectedSchool', selectedSchool!);
                            setState(() {
                              _isMajorSelected = true;
                              _isFirstLaunch = false;
                              _controller.stop();
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('저장'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(),
                    ),
                  );
                },
              ),
              actions: [
                if (!_isMajorSelected)
                  FadeTransition(
                    opacity: _animation,
                    child: IconButton(
                      icon: const Icon(Icons.school, color: Colors.white),
                      onPressed: () => _selectSchool(context),
                    ),
                  )
                else
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
            body: Stack(
              children: [
                BlocListener<TimetableCubit, TimetableState>(
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
                      final bool includeSaturday =
                          timetableCubit.includeSaturday;
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
                              context,
                              index,
                              days,
                              timetableCubit,
                              semester,
                            ),
                          ),
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
                if (_isFirstLaunch && !_isMajorSelected) _buildOverlay(context),
              ],
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

  Widget _buildOverlay(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.8),
          child: GestureDetector(
            onTap: () {
              // Prevents interactions with the rest of the screen
            },
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: FadeTransition(
            opacity: _animation,
            child: IconButton(
              icon: const Icon(Icons.school, color: Colors.white, size: 40),
              onPressed: () => _selectSchool(context),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '학부를 선택해 주세요',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _selectSchool(context);
                },
                child: const Text('전공 선택'),
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildPeriodRow(
    BuildContext context,
    int periodIndex,
    List<String> days,
    TimetableCubit timetableCubit,
    String semester,
  ) {
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
              child: Text(
                '${periodIndex + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          ...days
              .map((day) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0), // 좌우 여백 추가
                      child: _buildDayCell(
                        context,
                        periodIndex,
                        days.indexOf(day),
                        timetableCubit,
                        semester,
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    int periodIndex,
    int dayIndex,
    TimetableCubit timetableCubit,
    String semester,
  ) {
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
                semester: semester, // 2024년봄학기
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
                      '학부 선택 없음',
                  semester: semester, // 2024년봄학기
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
          color: course != null
              ? Color.fromARGB(255, 255, 133, 133)
              : Colors.white10,
          borderRadius: BorderRadius.circular(5),
        ),
        child: course != null
            ? Text(course.titles.join(', '),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255)))
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
