import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typesense/typesense.dart';
import 'package:uniberry/src/auth/data/datasources/authentication_remote_data_source.dart';
import 'package:uniberry/src/auth/data/repositories/authentication_repository_implementation.dart';
import 'package:uniberry/src/auth/domain/repository/authentication_repository.dart';
import 'package:uniberry/src/auth/domain/usecases/forgot_password.dart';
import 'package:uniberry/src/auth/domain/usecases/sign_in.dart';
import 'package:uniberry/src/auth/domain/usecases/sign_up.dart';
import 'package:uniberry/src/auth/domain/usecases/update_user.dart';
import 'package:uniberry/src/auth/presentation/cubit/authentication_cubit.dart';
import 'package:uniberry/src/comment/data/datasources/comment_remote_data_source.dart';
import 'package:uniberry/src/comment/data/repositories/comment_repository_implementation.dart';
import 'package:uniberry/src/comment/domain/repository/comment_repository.dart';
import 'package:uniberry/src/comment/domain/usecases/create_comment.dart';
import 'package:uniberry/src/comment/domain/usecases/delete_comment.dart';
import 'package:uniberry/src/comment/domain/usecases/get_comments_by_parent_comment_id.dart';
import 'package:uniberry/src/comment/domain/usecases/get_comments_by_post_id.dart';
import 'package:uniberry/src/comment/domain/usecases/get_comments_by_user_id.dart';
import 'package:uniberry/src/comment/domain/usecases/update_comment.dart';
import 'package:uniberry/src/comment/presentation/cubit/comment_cubit.dart';
import 'package:uniberry/src/forum/data/datasources/post_remote_data_source.dart';
import 'package:uniberry/src/forum/data/repositories/post_repository_implementation.dart';
import 'package:uniberry/src/forum/domain/repository/post_repository.dart';
import 'package:uniberry/src/forum/domain/usecases/course_review/get_course_reviews_all.dart';
import 'package:uniberry/src/forum/domain/usecases/course_review/read_couse_reviews.dart';
import 'package:uniberry/src/forum/domain/usecases/create_post.dart';
import 'package:uniberry/src/forum/domain/usecases/create_post_with_image.dart';
import 'package:uniberry/src/forum/domain/usecases/delete_post.dart';
import 'package:uniberry/src/forum/domain/usecases/get_posts_by_user_id.dart';
import 'package:uniberry/src/forum/domain/usecases/read_post.dart';
import 'package:uniberry/src/forum/domain/usecases/read_posts.dart';
import 'package:uniberry/src/forum/domain/usecases/search_posts.dart';
import 'package:uniberry/src/forum/domain/usecases/search_posts_with_page_key.dart';
import 'package:uniberry/src/forum/domain/usecases/update_post.dart';
import 'package:uniberry/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry/src/timetable/data/datasources/timetable_remote_data_source_implementation_typesense.dart';
import 'package:uniberry/src/timetable/data/repositories/timetable_repository_implementation.dart';
import 'package:uniberry/src/timetable/domain/repository/timetable_repository.dart';
import 'package:uniberry/src/timetable/domain/usecases/create_timetable.dart';
import 'package:uniberry/src/timetable/domain/usecases/delete_timetable.dart';
import 'package:uniberry/src/timetable/domain/usecases/get_course.dart';
import 'package:uniberry/src/timetable/domain/usecases/read_timetable.dart';
import 'package:uniberry/src/timetable/domain/usecases/search_courses.dart';
import 'package:uniberry/src/timetable/domain/usecases/update_timetable.dart';
import 'package:uniberry/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry/src/forum/data/datasources/course_review_remote_data_source.dart'; // 추가된 부분
import 'package:uniberry/src/forum/data/repositories/course_review_repository_implementation.dart'; // 추가된 부분
import 'package:uniberry/src/forum/domain/repository/course_review_repository.dart'; // 추가된 부분
import 'package:uniberry/src/forum/domain/usecases/course_review/create_course_review.dart'; // 추가된 부분
import 'package:uniberry/src/forum/domain/usecases/course_review/delete_course_review.dart'; // 추가된 부분
import 'package:uniberry/src/forum/domain/usecases/course_review/get_course_reviews_by_user_id.dart'; // 추가된 부분
import 'package:uniberry/src/forum/domain/usecases/course_review/read_course_review.dart'; // 추가된 부분
import 'package:uniberry/src/forum/domain/usecases/course_review/search_course_review.dart'; // 추가된 부분
import 'package:uniberry/src/forum/domain/usecases/course_review/search_course_review_with_page_key.dart'; // 추가된 부분
import 'package:uniberry/src/forum/domain/usecases/course_review/update_course_review.dart'; // 추가된 부분
import 'package:uniberry/src/forum/presentation/cubit/course_review_cubit.dart'; // 추가된 부분

part 'injection_container.main.dart';
