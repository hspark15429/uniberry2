import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GradeChartPage extends StatelessWidget {

  const GradeChartPage({required this.semesterGPAList, super.key});
  final List<Map<String, double>> semesterGPAList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
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
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  var text = '';
                  if (value.toInt() < semesterGPAList.length) {
                    final semesterKey = semesterGPAList[value.toInt()].keys.first;
                    text = semesterKey;
                  }
                  return Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey),
          ),
          minX: 0,
          maxX: (semesterGPAList.length - 1).toDouble(),
          minY: 0,
          maxY: 5,
          lineBarsData: [
            LineChartBarData(
              spots: semesterGPAList
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(entry.key.toDouble(), entry.value.values.first))
                  .toList(),
              isCurved: true,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFFF6B6B),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              barWidth: 5,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(),
            ),
          ],
        ),
      ),
    );
  }
}
