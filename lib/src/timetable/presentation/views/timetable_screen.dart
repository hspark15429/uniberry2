

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/core/utils/core_utils.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable_coursesListPage.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({Key? key}) : super(key: key);

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
        title: Text("전공 선택"),
        content: SingleChildScrollView(
          child: ListBody(
            children: availableSchools.map((school) => GestureDetector(
              child: Text(school),
              onTap: () {
                Navigator.pop(context, school);  // 여기에서 학부 선택 후 다이얼로그 닫힘
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
      title: Text('Timetable'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop(); 
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.school),
          onPressed: () {
            _selectSchool(context);
          },
        ),
        Builder(  // Builder 추가
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();  // 여기서 안전하게 호출
            },
          ),
        ),
      ],
    ),
    endDrawer: _buildDrawer(context), 
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      context.read<TimetableCubit>().getCourse('1b8asuduvHpuH2PEqyBT');
                    },
                    child: const Text(
                      'Get a Course',
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      context.read<TimetableCubit>().searchCourses(
                        period: "月4",
                        school: "法学部",
                      );
                    },
                    child: const Text(
                      'Search courses',
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      context.read<TimetableCubit>().searchCourses(
                        period: "月4",
                        school: "法学部",
                      );
                    },
                    child: const Text(
                      'select school',
                    ),
                  ),
                ),
                
              ],
            ),
           BlocConsumer<TimetableCubit, TimetableState>(
  builder: (context, state) {
    if (state is TimetableLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is CourseFetched) {
      return Center(child: Text(state.course.toString()));
    } else if (state is CourseIdsSearched) {
      context.read<TimetableCubit>().getCourses(state.courseIds);
      return const Center(child: CircularProgressIndicator());
    } else if (state is CoursesFetched) {
      // 강의 목록 표시 부분 제거
      return Container(); 
    }
    return Container();
  },
  listener: (context, state) {
    if (state is TimetableError) {
      CoreUtils.showSnackBar(context, state.message);
    }
  },
),




            Card(
              margin: const EdgeInsets.all(10.0),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(width: 2, color: Colors.white),
                  outside: BorderSide(width: 2, color: Colors.white),
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
        builder: (newContext) {
          return BlocProvider.value(
            value: BlocProvider.of<TimetableCubit>(context),
            child: CoursesListPage(
              period: period,
              school: context.read<TimetableCubit>().selectedSchool ?? '학부 선택 없음',
            ),
          );
        },
      ),
    );
  },
  child: Container(
    height: 60,
    alignment: Alignment.center,
    child: const Text(''),
  ),
),

    ),
  ],
)),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





// 앱바 메뉴 부분
Widget _buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        ListTile(
          title: Text(
            'Timetable setting',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(
            'make new Timetable',
          ),
          onTap: () {
            Navigator.pushNamed(context, '/facilities');
          },
        ),
        ListTile(
          title: Text(
            'change Timetable',
          ),
          onTap: () {
            Navigator.pushNamed(context, '/facilities');
          },
        ),
        ListTile(
          title: Text(
            'bug report',
          ),
          onTap: () {
            Navigator.pushNamed(context, '/facilities');
          },
        ),
      ],
    ),
  );
}
