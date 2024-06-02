import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/core/services/injection_container.dart';
import 'package:uniberry2/src/forum/domain/entities/post.dart';
import 'package:uniberry2/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry2/src/forum/presentation/views/test/test_screen.dart';
import 'package:uniberry2/src/home/presentation/views/home_screen.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/test_screen.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case '/timetable':
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<TimetableCubit>(),
          child: const TimetableScreen(),
        ),
      );
    case '/forum':
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<PostCubit>(),
          child: const ForumScreen(),
        ),
      );

    default:
      return MaterialPageRoute(builder: (_) => const Placeholder());
  }
}

String _determineInitialSemester() {
  DateTime now = DateTime.now();
  int currentYear = now.year;
  return now.month < 9 ? "${currentYear}年春学期" : "${currentYear}年秋学期";
}
