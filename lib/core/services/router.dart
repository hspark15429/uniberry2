import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/core/providers/user_provider.dart';
import 'package:uniberry2/core/services/injection_container.dart';
import 'package:uniberry2/src/auth/data/models/user_model.dart';
import 'package:uniberry2/src/auth/presentation/cubit/authentication_cubit.dart';
import 'package:uniberry2/src/auth/presentation/views/sign_in_screen.dart';
import 'package:uniberry2/src/auth/presentation/views/sign_up_screen.dart';
import 'package:uniberry2/src/dashboard/presentation/views/dashboard_screen.dart';
import 'package:uniberry2/src/forum/presentation/cubit/post_cubit.dart';
import 'package:uniberry2/src/forum/presentation/views/test/test_screen.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable_screen.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable_screen2.dart';

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
            return const DashboardScreen();
          } else {
            return BlocProvider(
              create: (_) => sl<AuthenticationCubit>(),
              child: const SignInScreen(),
            );
          }
        },
      );

    case '/dashboard':
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
            return const DashboardScreen();
          } else {
            return BlocProvider(
              create: (_) => sl<AuthenticationCubit>(),
              child: const SignInScreen(),
            );
          }
        },
      );

    case TimetableScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<TimetableCubit>(),
          child: const TimetableScreen(),
        ),
      );
    case TimetableScreen2.routeName:
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

    // case '/test':
    //   return MaterialPageRoute(builder: (_) => const MyHomePage());

    default:
      return MaterialPageRoute(builder: (_) => const Placeholder());
  }
}
