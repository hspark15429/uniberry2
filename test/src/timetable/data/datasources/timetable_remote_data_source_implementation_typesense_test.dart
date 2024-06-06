import 'package:flutter_test/flutter_test.dart';
import 'package:typesense/typesense.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source_implementation_typesense.dart';

void main() {
  late Client typesenseClient;
  late TimetableRemoteDataSource dataSource;

  final tSearchParameters = <String, dynamic>{
    'q': '',
    'query_by': 'periods,term,campuses,schools',
    'filter_by': 'campuses:衣笠,periods:月4',
    'include_fields': 'courseId',
  };
  final tResults = <String, dynamic>{
    'facet_counts': [],
    'found': 1,
    'hits': [
      {
        'document': {
          'courseId': '123',
        },
      },
    ],
  };

  setUp(() {
    const host = 'en26j4yxt9m7pfkip-1.a1.typesense.net';
    const protocol = Protocol.https;
    final config = Configuration(
      // Api key
      '058Tok9mJzeZggOm9u4I80UPGntwEEp1',
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
    dataSource = TimetableRemoteDataSourceImplementationTypesense(
      typesenseClient: typesenseClient,
    );
  });

  group('getCourse', () {
    test('gets data when successful', () async {
      // Arrange

      // Act
      final course = await dataSource.getCourse('tE28tbxmAZt6LHi4WTOJ');
      // Assert
      expect(course.courseId, equals('tE28tbxmAZt6LHi4WTOJ'));
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
      expect(courseIds, contains('tE28tbxmAZt6LHi4WTOJ'));
    });
  });
}
