import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';

void main() {
  late FirebaseFirestore cloudStoreClient;
  late TimetableRemoteDataSource dataSource;
  late DocumentReference<DataMap> documentReference;
  late DocumentReference<DataMap> documentReference2;

  const tCourse = CourseModel.empty();

  setUpAll(() async {
    cloudStoreClient = FakeFirebaseFirestore();
    documentReference = cloudStoreClient.collection('courses').doc();
    documentReference2 = cloudStoreClient.collection('courses').doc();

    await documentReference.set(
      tCourse.copyWith(
        courseId: documentReference.id,
        schools: ['Engineering'],
      ).toMap(),
    );
    await documentReference2.set(
      tCourse
          .copyWith(
            courseId: documentReference2.id,
            schools: ['Medicine'],
            term: 'Spring',
          )
          .toMap(),
    );

    dataSource =
        TimetableRemoteDataSourceImpl(cloudStoreClient: cloudStoreClient);
  });

  group('getCourse', () {
    test('getCourse success', () async {
      final result = await dataSource.getCourse(documentReference.id);
      expect(result, tCourse.copyWith(courseId: documentReference.id));
    });
    test('getCourse fail', () async {
      final methodCall = dataSource.getCourse;
      expect(
        methodCall('sss'),
        throwsA(
          const ServerException(
            message: 'course not found',
            statusCode: 'no-data',
          ),
        ),
      );
    });
  });

  group('searchCourses', () {
    test('searchCourses success', () async {
      final result = await dataSource.searchCourses(
        school: 'Engineering',
        campus: '',
        term: '',
        period: '',
      );
      expect(result, contains(documentReference.id));

      final result2 = await dataSource.searchCourses(
        school: '',
        campus: '',
        term: 'Spring',
        period: '',
      );
      expect(result2, contains(documentReference2.id));

      final result3 = await dataSource.searchCourses(
        school: '',
        campus: '',
        term: '',
        period: '',
      );

      expect(
        result3,
        containsAll([documentReference.id, documentReference2.id]),
      );
    });
  });
}
