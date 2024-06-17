import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/core/providers/user_provider.dart';
import 'package:uniberry2/core/services/injection_container.dart';
import 'package:uniberry2/core/utils/core_utils.dart';
import 'package:uniberry2/src/auth/data/models/user_model.dart';
import 'package:uniberry2/src/auth/presentation/cubit/authentication_cubit.dart';
import 'package:uniberry2/src/auth/presentation/views/sign_in_screen.dart';
import 'package:uniberry2/src/auth/presentation/views/sign_up_screen.dart';
import 'package:uniberry2/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:uniberry2/src/dashboard/presentation/views/dashboard.dart';
import 'package:uniberry2/src/dashboard/presentation/views/dashboard_screen.dart';
import 'package:uniberry2/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry2/src/forum/presentation/views/add_post_view.dart';
import 'package:uniberry2/src/forum/presentation/views/test/test_screen.dart';
import 'package:uniberry2/src/timetable/data/models/timetable_model.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/oldViews/timetable/timetable_screen.dart';

import 'package:uniberry2/src/timetable/presentation/views/newViews/timetable_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (context) {
          if (sl<FirebaseAuth>().currentUser != null) {
            final user = sl<FirebaseAuth>().currentUser!;
            final localUser = LocalUserModel(
              uid: user.uid,
              email: user.email ?? '',
              points: 0,
              fullName: user.displayName ?? '',
            );
            context.read<UserProvider>().initUser(localUser);
            return const Dashboard();
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

    default:
      return MaterialPageRoute(builder: (_) => const Placeholder());
  }
}
