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
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CourseFetched) {
            return Center(child: Text(state.course.toString()));
          }
          return Center(
            child: TextButton(
              onPressed: () {
                context.read<TimetableCubit>().getCourse('MATH101');
              },
              child: const Text(
                'Get Course: MATH101',
              ),
            ),
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
