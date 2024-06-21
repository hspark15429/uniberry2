import 'package:flutter/material.dart';

class TimetableHeaderWidget extends StatelessWidget {
  TimetableHeaderWidget({
    required this.numOfDays,
    super.key,
  }) : days = ['月', '火', '水', '木', '金', '土', '日'].sublist(0, numOfDays);

  final int numOfDays;
  final List<String> days;
  @override
  Widget build(BuildContext context) {
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
}
