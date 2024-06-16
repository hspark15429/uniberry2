part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  await initAuthentication();
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
        createTimetable: sl(),
        readTimetable: sl(),
        updateTimetable: sl(),
        deleteTimetable: sl(),
      ),
    )
    // usecases
    ..registerLazySingleton(() => GetCourse(sl()))
    ..registerLazySingleton(() => SearchCourses(sl()))
    ..registerLazySingleton(() => CreateTimetable(sl()))
    ..registerLazySingleton(() => ReadTimetable(sl()))
    ..registerLazySingleton(() => UpdateTimetable(sl()))
    ..registerLazySingleton(() => DeleteTimetable(sl()))
    // repo impl
    ..registerLazySingleton<TimetableRepository>(
      () => TimetableRepositoryImplementation(sl()),
    )
    // data source impl
    ..registerLazySingleton<TimetableRemoteDataSource>(
      () => TimetableRemoteDataSourceImplementationTypesense(
        typesenseClient: sl(),
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
      ),
    )
    // external
    ..registerLazySingleton<Client>(
      () => Client(
        Configuration(
          dotenv.env['TYPESENSE_API_KEY']!,
          nodes: {
            Node(
              Protocol.https,
              dotenv.env['TYPESENSE_HOST']!,
              port: int.parse(dotenv.env['TYPESENSE_PORT']!),
            ),
          },
          numRetries: 2,
          connectionTimeout: const Duration(seconds: 2),
        ),
      ),
    );
}

Future<void> initForum() async {
  // cubit
  sl
    ..registerFactory(
      () => PostCubit(
        createPost: sl(),
        readPost: sl(),
        readPosts: sl(),
        updatePost: sl(),
        deletePost: sl(),
        searchPosts: sl(),
        searchPostsWithPageKey: sl(),
      ),
    )
    // usecases
    ..registerLazySingleton(() => CreatePost(sl()))
    ..registerLazySingleton(() => ReadPost(sl()))
    ..registerLazySingleton(() => ReadPosts(sl()))
    ..registerLazySingleton(() => UpdatePost(sl()))
    ..registerLazySingleton(() => DeletePost(sl()))
    ..registerLazySingleton(() => SearchPosts(sl()))
    ..registerLazySingleton(() => SearchPostsWithPageKey(sl()))
    // repo impl
    ..registerLazySingleton<PostRepository>(
      () => PostRepositoryImplementation(sl()),
    )
    // datasource impl
    ..registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImplementation(
        cloudStoreClient: sl(),
        dbClient: sl(),
        typesenseClient: sl(),
      ),
    );
}

Future<void> initAuthentication() async {
  // cubit
  sl
    ..registerFactory(
      () => AuthenticationCubit(
        forgotPassword: sl(),
        signIn: sl(),
        signUp: sl(),
        updateUser: sl(),
      ),
    )
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
