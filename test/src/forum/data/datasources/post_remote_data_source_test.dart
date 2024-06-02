import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/src/forum/data/datasources/post_remote_data_source.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late MockFirebaseAuth authClient;
  late FakeFirebaseFirestore cloudStoreClient;
  late MockFirebaseStorage dbClient;
  late PostRemoteDataSource dataSource;
  late DocumentReference<Map<String, dynamic>> docReference;
  var tPost = const PostModel.empty();

  setUpAll(() async {
    cloudStoreClient = FakeFirebaseFirestore();
    docReference = await cloudStoreClient.collection('posts').add(
          tPost.toMap(),
        );
    await cloudStoreClient.collection('posts').doc(docReference.id).update(
      {'postId': docReference.id},
    );
    tPost = tPost.copyWith(postId: docReference.id);
    dbClient = MockFirebaseStorage();
    dataSource = PostRemoteDataSourceImplementation(
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
    );
  });

  group('createPost', () {
    test('should create a post', () async {
      // arrange

      // act
      await dataSource.createPost(tPost);
      // assert
      final post =
          await cloudStoreClient.collection('posts').doc(tPost.postId).get();
      debugPrint(post.data().toString());
      expect(post.data()!['postId'], tPost.postId);
    });
  });
}
