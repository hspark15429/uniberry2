import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GradeChartPage extends StatelessWidget {
  final List<Map<String, double>> semesterGPAList;

  const GradeChartPage({Key? key, required this.semesterGPAList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 유효한 값만 포함한 리스트 생성
    final validSemesterGPAList = semesterGPAList.where((entry) {
      return entry.values.first != null && !entry.values.first.isNaN;
    }).toList();

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
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  String text = '';
                  if (value.toInt() < validSemesterGPAList.length) {
                    String semesterKey = validSemesterGPAList[value.toInt()].keys.first;
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
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
            border: Border.all(color: Colors.grey, width: 1),
          ),
          minX: 0,
          maxX: (validSemesterGPAList.length - 1).toDouble(),
          minY: 0,
          maxY: 5.0,
          lineBarsData: [
            LineChartBarData(
              spots: validSemesterGPAList
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
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
