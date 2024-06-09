import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:typesense/typesense.dart';
import 'package:uniberry2/src/auth/data/models/user_model.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source_implementation_typesense.dart';
import 'package:uniberry2/src/timetable/data/models/timetable_model.dart';

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
  late DocumentReference<Map<String, dynamic>> docReference;
  late DocumentReference<Map<String, dynamic>> docReferenceTimetable;
  late MockUserCredential tUserCredential;
  const tUser = LocalUserModel.empty();
  var tTimetable = TimetableModel.empty();
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
    docReference = await cloudStoreClient.collection('users').add(
          tUser.toMap(),
        );

    await cloudStoreClient.collection('users').doc(docReference.id).update(
      {'uid': docReference.id},
    );

    mockUser = MockUser()..uid = docReference.id;
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
          await cloudStoreClient.collection('timetables').limit(1).get();
      // Assert
      expect(
        timetableMap.docs.first.data()['timetableId'],
        isNot(tTimetable.timetableId),
      );
      expect(
        timetableMap.docs.first.data()['uid'],
        isNot(tTimetable.uid),
      );
      expect(
        timetableMap.docs.first.data()['name'],
        equals(tTimetable.name),
      );
      expect(
        timetableMap.docs.first.data()['timetableMap'],
        equals({'monday.period1': '_empty.courseId'}),
      );
    });
  });
}
