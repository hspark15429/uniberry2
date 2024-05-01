import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/core/errors/exceptions.dart';
import 'package:uniberry2/core/utils/typedefs.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/models/course_model.dart';

void main() {
  late FirebaseFirestore cloudStoreClient;
  late TimetableRemoteDataSource dataSource;
  late DocumentReference<DataMap> documentReference;

  const tCourse = CourseModel(
    professor: 'John Doe',
    title: 'Math',
    code: 'MATH101',
  );

  setUpAll(() async {
    cloudStoreClient = FakeFirebaseFirestore();
    documentReference =
        cloudStoreClient.collection('courses').doc(tCourse.code);
    await documentReference.set(tCourse.toMap());

    dataSource =
        TimetableRemoteDataSourceImpl(cloudStoreClient: cloudStoreClient);
  });

  group('getCourse', () {
    test('getCourse success', () async {
      final result = await dataSource.getCourse(documentReference.id);
      expect(result, tCourse);
      debugPrint('result: $result');
    });
    test('getCourse fail', () async {
      final methodCall = dataSource.getCourse;
      expect(
          methodCall('sss'),
          throwsA(const ServerException(
              message: 'course not found', statusCode: 'no-data')));
    });
  });
}
