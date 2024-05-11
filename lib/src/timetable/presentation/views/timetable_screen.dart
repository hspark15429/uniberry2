



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/src/home/presentation/views/home_screen.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/Grade/grade_page.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable_coursesListPage.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable_detailPage.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetalbe_menuPage.dart';



class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  static const String routeName = '/timetable';

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<TimetableCubit>().loadMoreCourses();
    }
  }

  void _selectSchool(BuildContext context) {
    final List<String> availableSchools = context.read<TimetableCubit>().schools;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("전공 선택"),
          content: SingleChildScrollView(
            child: ListBody(
              children: availableSchools.map((school) => GestureDetector(
                child: Text(school),
                onTap: () {
                  Navigator.pop(context, school);  // 학부 선택 후 다이얼로그 닫힘
                },
              )).toList(),
            ),
          ),
        );
      },
    ).then((selectedSchool) {
      if (selectedSchool != null) {
        context.read<TimetableCubit>().setSelectedSchool(selectedSchool);  // 선택된 학부 저장
      }
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Timetable'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.school),
          onPressed: () => _selectSchool(context),
        ),
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ],
    ),
    endDrawer: _buildDrawer(context),
    body: SingleChildScrollView(
      child: Column(
        children: [
         BlocBuilder<TimetableCubit, TimetableState>(
  builder: (context, state) {
    if (state is TimetableLoading) {
      return const Center(child: CircularProgressIndicator());
    } 
    else if (state is CoursesFetched) {
      if (state.courses.isEmpty) {
        return const Center(child: Text("No courses available from CoursesFetched."));
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.courses.length,
        itemBuilder: (context, index) {
          final course = state.courses[index];
          return ListTile(
            title: Text(course.titles.join(", ")),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimetableDetailPage(course: course)),
              );
            },
          );
        },
      );
    }
    else if (state is CoursesUpdated) {
      if (state.courses.isEmpty) {
        return const Center(child: Text("No courses available from CoursesUpdated."));
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.courses.length,
        itemBuilder: (context, index) {
          final course = state.courses[index];
          return ListTile(
            title: Text(course.titles.join(", ")),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimetableDetailPage(course: course)),
              );
            },
          );
        },
      );
    }
    return const Center(child: Text("No courses available."));
  },
),

          buildTimeTable(context),
        ],
      ),
    ),
  );
}

  Widget buildTimeTable(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Table(
        border: TableBorder.symmetric(
          inside: const BorderSide(width: 2, color: Colors.white),
          outside: const BorderSide(width: 2, color: Colors.white),
        ),
        children: [
          TableRow(
            children: [
              const SizedBox(),
              ...List.generate(5, (index) => Center(child: Text(['月', '火', '水', '木', '金'][index]))),
            ],
          ),
          ...List.generate(7, (index) => TableRow(
            children: [
              Center(child: Text('${index + 1}')),
              ...List.generate(5, (i) => InkWell(
                onTap: () {
                  String period = '${['月', '火', '水', '木', '金'][i]}${index + 1}';
                  context.read<TimetableCubit>().searchCourses(period: period);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (newContext) => BlocProvider.value(
                        value: BlocProvider.of<TimetableCubit>(context),
                        child: CoursesListPage(
                          period: period,
                          school: context.read<TimetableCubit>().selectedSchool ?? '학부 선택 없음',
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: const Text(''),
                ),
              )),
            ],
          )),
        ],
      ),
    );
  }


//메뉴페이지
Widget _buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        ListTile(
          title: const Text(
            'Timetable setting',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text(
            'Manage Timetable',
            style: TextStyle(fontSize: 16),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TimetableMenuPage()),
            );
          },
        ),
        ListTile(
          title: const Text(
            '이수 관리',
            style: TextStyle(fontSize: 16),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GradePage()),
            );
          },
        ),
        ListTile(
          title: const Text(
            'Bug report',
            style: TextStyle(fontSize: 16),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/bugReport');
          },
        ),
      ],
    ),
  );
}
}



Widget buildNoteSection() {
    return Column(
      children: [
        Container(
          height: 800,
          child: const HomeScreen(),
        ),
      ],
    );
  }




