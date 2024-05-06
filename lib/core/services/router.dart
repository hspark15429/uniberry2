import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/core/services/injection_container.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable_screen.dart';
import 'package:uniberry2/src/timetable/presentation/widgets/search_course_widget.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (_) => sl<TimetableCubit>(),
                child: const TimetableScreen(),
              ));
    case '/timetable':
      return MaterialPageRoute(builder: (_) => const Placeholder());
    case '/search':
      return MaterialPageRoute(builder: (_) => const SearchCourseWidget());
    default:
      return MaterialPageRoute(builder: (_) => const Placeholder());
  }
}
