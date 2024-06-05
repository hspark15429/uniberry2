part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await initAuthentication();
  await initTimetable();
  await initForum();
}

Future<void> initTimetable() async {
  final _jsonCourses = await rootBundle.loadString('assets/temp/courses.json');

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
    // ..registerLazySingleton<TimetableRemoteDataSource>(
    //   () => TimetableRemoteDataSourceImplementationAlgolia(
    //     coursesSearcher: sl(instanceName: 'coursesSearcher'),
    //   ),
    // )
    ..registerLazySingleton<TimetableRemoteDataSource>(
      () => TimetableLocalDataSourceImplementation(jsonCourses: _jsonCourses),
    );
  // external
  // ..registerLazySingleton(
  //   () => HitsSearcher(
  //     applicationID: 'K1COUI4FQ4',
  //     apiKey: '00383db0c4d34b63decf046026091f32',
  //     indexName: 'courses_index',
  //   ),
  //   instanceName: 'coursesSearcher',
  // )
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
    // // external
    // ..registerLazySingleton(() => FirebaseAuth.instance)
    // ..registerLazySingleton(() => FirebaseFirestore.instance)
    // ..registerLazySingleton(() => FirebaseStorage.instance)
    // external
    ..registerLazySingleton(
        () => HitsSearcher(
              applicationID: 'K1COUI4FQ4',
              apiKey: '00383db0c4d34b63decf046026091f32',
              indexName: 'posts_index',
            ),
        instanceName: 'postsSearcher');
}

Future<void> initAuthentication() async {
  // cubit
  sl
    ..registerFactory(() => AuthenticationCubit(
          forgotPassword: sl(),
          signIn: sl(),
          signUp: sl(),
          updateUser: sl(),
        ))
    // usecases
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    // repo impl
    ..registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImplementation(sl()),
    )
    // data source impl
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthenticationRemoteDataSourceImplementation(
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}
