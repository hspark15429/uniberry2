import 'package:flutter/material.dart';
import 'package:uniberry/src/timetable/data/models/course_model.dart';
import 'package:uniberry/src/timetable/presentation/widgets/course_card.dart';

class CourseDetailsView extends StatelessWidget {
  const CourseDetailsView({required this.course, super.key});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          course.titles.join(', '),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, course);
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            children: [
              CourseCard(course: course, alreadyAdded: true),
            ],
          ),
        ),
      ),
    );
  }
}
