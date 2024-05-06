import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/core/utils/core_utils.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  static const String routeName = '/timetable';

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TimetableCubit, TimetableState>(
        builder: (context, state) {
          if (state is TimetableLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CourseFetched) {
            return Center(child: Text(state.course.toString()));
          } else if (state is CourseIdsSearched) {
            context.read<TimetableCubit>().getCourses(state.courseIds);
            return const Center(child: CircularProgressIndicator());
          } else if (state is CoursesFetched) {
            return SafeArea(
              child: Column(
                children: [
                  const Text('Courses'),
                  Expanded(
                    child: ListView(
                        children: state.courses.map((course) {
                      return ListTile(
                        onTap: () {},
                        title: Text(course.toString()),
                        // title: Text(course.titles.toString()),
                        // subtitle: Text(course.codes.toString()),
                      );
                    }).toList()),
                  ),
                ],
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: TextButton(
                  onPressed: () {
                    context
                        .read<TimetableCubit>()
                        .getCourse('1b8asuduvHpuH2PEqyBT');
                  },
                  child: const Text(
                    'Get a Course',
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.read<TimetableCubit>().searchCourses(school: "法学部");
                  },
                  child: const Text(
                    'Search courses',
                  ),
                ),
              ),
            ],
          );
        },
        listener: (context, state) {
          if (state is TimetableError) {
            return CoreUtils.showSnackBar(context, state.message);
          }
        },
      ),
    );
  }
}
