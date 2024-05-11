import 'package:flutter/material.dart';

// 이 예제는 CustomDataTableWidget의 간단한 구현입니다.
// 실제 구현 시에는 필요에 따라 맞춤 조정이 필요할 수 있습니다.
class CustomDataTableWidget extends StatelessWidget {
  final String semesterName;
  final double gpa;
  final int creditsEarned;

  const CustomDataTableWidget({
    Key? key,
    required this.semesterName,
    required this.gpa,
    required this.creditsEarned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('학기: $semesterName'),
        Text('GPA: $gpa'),
        Text('취득 학점: $creditsEarned'),
        // 여기에 더 많은 정보를 표시할 수 있습니다.
      ],
    );
  }
}
