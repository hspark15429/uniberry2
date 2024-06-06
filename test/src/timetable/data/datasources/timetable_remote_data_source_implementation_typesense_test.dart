import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typesense/typesense.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source_implementation_typesense.dart';

void main() async {
  late Client typesenseClient;
  late TimetableRemoteDataSource dataSource;

  setUp(() async {
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
    dataSource = TimetableRemoteDataSourceImplementationTypesense(
      typesenseClient: typesenseClient,
    );
  });

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
}
