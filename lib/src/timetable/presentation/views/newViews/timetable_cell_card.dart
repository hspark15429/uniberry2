import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';

class TimetableCellCard extends StatefulWidget {
  const TimetableCellCard({
    required this.period,
    required this.course,
    super.key,
  });

  final TimetablePeriod period;
  final CourseModel course;

  @override
  State<TimetableCellCard> createState() => _TimetableCellCardState();
}

class _TimetableCellCardState extends State<TimetableCellCard> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.course.titles.toString());
  }
}
