import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/src/timetable/domain/entities/course.dart';
import 'package:uniberry/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry/src/timetable/presentation/utils/period_to_japanese.dart';
import 'package:uniberry/src/timetable/presentation/widgets/course_card.dart';

class TimetableSearchSheet extends StatefulWidget {
  const TimetableSearchSheet({
    required this.period,
    required this.school,
    required this.term,
    super.key,
  });
  final TimetablePeriod period;
  final String school;
  final String term;

  @override
  _TimetableSearchSheetState createState() => _TimetableSearchSheetState();
}

class _TimetableSearchSheetState extends State<TimetableSearchSheet> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      context.read<TimetableCubit>().searchCourses(
            query: _searchController.text,
            period: timetablePeriodToJapanese(widget.period),
            school: widget.school,
            term: widget.term,
          );
    });
    context.read<TimetableCubit>().searchCourses(
          query: '',
          period: timetablePeriodToJapanese(widget.period),
          school: widget.school,
          term: widget.term,
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.term.isEmpty ? "全セメスター" : widget.term}  ${widget.school}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '授業コードで検索..',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (query) {
                // 검색 기능 함수
                // context.read<TimetableCubit>().searchCourses(query);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<TimetableCubit, TimetableState>(
              builder: (context, state) {
                if (state is TimetableLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CourseIdsSearched) {
                  context.read<TimetableCubit>().getCourses(state.courseIds);
                } else if (state is CoursesFetched) {
                  if (state.courses.isEmpty) {
                    return const Center(
                      child: Text(
                        'No courses available.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.courses.length,
                    itemBuilder: (context, index) {
                      final course = state.courses[index];
                      return CourseCard(course: course);
                    },
                  );
                } else if (state is TimetableError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }
                return const Center(
                  child: Text(
                    'Unable to fetch courses.',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
