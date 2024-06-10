import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/presentation/views/Chat/dm_list_page.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/homePage.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable/timetable_screen.dart';
import 'package:uniberry2/src/timetable/presentation/views/timetable_screen2.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const String routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final initialSemester = _determineInitialSemester();

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
                  MaterialPageRoute(
                    builder: (context) => const TimetableScreen2(),
                  ),
                );
              },
              child: const Text('timetable2'),
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
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false,);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  String _determineInitialSemester() {
    final now = DateTime.now();
    final currentYear = now.year;
    final semester =
        now.month < 9 ? '$currentYear년봄학기' : '$currentYear년가을학기';
    return semester;
  }
}
