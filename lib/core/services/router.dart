import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/core/services/injection_container.dart';
import 'package:uniberry2/src/auth/presentation/cubit/authentication_cubit.dart';
import 'package:uniberry2/src/auth/presentation/views/sign_in_screen.dart';
import 'package:uniberry2/src/auth/presentation/views/sign_up_screen.dart';
import 'package:uniberry2/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry2/src/forum/presentation/views/test/test_screen.dart';
import 'package:uniberry2/src/home/presentation/views/home_screen.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/test_screen.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const MainScreen());
    case TimetableScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<TimetableCubit>(),
          child: const TimetableScreen(),
        ),
      );
    case ForumScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<PostCubit>(),
          child: const ForumScreen(),
        ),
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

    case '/test':
      return MaterialPageRoute(builder: (_) => const MyHomePage());

    default:
      return MaterialPageRoute(builder: (_) => const Placeholder());
  }
}
