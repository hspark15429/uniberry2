import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniberry/core/common/widgets/title_text.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/src/timetable/data/models/course_model.dart';
import 'package:uniberry/src/timetable/data/models/timetable_model.dart';
import 'package:uniberry/src/timetable/domain/entities/course.dart';
import 'package:uniberry/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry/src/timetable/presentation/views/newViews/course_details_view.dart';
import 'package:uniberry/src/timetable/presentation/views/newViews/timetable_search_sheet.dart';

import 'package:uniberry/src/timetable/presentation/views/newViews/timetable_update_list_sheet.dart';
import 'package:uniberry/src/timetable/presentation/widgets/select_school_tile.dart';
import 'package:uniberry/src/timetable/presentation/views/newViews/timetable_settings_sheet.dart';
import 'package:uniberry/src/timetable/presentation/widgets/timetable_header_widget.dart';

class TimetableView extends StatefulWidget {
  const TimetableView({required this.initialTimetable, super.key});

  static const String routeName = '/timetable2';
  final TimetableModel initialTimetable;

  @override
  State<TimetableView> createState() => _TimetableViewState();
}

class _TimetableViewState extends State<TimetableView> {
  final prefs = sl<SharedPreferences>();
  bool isEditted = false;
  Map<TimetablePeriod, CourseModel?> timetableMapWithCourseObject = {};
  late TimetableModel _currentTimetable;
  late String school;
  late String term; // 2024년봄학기

  TimetableModel get currentTimetable => _currentTimetable;
  set currentTimetable(TimetableModel timetable) {
    setState(() {
      _currentTimetable = timetable;
      isEditted = true;
      prefs.setString('lastTimetable', _currentTimetable.toJson());
      timetableMapWithCourseObject = {};
    });
  }

  @override
  void initState() {
    super.initState();
    school = '経営学部';
    term = '';
    if (prefs.getString('lastTimetable') == null) {
      currentTimetable = widget.initialTimetable;
      prefs.setString('lastTimetable', currentTimetable.toJson());
    } else {
      currentTimetable =
          TimetableModel.fromJson(prefs.getString('lastTimetable')!);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<TimetableCubit>().getCourses(
          currentTimetable.timetableMap.values.whereType<String>().toList(),
        );

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            final newTimetable = await showModalBottomSheet<TimetableModel>(
              context: context,
              builder: (_) => BlocProvider(
                create: (context) => sl<TimetableCubit>(),
                child: Consumer<UserProvider>(
                  builder: (context, provider, __) {
                    final timetableIds = provider.user!.timetableIds;
                    final currentIndex =
                        timetableIds.indexOf(currentTimetable.timetableId);
                    context
                        .read<TimetableCubit>()
                        .getTimetables(provider.user!.timetableIds);
                    return TimetableUpdateListSheet(currentIndex: currentIndex);
                  },
                ),
              ),
            );
            if (newTimetable != null) {
              currentTimetable = newTimetable;
            }
          },
          child: TitleText(text: _currentTimetable.name),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: isEditted ? Colors.white : Colors.grey,
            ),
            onPressed: () async {
              if (isEditted == true) {
                await context.read<TimetableCubit>().updateTimetable(
                      timetableId: currentTimetable.timetableId,
                      timetable: currentTimetable,
                    );
                setState(() {
                  isEditted = false;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.school),
            onPressed: () async {
              final result = await showModalBottomSheet<String>(
                context: context,
                builder: (context) {
                  return SelectSchoolTile(currentSchool: school);
                },
              );
              if (result != null) {
                school = result;
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final result = await showModalBottomSheet<SelectTermSheetParams>(
                context: context,
                builder: (context) {
                  return TimetableSettingsSheet(
                    params: SelectTermSheetParams(
                      term: term,
                      numOfPeriods: currentTimetable.numOfPeriods,
                      numOfDays: currentTimetable.numOfDays,
                    ),
                  );
                },
              );
              if (result != null) {
                term = result.term;
                currentTimetable = currentTimetable.copyWith(
                  numOfDays: result.numOfDays,
                  numOfPeriods: result.numOfPeriods,
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child:
                TimetableHeaderWidget(numOfDays: _currentTimetable.numOfDays),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: BlocBuilder<TimetableCubit, TimetableState>(
                builder: (context, state) {
                  if (state is CoursesFetched) {
                    currentTimetable.timetableMap.forEach((period, courseId) {
                      if (courseId is String && courseId.isNotEmpty) {
                        try {
                          timetableMapWithCourseObject[period] = state.courses
                                  .firstWhere(
                                      (course) => course.courseId == courseId)
                              as CourseModel;
                        } catch (e) {
                          timetableMapWithCourseObject[period] = null;
                        }
                      }
                    });
                    return Column(
                      children: [
                        ...List.generate(
                          currentTimetable.numOfPeriods,
                          (index) => _buildPeriodRow(
                            periodIndex: index,
                            numOfDays: currentTimetable.numOfDays,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // _buildGradeStatusCard(),
                        // const SizedBox(height: 300),
                      ],
                    );
                  } else if (state is TimetableLoading) {
                    return const CircularProgressIndicator();
                  } else {
                    return Column(
                      children: [
                        ...List.generate(
                          _currentTimetable.numOfPeriods,
                          (index) => _buildPeriodRow(
                            periodIndex: index,
                            numOfDays: _currentTimetable.numOfDays,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // _buildGradeStatusCard(),
                        // const SizedBox(height: 300),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodRow({
    required int periodIndex,
    required int numOfDays,
  }) {
    final periods = <TimetablePeriod>[
      TimetablePeriod(
          day: DayOfWeek.monday, period: Period.values[periodIndex]),
      TimetablePeriod(
          day: DayOfWeek.tuesday, period: Period.values[periodIndex]),
      TimetablePeriod(
          day: DayOfWeek.wednesday, period: Period.values[periodIndex]),
      TimetablePeriod(
          day: DayOfWeek.thursday, period: Period.values[periodIndex]),
      TimetablePeriod(
          day: DayOfWeek.friday, period: Period.values[periodIndex]),
      TimetablePeriod(
          day: DayOfWeek.saturday, period: Period.values[periodIndex]),
      TimetablePeriod(
          day: DayOfWeek.sunday, period: Period.values[periodIndex]),
    ].sublist(0, numOfDays);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Center(
              child: Text(
                '${periodIndex + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          ...periods.map(
            (period) {
              final CourseModel? course = timetableMapWithCourseObject[period];
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    height: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: course != null
                          ? Color.fromARGB(255, 252, 120, 120)
                          : Colors.white10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: course != null
                        ? GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push<CourseModel?>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseDetailsView(
                                    course: course,
                                  ),
                                ),
                              );
                              if (result != null) {
                                currentTimetable = currentTimetable.copyWith(
                                  timetableMap: {
                                    ...currentTimetable.timetableMap,
                                    period: null,
                                  },
                                );
                              }
                            },
                            child: Text(
                              course.titles.join(', ').length > 17
                                  ? '${course.titles.join(', ').substring(0, 17)}...'
                                  : course.titles.join(', '),
                              textAlign: TextAlign.center, // 텍스트 가운데 정렬
                              style: const TextStyle(
                                  color: Colors.white), // 텍스트 색상을 흰색으로 변경
                            ),
                          )
                        : InkWell(
                            child: Container(
                              height: 100, // 교시 크기를 더 키움
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: const Color.fromARGB(26, 255, 255, 255),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(''), // 강의가 없으면 빈 텍스트
                            ),
                            onTap: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute<Course>(
                                  builder: (newContext) => BlocProvider(
                                    create: (context) => sl<TimetableCubit>(),
                                    child: TimetableSearchSheet(
                                      period: period,
                                      school: school,
                                      term: term,
                                    ),
                                  ),
                                ),
                              );
                              if (result != null) {
                                currentTimetable = currentTimetable.copyWith(
                                  timetableMap: {
                                    ...currentTimetable.timetableMap,
                                    period: result.courseId,
                                  },
                                );
                              }
                              setState(() {});
                            },
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGradeStatusCard() {
    return Container(
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
      child: const Column(
        children: [
          Text(
            '이수상황',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Placeholder(
            fallbackHeight: 200,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
