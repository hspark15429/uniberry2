import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/presentation/views/Chat/dm_list_page.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/homePage.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable/timetable_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const String routeName = '/';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    String initialSemester = _determineInitialSemester();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text('homepage'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TimetableScreen(),
                  ),
                );
              },
              child: const Text('timetable'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DMListPage()),
                );
              },
              child: const Text('DM'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forum');
              },
              child: const Text('Go to forums test'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign-in');
              },
              child: const Text('Go to login test'),
            ),
          ],
        ),
      ),
    );
  }

  String _determineInitialSemester() {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    String semester =
        now.month < 9 ? "${currentYear}년봄학기" : "${currentYear}년가을학기";
    return semester;
  }
}
