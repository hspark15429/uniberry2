import 'package:mocktail/mocktail.dart';
import 'package:uniberry2/src/forum/domain/repository/comment_repository.dart';
import 'package:uniberry2/src/forum/domain/repository/post_repository.dart';

class MockPostRepository extends Mock implements PostRepository {}

class MockCommentRepository extends Mock implements CommentRepository {}
