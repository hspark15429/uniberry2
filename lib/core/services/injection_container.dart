import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source_implementation.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source_implementation_algolia.dart';
import 'package:uniberry2/src/timetable/data/repositories/timetable_repository_implementation.dart';
import 'package:uniberry2/src/timetable/domain/repository/timetable_repository.dart';
import 'package:uniberry2/src/timetable/domain/usecases/get_course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/search_courses.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await initTimetable();
}

Future<void> initTimetable() async {
  // cubit
  sl
    ..registerFactory(
      () => TimetableCubit(getCourse: sl(), searchCourses: sl()),
    )

    // usecases
    ..registerLazySingleton(() => GetCourse(sl()))
    ..registerLazySingleton(() => SearchCourses(sl()))

    // repo impl
    ..registerLazySingleton<TimetableRepository>(
      () => TimetableRepositoryImplementation(sl()),
    )

    // data source impl
    ..registerLazySingleton<TimetableRemoteDataSource>(
      () =>
          TimetableRemoteDataSourceImplementationAlgolia(coursesSearcher: sl()),
    )

    // external
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(
      () => HitsSearcher(
        applicationID: 'K1COUI4FQ4',
        apiKey: '00383db0c4d34b63decf046026091f32',
        indexName: 'courses_index',
      ),
    );
}
