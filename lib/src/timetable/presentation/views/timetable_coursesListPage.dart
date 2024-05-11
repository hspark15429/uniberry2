import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetalbe_courseDetailPage.dart';


class CoursesListPage extends StatefulWidget {
  final String period;
  final String school;

  const CoursesListPage({Key? key, required this.period, required this.school}) : super(key: key);

  @override
  _CoursesListPageState createState() => _CoursesListPageState();
}

class _CoursesListPageState extends State<CoursesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.school} - ${widget.period}'),
      ),
      body: BlocBuilder<TimetableCubit, TimetableState>(
        builder: (context, state) {
          if (state is TimetableLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CoursesFetched) {
            if (state.courses.isEmpty) {
              return const Center(child: Text("No courses available."));
            }
            return ListView.separated(
              itemCount: state.courses.length,
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: BlocProvider.of<TimetableCubit>(context),
                          child: TimetableCourseDetailPage(course: course),
                        ),
                      ),
                    );
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(course.codes.join(", "), style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text(course.titles.join(", ")),
                      ),
                      Expanded(
                        child: Text(course.professors.join(", ")),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            );
          } else if (state is TimetableError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Unable to fetch courses."));
        },
      ),
    );
  }
}