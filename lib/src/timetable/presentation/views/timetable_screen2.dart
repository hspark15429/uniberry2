import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uniberry2/core/providers/user_provider.dart';
import 'package:uniberry2/core/services/injection_container.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';
import 'package:uniberry2/src/timetable/data/models/timetable_model.dart';
import 'package:uniberry2/src/timetable/domain/entities/course.dart';
import 'package:uniberry2/src/timetable/domain/entities/timetable.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/newViews/search_courses_sheet.dart';
import 'package:uniberry2/src/timetable/presentation/views/newViews/timetable_cell_card.dart';
import 'package:uniberry2/src/timetable/presentation/views/newViews/update_timetable_list_sheet.dart';
import 'package:uniberry2/src/timetable/presentation/widgets/timetable_header_widget.dart';

class TimetableScreen2 extends StatefulWidget {
  const TimetableScreen2({super.key});

  static const String routeName = '/timetable2';

  @override
  State<TimetableScreen2> createState() => _TimetableScreen2State();
}

class _TimetableScreen2State extends State<TimetableScreen2> {
  TimetableModel _currentTimetable = TimetableModel.empty().copyWith(
    name: '시간표를 선택하세요.',
  );
  Map<TimetablePeriod, CourseModel> timetableMapWithCourseObject = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void switchCurrentTimetable(TimetableModel timetable) {
    setState(() {
      _currentTimetable = timetable;
      timetableMapWithCourseObject = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<TimetableCubit>().getCourses(
          _currentTimetable.timetableMap.values.whereType<String>().toList(),
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
                    context
                        .read<TimetableCubit>()
                        .getTimetables(provider.user!.timetableIds);
                    return UpdateTimetableListSheet(
                      switchCurrentTimetable: switchCurrentTimetable,
                    );
                  },
                ),
              ),
            );
            if (newTimetable != null) {
              setState(() {
                _currentTimetable = newTimetable;
                timetableMapWithCourseObject = {};
              });
            }
          },
          child: Text(
            _currentTimetable.name,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.school, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                TimetableHeaderWidget(numOfDays: _currentTimetable.numOfDays),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: BlocBuilder<TimetableCubit, TimetableState>(
                builder: (context, state) {
                  if (state is CoursesFetched) {
                    _currentTimetable.timetableMap.forEach((period, courseId) {
                      if (courseId is String && courseId.isNotEmpty) {
                        timetableMapWithCourseObject[period] = state.courses
                                .firstWhere(
                                    (course) => course.courseId == courseId)
                            as CourseModel;
                      }
                    });
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
                        _buildGradeStatusCard(),
                        const SizedBox(height: 300),
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
                        _buildGradeStatusCard(),
                        const SizedBox(height: 300),
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
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    height: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: timetableMapWithCourseObject[period] != null
                        ? TimetableCellCard(
                            period: period,
                            course: timetableMapWithCourseObject[period]!,
                          )
                        : InkWell(
                            child: Container(
                              height: 100, // 교시 크기를 더 키움
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(''), // 강의가 없으면 빈 텍스트
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (newContext) => BlocProvider(
                                    create: (context) => sl<TimetableCubit>(),
                                    child: SearchCoursesSheet(
                                      period: period,
                                      school: '法学部',
                                      term: '春セメスター', // 2024년봄학기
                                    ),
                                  ),
                                ),
                              );
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
