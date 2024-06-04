part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await initTimetable();
  await initForum();
}

Future<void> initTimetable() async {
  // cubit
  sl
    ..registerFactory(
      () => TimetableCubit(
        getCourse: sl(),
        searchCourses: sl(),
      ),
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
      () => TimetableRemoteDataSourceImplementationAlgolia(
        coursesSearcher: sl(instanceName: 'coursesSearcher'),
      ),
    )
    // external
    ..registerLazySingleton(
      () => HitsSearcher(
        applicationID: 'K1COUI4FQ4',
        apiKey: '00383db0c4d34b63decf046026091f32',
        indexName: 'courses_index',
      ),
      instanceName: 'coursesSearcher',
    );
}

Future<void> initForum() async {
  // cubit
  sl
    ..registerFactory(
      () => PostCubit(
        createPost: sl(),
        readPost: sl(),
        updatePost: sl(),
        deletePost: sl(),
        searchPosts: sl(),
      ),
    )
    // usecases
    ..registerLazySingleton(() => CreatePost(sl()))
    ..registerLazySingleton(() => ReadPost(sl()))
    ..registerLazySingleton(() => UpdatePost(sl()))
    ..registerLazySingleton(() => DeletePost(sl()))
    ..registerLazySingleton(() => SearchPosts(sl()))
    // repo impl
    ..registerLazySingleton<PostRepository>(
      () => PostRepositoryImplementation(sl()),
    )
    // datasource impl
    ..registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImplementation(
        cloudStoreClient: sl(),
        dbClient: sl(),
        postsSearcher: sl(instanceName: 'postsSearcher'),
      ),
    )
    // external
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance)
    // external
    ..registerLazySingleton(
        () => HitsSearcher(
              applicationID: 'K1COUI4FQ4',
              apiKey: '00383db0c4d34b63decf046026091f32',
              indexName: 'posts_index',
            ),
        instanceName: 'postsSearcher');
}
