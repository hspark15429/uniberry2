import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/core/utils/core_utils.dart';
import 'package:uniberry/src/auth/data/models/user_model.dart';
import 'package:uniberry/src/auth/presentation/cubit/authentication_cubit.dart';
import 'package:uniberry/src/auth/presentation/views/sign_in_screen.dart';
import 'package:uniberry/src/auth/presentation/views/sign_up_screen.dart';
import 'package:uniberry/src/comment/presentation/cubit/comment_cubit.dart';
import 'package:uniberry/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:uniberry/src/dashboard/presentation/views/dashboard.dart';
import 'package:uniberry/src/forum/domain/entities/post.dart';
import 'package:uniberry/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry/src/forum/presentation/views/add_post_view.dart';
import 'package:uniberry/src/forum/presentation/views/post_details_view.dart';
import 'package:uniberry/src/timetable/data/models/timetable_model.dart';
import 'package:uniberry/src/timetable/presentation/cubit/timetable_cubit.dart';

import 'package:uniberry/src/timetable/presentation/views/newViews/timetable_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (context) {
          if (sl<FirebaseAuth>().currentUser != null &&
              sl<FirebaseAuth>().currentUser!.emailVerified) {
            final user = sl<FirebaseAuth>().currentUser!;
            final localUser = LocalUserModel(
              uid: user.uid,
              email: user.email ?? '',
              points: 0,
              fullName: user.displayName ?? '',
            );
            context.read<UserProvider>().initUser(localUser);
            return const Dashboard();
          } else if (sl<FirebaseAuth>().currentUser == null) {
            return BlocProvider(
              create: (_) => sl<AuthenticationCubit>(),
              child: const SignInScreen(),
            );
          } else {
            return BlocProvider(
              create: (_) => sl<AuthenticationCubit>(),
              child: const SignInScreen(),
            );
          }
        },
      );

    case Dashboard.routeName:
      return MaterialPageRoute(
        builder: (_) => const Dashboard(),
      );
    case SignInScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<AuthenticationCubit>(),
          child: const SignInScreen(),
        ),
      );
    case SignUpScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<AuthenticationCubit>(),
          child: const SignUpScreen(),
        ),
      );
    case '/forgot-password':
      return MaterialPageRoute(
        builder: (_) => const fui.ForgotPasswordScreen(),
      );

    case AddPostView.id:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => sl<PostCubit>(),
          child: const AddPostView(),
        ),
      );
    case PostDetailsView.id:
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<PostCubit>(),
            ),
            BlocProvider(
              create: (context) => sl<CommentCubit>(),
            ),
          ],
          child: PostDetailsView(settings.arguments! as Post),
        ),
      );
    default:
      return MaterialPageRoute(builder: (_) => const Placeholder());
  }
}
