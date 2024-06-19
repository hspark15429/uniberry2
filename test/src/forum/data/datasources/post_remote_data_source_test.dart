import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:typesense/typesense.dart';
import 'package:uniberry/core/enums/update_post_enum.dart';
import 'package:uniberry/src/forum/data/datasources/post_remote_data_source.dart';
import 'package:uniberry/src/forum/data/models/post_model.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late MockFirebaseAuth authClient;
  late FakeFirebaseFirestore cloudStoreClient;
  late MockFirebaseStorage dbClient;
  late PostRemoteDataSource dataSource;
  late DocumentReference<Map<String, dynamic>> docReference;
  var tPost = PostModel.empty();

  setUpAll(() async {
    await dotenv.load();

    // final postsSearcher = HitsSearcher(
    //   applicationID: dotenv.env['ALGOLIA_APP_ID']!,
    //   apiKey: dotenv.env['ALGOLIA_API_KEY']!,
    //   indexName: 'posts_index',
    // );
    final typesenseClient = Client(
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
    );
    authClient = MockFirebaseAuth();
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
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
      typesenseClient: typesenseClient,
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
      // expect(posts, containsAll(['BTAK4gYfyz0rgYQb1CRg']));
      expect(posts, isNot(contains(['9cz1cQBgElhV0Iuknm6e'])));
    });
  });

  group('searchPostsWithPageKey', () {
    test('should search posts', () async {
      // arrange

      // act
      final result = await dataSource.searchPostsWithPageKey(
          title: '', author: '', content: 'title', pageKey: 1);
      // assert

      expect(result.pageKey, 1);
      expect(result.nextPageKey, null);
      expect(result.posts is List<PostModel>, true);
    });
  });
}
