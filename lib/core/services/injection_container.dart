import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:typesense/typesense.dart';
import 'package:uniberry2/src/auth/data/datasources/authentication_remote_data_source.dart';
import 'package:uniberry2/src/auth/data/repositories/authentication_repository_implementation.dart';
import 'package:uniberry2/src/auth/domain/repository/authentication_repository.dart';
import 'package:uniberry2/src/auth/domain/usecases/forgot_password.dart';
import 'package:uniberry2/src/auth/domain/usecases/sign_in.dart';
import 'package:uniberry2/src/auth/domain/usecases/sign_up.dart';
import 'package:uniberry2/src/auth/domain/usecases/update_user.dart';
import 'package:uniberry2/src/auth/presentation/cubit/authentication_cubit.dart';
import 'package:uniberry2/src/forum/data/datasources/post_remote_data_source.dart';
import 'package:uniberry2/src/forum/data/repositories/post_repository_implementation.dart';
import 'package:uniberry2/src/forum/domain/repository/post_repository.dart';
import 'package:uniberry2/src/forum/domain/usecases/create_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/delete_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/read_post.dart';
import 'package:uniberry2/src/forum/domain/usecases/search_posts.dart';
import 'package:uniberry2/src/forum/domain/usecases/update_post.dart';
import 'package:uniberry2/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_local_data_source_implementation.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source_implementation.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source_implementation_algolia.dart';
import 'package:uniberry2/src/timetable/data/datasources/timetable_remote_data_source_implementation_typesense.dart';
import 'package:uniberry2/src/timetable/data/repositories/timetable_repository_implementation.dart';
import 'package:uniberry2/src/timetable/domain/repository/timetable_repository.dart';
import 'package:uniberry2/src/timetable/domain/usecases/get_course.dart';
import 'package:uniberry2/src/timetable/domain/usecases/search_courses.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';

part 'injection_container.main.dart';
