import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart'; // 로케일 초기화를 위한 import 추가
import 'package:provider/provider.dart';
import 'package:uniberry/core/providers/user_provider.dart';
import 'package:uniberry/core/res/colours.dart';
import 'package:uniberry/core/services/injection_container.dart';
import 'package:uniberry/core/services/router.dart';
import 'package:uniberry/firebase_options.dart';
import 'package:uniberry/src/dashboard/presentation/providers/dashboard_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('en_US'); // 로케일 초기화
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
      ],
      child: MaterialApp(
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
            // accentColor: Colors.black,
          ),
          scaffoldBackgroundColor: Colors.white, // 배경색을 흰색으로 설정
        ),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
