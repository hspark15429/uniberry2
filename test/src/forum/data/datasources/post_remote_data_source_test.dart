import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/core/enums/update_post_enum.dart';
import 'package:uniberry2/src/forum/data/datasources/post_remote_data_source.dart';
import 'package:uniberry2/src/forum/data/models/post_model.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late MockFirebaseAuth authClient;
  late FakeFirebaseFirestore cloudStoreClient;
  late MockFirebaseStorage dbClient;
  late PostRemoteDataSource dataSource;
  late DocumentReference<Map<String, dynamic>> docReference;
  var tPost = PostModel.empty();

  setUpAll(() async {
    final postsSearcher = HitsSearcher(
      applicationID: 'K1COUI4FQ4',
      apiKey: '00383db0c4d34b63decf046026091f32',
      indexName: 'posts_index',
    );

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
      postsSearcher: postsSearcher,
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
      expect(post.data()!['postId'], tPost.postId);
    });
  });

  group('readPost', () {
    test('should read a post', () async {
      // arrange

      // act
      final post = await dataSource.readPost(tPost.postId);
      // assert
      expect(post, tPost);
    });
  });

  group('updatePost', () {
    test('should update a post', () async {
      // arrange

      // act
      await dataSource.updatePost(
        postId: tPost.postId,
        action: UpdatePostAction.title,
        postData: 'new title',
      );
      // assert
      final post =
          await cloudStoreClient.collection('posts').doc(tPost.postId).get();
      expect(post.data()!['title'], 'new title');
    });
  });

  group('deletePost', () {
    test('should delete a post', () async {
      // arrange

      // act
      await dataSource.deletePost(tPost.postId);
      final post =
          await cloudStoreClient.collection('posts').doc(tPost.postId).get();
      // assert
      expect(post.data(), null);
    });
  });

  group('searchPosts', () {
    test('should search posts', () async {
      // arrange

      // act
      final posts = await dataSource.searchPosts(
        title: '',
        author: '',
        content: 'helloworld',
      );
      // assert
      expect(posts, containsAll(['8gxbkrZ0EffayaTyU1NK']));
      expect(posts, isNot(contains(['9cz1cQBgElhV0Iuknm6e'])));
    });
  });
}
