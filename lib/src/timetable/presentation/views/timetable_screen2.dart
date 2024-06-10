import 'package:flutter/material.dart';

class TimetableScreen2 extends StatelessWidget {
  const TimetableScreen2({super.key});

  static const String routeName = '/timetable2';

  @override
  Widget build(BuildContext context) {
    const semester = '2024년봄학기';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          semester,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            decoration: TextDecoration.underline,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.school, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _buildDayHeader(),
          ...List.generate(
            6,
            _buildPeriodRow,
          ),
          const SizedBox(height: 20),
          _buildGradeStatusCard(),
          const SizedBox(height: 300),
        ],
      ),
    );
  }

  Widget _buildDayHeader() {
    final days = <String>['월', '화', '수', '목', '금', '토', '일'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 30),
          ...days.map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodRow(int periodIndex) {
    final days = <String>['월', '화', '수', '목', '금', '토', '일'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Center(
              child: Text(
                '${periodIndex + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          ...days.map(
            (day) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(''),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: const Column(
        children: [
          Text(
            '이수상황',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Placeholder(
            fallbackHeight: 200,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
