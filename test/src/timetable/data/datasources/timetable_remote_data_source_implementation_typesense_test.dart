import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:typesense/typesense.dart';
import 'package:uniberry/src/auth/data/models/user_model.dart';
import 'package:uniberry/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry/src/timetable/data/datasources/timetable_remote_data_source_implementation_typesense.dart';
import 'package:uniberry/src/timetable/data/models/timetable_model.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = 'Test uid';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;
  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() async {
  late MockFirebaseAuth authClient;
  late FakeFirebaseFirestore cloudStoreClient;
  late MockFirebaseStorage dbClient;
  late MockUser mockUser;
  late DocumentReference<Map<String, dynamic>> docReferenceUser;
  late DocumentReference<Map<String, dynamic>> docReferenceTimetable;
  late MockUserCredential tUserCredential;
  const tUser = LocalUserModel.empty();
  final tTimetable = TimetableModel.empty();
  late Client typesenseClient;
  late TimetableRemoteDataSource dataSource;

  setUpAll(() async {
    await dotenv.load();
    final host = dotenv.env['TYPESENSE_HOST']!;
    const protocol = Protocol.https;
    final config = Configuration(
      // Api key
      dotenv.env['TYPESENSE_API_KEY']!,
      nodes: {
        Node(
          protocol,
          host,
          port: 443,
        ),
      },
      numRetries: 3, // A total of 4 tries (1 original try + 3 retries)
      connectionTimeout: const Duration(seconds: 2),
    );

    typesenseClient = Client(config);

    cloudStoreClient = FakeFirebaseFirestore();
    docReferenceUser = await cloudStoreClient.collection('users').add(
          tUser.toMap(),
        );

    await cloudStoreClient.collection('users').doc(docReferenceUser.id).update(
      {'uid': docReferenceUser.id},
    );

    mockUser = MockUser()..uid = docReferenceUser.id;
    tUserCredential = MockUserCredential(mockUser);
    dbClient = MockFirebaseStorage();
    authClient = MockFirebaseAuth();
    when(() => authClient.currentUser).thenReturn(mockUser);

    dataSource = TimetableRemoteDataSourceImplementationTypesense(
      typesenseClient: typesenseClient,
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
    );
  });

  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted.',
  );

  group('getCourse', () {
    test('gets data when successful', () async {
      // Arrange

      // Act
      final course =
          await dataSource.getCourse('6da609922f8449beb9d4b0d94f53a00a');
      // Assert
      expect(course.courseId, equals('6da609922f8449beb9d4b0d94f53a00a'));
    });
  });
  group('searchCourses', () {
    test('gets data when successful', () async {
      // Arrange

      // Act
      final courseIds = await dataSource.searchCourses(
        school: '',
        campus: '衣笠',
        term: '',
        period: '月4',
      );
      // Assert
      expect(courseIds, contains('6da609922f8449beb9d4b0d94f53a00a'));
    });
  });

  group('createTimetable', () {
    test('creates data when successful', () async {
      // Arrange

      // Act
      await dataSource.createTimetable(tTimetable);
      final timetableMap =
          (await cloudStoreClient.collection('timetables').limit(1).get())
              .docs
              .first
              .data();
      // Assert
      expect(
        timetableMap['timetableId'],
        isNot(tTimetable.timetableId),
      );
      expect(
        timetableMap['uid'],
        isNot(tTimetable.uid),
      );
      expect(
        timetableMap['name'],
        equals(tTimetable.name),
      );
      expect(
        timetableMap['timetableMap'],
        equals({'monday.period1': '_empty.courseId'}),
      );
    });
  });

  group('readTimetable', () {
    test('gets data when successful', () async {
      // Arrange
      await dataSource.createTimetable(tTimetable);
      final timetableMap =
          (await cloudStoreClient.collection('timetables').limit(1).get())
              .docs
              .first
              .data();

      // Act
      final timetable =
          await dataSource.readTimetable(timetableMap['timetableId'] as String);
      // Assert
      expect(timetable.timetableId, equals(timetableMap['timetableId']));
    });
  });

  group('updateTimetable', () {
    test('updates data when successful', () async {
      // Arrange
      await dataSource.createTimetable(tTimetable);
      final timetableMap =
          (await cloudStoreClient.collection('timetables').limit(1).get())
              .docs
              .first
              .data();
      final updatedTimetable = tTimetable.copyWith(
        uid: timetableMap['uid'] as String,
        timetableId: timetableMap['timetableId'] as String,
        name: 'Updated name',
      );

      // Act
      await dataSource.updateTimetable(
        timetableId: timetableMap['timetableId'] as String,
        timetable: updatedTimetable,
      );
      final updatedTimetableMap =
          (await cloudStoreClient.collection('timetables').limit(1).get())
              .docs
              .first
              .data();
      // Assert
      expect(
        updatedTimetableMap['timetableId'],
        equals(timetableMap['timetableId']),
      );
      expect(
        updatedTimetableMap['uid'],
        equals(timetableMap['uid']),
      );
      expect(
        updatedTimetableMap['name'],
        equals(updatedTimetable.name),
      );
      expect(
        updatedTimetableMap['timetableMap'],
        equals({'monday.period1': '_empty.courseId'}),
      );
    });
  });

  group('deleteTimetable', () {
    test('deletes data when successful', () async {
      // Arrange

      await dataSource.createTimetable(tTimetable);
      final timetableMap =
          (await cloudStoreClient.collection('timetables').limit(1).get())
              .docs
              .first
              .data();

      // Act
      await dataSource.deleteTimetable(timetableMap['timetableId'] as String);
      final result = (await cloudStoreClient
              .collection('timetables')
              .doc(timetableMap['timetableId'] as String)
              .get())
          .exists;
      // Assert
      expect(result, isFalse);
    });
  });
}
