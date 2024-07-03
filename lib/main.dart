import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart'; // 로케일 초기화를 위한 import 추가
import 'package:provider/provider.dart';
import 'package:uniberry/core/lang/jp.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/res/colours.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/core/services/router.dart';
import 'package:uniberry/firebase_options.dart';
import 'package:uniberry/src/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:uniberry/src/forum/presentation/cubit/course_review_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load();
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        BlocProvider(
            create: (_) => sl<CourseReviewCubit>()), // CourseReviewCubit 추가
      ],
      child: MaterialApp(
        localizationsDelegates: [
          // Creates an instance of FirebaseUILocalizationDelegate with overridden labels
          FirebaseUILocalizations.withDefaultOverrides(const LabelOverrides()),

          // Delegates below take care of built-in flutter widgets
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,

          // This delegate is required to provide the labels that are not overridden by LabelOverrides
          FirebaseUILocalizations.delegate,
        ],
        title: 'Uniberry',
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(color: Colors.white),
            toolbarTextStyle: TextStyle(color: Colors.white),
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),
            color: Colors.black,
            elevation: 0,
            centerTitle: true,
          ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colours.primaryBlack,
          ),
          scaffoldBackgroundColor: Colors.white, // 배경색을 흰색으로 설정
        ),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
