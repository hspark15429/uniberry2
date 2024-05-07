

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/core/utils/core_utils.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timetable"),
        leading: BackButton(onPressed: () {
          Navigator.of(context).pop();
        }),
      ),
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
                  return ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: state.courses.length,
                    itemBuilder: (context, index) {
                      final course = state.courses[index];
                      return ListTile(
                        onTap: () {},
                        title: Text(course.titles.toString()),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(course.professors.toString()),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
              listener: (context, state) {
                if (state is TimetableError) {
                  return CoreUtils.showSnackBar(context, state.message);
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
                      ...List.generate(5, (index) => Center(child: Text(['월', '화', '수', '목', '금'][index]))),
                    ],
                  ),
                  ...List.generate(7, (index) => TableRow(
                    children: [
                      Center(child: Text('${index + 1}')),
                      ...List.generate(5, (i) => InkWell(
                        onTap: () {
                          showDialogForCourses(context, '法学部', '${['月', '火', '水', '木', '金'][i]}${index + 1}');
                        },
                        child: Container(
                          height: 60,
                          alignment: Alignment.center,
                          child: const Text('Data'),
                        ),
                      )),
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
void showDialogForCourses(BuildContext originalContext, String school, String period) async {
  await originalContext.read<TimetableCubit>().searchCourses(period: period, school: school);

  showModalBottomSheet(
    context: originalContext,
    isScrollControlled: true,
    builder: (BuildContext bottomSheetContext) {
      // 여기서는 bottomSheetContext 대신 originalContext를 사용
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        builder: (_, controller) {
          return StreamBuilder<TimetableState>(
            stream: originalContext.read<TimetableCubit>().stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                TimetableState state = snapshot.data!;
                if (state is CoursesFetched) {
                  return ListView.builder(
                    controller: controller,
                    itemCount: state.courses.length,
                    itemBuilder: (BuildContext context, int index) {
                      final course = state.courses[index];
                      return ListTile(
                        title: Text(course.titles.toString()),
                        subtitle: Text(course.professors.toString()),
                      );
                    },
                  );
                } else if (state is TimetableLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      );
    },
  );
}
