import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart'; // 로케일 초기화를 위한 import 추가
import 'package:provider/provider.dart';
import 'package:uniberry2/core/services/injection_container.dart';
import 'package:uniberry2/core/services/router.dart';
import 'package:uniberry2/firebase_options.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable/assignmentNotifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('en_US', null); // 로케일 초기화
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AssignmentNotifier>(
          create: (_) => AssignmentNotifier(),
        ),
      ],
      child: BlocProvider(
        create: (context) => sl<TimetableCubit>(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          onGenerateRoute: generateRoute,
        ),
      ),
    );
  }
}