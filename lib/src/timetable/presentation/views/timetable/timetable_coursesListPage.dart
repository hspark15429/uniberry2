import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable/timetable_addCoursePage.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable/timetalbe_courseDetailPage.dart';

class CoursesListPage extends StatefulWidget {
  final String period;
  final String school;
  final String semester;

  const CoursesListPage({super.key, required this.period, required this.school, required this.semester});

  @override
  _CoursesListPageState createState() => _CoursesListPageState();
}

class _CoursesListPageState extends State<CoursesListPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.school} - ${widget.period}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCoursePage(period: widget.period),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: '강의명, 교수명, 강의 코드로 검색',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<TimetableCubit, TimetableState>(
              builder: (context, state) {
                if (state is TimetableLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CoursesFetched) {
                  final filteredCourses = state.courses.where((course) {
                    return course.titles.any((title) => title.contains(_searchText)) ||
                        course.professors.any((prof) => prof.contains(_searchText)) ||
                        course.codes.any((code) => code.contains(_searchText));
                  }).toList();

                  if (filteredCourses.isEmpty) {
                    return const Center(child: Text("No courses available.", style: TextStyle(fontSize: 18, color: Colors.grey)));
                  }

                  return ListView.builder(
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: BlocProvider.of<TimetableCubit>(context),
                                child: TimetableCourseDetailPage(
                                  course: course,
                                  period: widget.period,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.titles.join(", "),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                course.professors.join(", "),
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                course.codes.join(", "),
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is TimetableError) {
                  return Center(child: Text(state.message, style: const TextStyle(color: Colors.black)));
                }
                return const Center(child: Text("Unable to fetch courses.", style: TextStyle(color: Colors.black)));
              },
            ),
          ),
        ],
      ),
    );
  }
}
