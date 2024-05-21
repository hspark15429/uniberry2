import 'package:flutter/material.dart';

class GradeRateChartPage extends StatelessWidget {
  final double totalRequiredCredits;
  final double totalCompletedCredits;
  final double cultureCreditsRequired;
  final double cultureCreditsCompleted;
  final double foreignLanguageCreditsRequired;
  final double foreignLanguageCreditsCompleted;
  final double majorCreditsRequired;
  final double majorCreditsCompleted;

  GradeRateChartPage({
    required this.totalRequiredCredits,
    required this.totalCompletedCredits,
    required this.cultureCreditsRequired,
    required this.cultureCreditsCompleted,
    required this.foreignLanguageCreditsRequired,
    required this.foreignLanguageCreditsCompleted,
    required this.majorCreditsRequired,
    required this.majorCreditsCompleted,
  });

  double calculatePercentage(double required, double completed) {
    if (required == 0) {
      return 0.0;
    }
    return (completed / required) * 100.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('卒業要件', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildProgressIndicator("必要総単位", totalRequiredCredits, totalCompletedCredits),
          const SizedBox(height: 16),
          _buildProgressIndicator("教養科目", cultureCreditsRequired, cultureCreditsCompleted),
          const SizedBox(height: 16),
          _buildProgressIndicator("外国語", foreignLanguageCreditsRequired, foreignLanguageCreditsCompleted),
          const SizedBox(height: 16),
          _buildProgressIndicator("専門科目", majorCreditsRequired, majorCreditsCompleted),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(String label, double required, double completed) {
    double percentage = calculatePercentage(required, completed);
    int requiredInt = required.toInt();
    int completedInt = completed.toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage / 100.0,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
          minHeight: 10,
        ),
        const SizedBox(height: 8),
        Text(
          "必須 $requiredInt 履修 $completedInt (${percentage.toStringAsFixed(1)}%)",
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}
