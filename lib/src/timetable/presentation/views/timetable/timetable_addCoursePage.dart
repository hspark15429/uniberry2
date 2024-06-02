import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable/timetable_screen.dart';
import 'package:uuid/uuid.dart';

class AddCoursePage extends StatefulWidget {
  final String period;

  const AddCoursePage({super.key, required this.period});

  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final _titleController = TextEditingController();
  final _professorController = TextEditingController();
  final _codeController = TextEditingController();
  final _campusController = TextEditingController();
  final _syllabusUrlController = TextEditingController();
  final _creditController = TextEditingController();

  void _saveCourse() {
    if (_titleController.text.isEmpty ||
        _professorController.text.isEmpty ||
        _codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('강의명, 교수명, 강의코드는 필수 입력 항목입니다.')),
      );
      return;
    }

    final newCourse = Course(
      courseId: const Uuid().v4(),
      titles: [_titleController.text],
      professors: [_professorController.text],
      codes: [_codeController.text],
      campuses:
          _campusController.text.isNotEmpty ? [_campusController.text] : [],
      syllabusUrl: _syllabusUrlController.text,
      credit: _creditController.text.isNotEmpty
          ? int.tryParse(_creditController.text) ?? 0
          : 0,
      schools: const [],
      term: '',
      periods: const [],
      languages: const [],
    );

    context
        .read<TimetableCubit>()
        .addCourseToTimetable(newCourse, widget.period, '2024년봄학기');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => TimetableScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('강의 추가', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveCourse,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '강의명'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _professorController,
              decoration: const InputDecoration(labelText: '교수명'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: '강의코드'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _campusController,
              decoration: const InputDecoration(labelText: '캠퍼스 (옵션)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _syllabusUrlController,
              decoration: const InputDecoration(labelText: '시라버스 URL (옵션)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _creditController,
              decoration: const InputDecoration(labelText: '학점 (옵션)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}
