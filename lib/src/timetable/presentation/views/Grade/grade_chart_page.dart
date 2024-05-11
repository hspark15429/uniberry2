import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GradeChartPage extends StatelessWidget {
  final List<Map<String, double>> semesterGPAList;

  const GradeChartPage({Key? key, required this.semesterGPAList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  String text = '';
                  if (value.toInt() < semesterGPAList.length) {
                    String semesterKey = semesterGPAList[value.toInt()].keys.first;
                    text = semesterKey; // Directly use the modified semester key
                  }
                  return Text(text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(value.toString(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: (semesterGPAList.length - 1).toDouble(),
          minY: 0,
          maxY: 5.0,
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
                  Color.fromARGB(255, 238, 54, 3),
                  Color.fromARGB(255, 238, 54, 3),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
