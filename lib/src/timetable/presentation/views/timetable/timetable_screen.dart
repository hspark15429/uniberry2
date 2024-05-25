import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/src/home/presentation/views/home_screen.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/Grade/grade_page.dart';
import 'package:uniberry2/src/timetable/presentation/views/Grade/grade_rate_chart_page.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable/timetableSetting.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable/timetable_coursesListPage.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable/timetable_detailPage.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key, required this.initialSemester});

  final String initialSemester;

  static const String routeName = '/timetable';

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  late String _semester;

  @override
  void initState() {
    super.initState();
    _semester = widget.initialSemester;
  }

  void _selectSchool(BuildContext context) {
    final List<String> availableSchools = context.read<TimetableCubit>().schools;
    String? selectedSchool = context.read<TimetableCubit>().selectedSchool;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("전공 선택"),
              content: SingleChildScrollView(
                child: Column(
                  children: availableSchools.map((school) => RadioListTile<String>(
                    title: Text(school),
                    value: school,
                    groupValue: selectedSchool,
                    onChanged: (value) {
                      setState(() {
                        selectedSchool = value;
                      });
                    },
                  )).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("취소"),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedSchool != null) {
                      context.read<TimetableCubit>().setSelectedSchool(selectedSchool!);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text("저장"),
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
      _semester = semester;
    });
  }

  Future<void> _showTimetableSelectionSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TimetableMenuPage(onTimetableSelected: _onTimetableSelected);
      },
    );
  }

  Future<void> _showSettingsSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const TimetableSettingSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _showTimetableSelectionSheet(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_semester, style: const TextStyle(color: Colors.white)),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
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
            onPressed: () => _showSettingsSheet(context),
          ),
        ],
      ),
      endDrawer: _buildDrawer(context),
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
                ...List.generate(periods, (index) => _buildPeriodRow(context, index, days, timetableCubit)),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GradePage()),
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
  }

  Widget _buildDayHeader(List<String> days) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 30), // 교시 번호를 위한 공간 크기 조정
          ...days.map((day) => Expanded(
            child: Center(child: Text(day, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildPeriodRow(BuildContext context, int periodIndex, List<String> days, TimetableCubit timetableCubit) {
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
            child: Center(child: Text('${periodIndex + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)))
          ),
          ...days.map((day) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0), // 좌우 여백 추가
              child: _buildDayCell(context, periodIndex, days.indexOf(day), timetableCubit),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildDayCell(BuildContext context, int periodIndex, int dayIndex, TimetableCubit timetableCubit) {
    final List<String> days = ['月', '火', '水', '木', '金'];
    if (timetableCubit.includeSaturday) days.add('土');
    if (timetableCubit.includeSunday) days.add('日');

    String period = '${days[dayIndex]}${periodIndex + 1}';
    final course = timetableCubit.semesterTimetables[_semester]?[period];

    return InkWell(
      onTap: () {
        if (course != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
builder: (newContext) => TimetableDetailPage(course: course, period: '', semester: '',),
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
                  school: context.read<TimetableCubit>().selectedSchool ?? '학부 선택 없음', semester: '',
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
            ? Text(course.titles.join(", "), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black))
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '履修状況',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildGpaAndCreditsText(),
          const SizedBox(height: 16),
          GradeRateChartPage(
            totalRequiredCredits: 124,
            totalCompletedCredits: 63,
            cultureCreditsRequired: 24,
            cultureCreditsCompleted: 24,
            foreignLanguageCreditsRequired: 12,
            foreignLanguageCreditsCompleted: 12,
            majorCreditsRequired: 68,
            majorCreditsCompleted: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildGpaAndCreditsText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "累積GPA: 4.2/5.0",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          "取得単位: 76/124",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: Text(
                'Settings',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.black),
            title: const Text('Timetable setting', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TimetableSettingPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.black),
            title: const Text('Manage Timetable', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimetableMenuPage(onTimetableSelected: _onTimetableSelected)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.school, color: Colors.black),
            title: const Text('이수 관리', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GradePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report, color: Colors.black),
            title: const Text('Bug report', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pushNamed(context, '/bugReport');
            },
          ),
        ],
      ),
    );
  }
}

class TimetableSettingSheet extends StatefulWidget {
  const TimetableSettingSheet({super.key});

  @override
  State<TimetableSettingSheet> createState() => _TimetableSettingSheetState();
}

class _TimetableSettingSheetState extends State<TimetableSettingSheet> {
  int _periods = 5;
  bool _includeSaturday = false;
  bool _includeSunday = false;

  void _saveSettings() {
    context.read<TimetableCubit>().setPeriods(_periods);
    context.read<TimetableCubit>().setIncludeSaturday(_includeSaturday);
    context.read<TimetableCubit>().setIncludeSunday(_includeSunday);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Select Number of Periods', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Slider(
            value: _periods.toDouble(),
            min: 5,
            max: 12,
            divisions: 7,
            label: '$_periods periods',
            onChanged: (value) {
              setState(() {
                _periods = value.toInt();
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Include Saturday', style: TextStyle(fontSize: 16)),
              Switch(
                value: _includeSaturday,
                onChanged: (value) {
                  setState(() {
                    _includeSaturday = value;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Include Sunday', style: TextStyle(fontSize: 16)),
              Switch(
                value: _includeSunday,
                onChanged: (value) {
                  setState(() {
                    _includeSunday = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save Settings'),
            ),
          ),
        ],
      ),
    );
  }
}

class TimetableMenuPage extends StatefulWidget {
  final Function(String) onTimetableSelected;

  const TimetableMenuPage({super.key, required this.onTimetableSelected});

  @override
  _TimetableMenuPageState createState() => _TimetableMenuPageState();
}

class _TimetableMenuPageState extends State<TimetableMenuPage> {
  late List<String> _timetableList;

  @override
  void initState() {
    super.initState();
    int currentYear = DateTime.now().year;
    _timetableList = List.generate(4, (int index) => currentYear + index)
        .expand((year) => ["${year}年春学期", "${year}年秋学期"])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('시간표 관리', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _displayAddDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _timetableList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_timetableList[index]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                _timetableList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_timetableList[index]}가 삭제되었습니다'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              child: ListTile(
                title: Text(_timetableList[index], style: const TextStyle(color: Colors.black)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () => _displayEditDialog(context, _timetableList[index], index),
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onTimetableSelected(_timetableList[index]);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _displayAddDialog(BuildContext context) async {
    TextEditingController _controller = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('새 시간표 추가'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: '시간표 이름'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('추가', style: TextStyle(color: Colors.black)),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _timetableList.add(_controller.text);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: const Text('취소', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displayEditDialog(BuildContext context, String initialText, int index) async {
    TextEditingController _controller = TextEditingController(text: initialText);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('시간표 이름 수정'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: '시간표 이름'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('저장', style: TextStyle(color: Colors.black)),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    _timetableList[index] = _controller.text;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: const Text('취소', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
