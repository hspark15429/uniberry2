import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/timetable');
              },
              child: const Text('Go to Timetable'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/test');
              },
              child: const Text('Go to test'),
            ),
          ],
        ),
      ),
    );
  }
}
