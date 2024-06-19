part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  await initAuthentication();
  await initTimetable();
  await initForum();
  await initComment();
}

Future<void> initComment() async {
  // cubit
  sl
    ..registerFactory(
      () => CommentCubit(
        createComment: sl(),
        getCommentsByPostId: sl(),
        getCommentsByUserId: sl(),
        updateComment: sl(),
        deleteComment: sl(),
      ),
    )
    // usecases
    ..registerLazySingleton(() => CreateComment(sl()))
    ..registerLazySingleton(() => GetCommentsByPostId(sl()))
    ..registerLazySingleton(() => GetCommentsByUserId(sl()))
    ..registerLazySingleton(() => UpdateComment(sl()))
    ..registerLazySingleton(() => DeleteComment(sl()))
    // repo impl
    ..registerLazySingleton<CommentRepository>(
      () => CommentRepositoryImplementation(sl()),
    )
    // datasource impl
    ..registerLazySingleton<CommentRemoteDataSource>(
      () => CommentRemoteDataSourceImplementation(
        cloudStoreClient: sl(),
        dbClient: sl(),
      ),
    );
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
        createPostWithImage: sl(),
        readPost: sl(),
        readPosts: sl(),
        getPostsByUserId: sl(),
        updatePost: sl(),
        deletePost: sl(),
        searchPosts: sl(),
        searchPostsWithPageKey: sl(),
      ),
    )
    // usecases
    ..registerLazySingleton(() => CreatePost(sl()))
    ..registerLazySingleton(() => CreatePostWithImage(sl()))
    ..registerLazySingleton(() => ReadPost(sl()))
    ..registerLazySingleton(() => ReadPosts(sl()))
    ..registerLazySingleton(() => GetPostsByUserId(sl()))
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
        authClient: sl(),
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
