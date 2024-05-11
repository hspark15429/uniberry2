import 'package:flutter/material.dart';

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
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$semesterName', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('GPA: $gpa', style: TextStyle(fontSize: 16)),
          Text('取得単位: $creditsEarned', style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          DataTable(
            columns: const [
              DataColumn(label: Text('科目名')),
              DataColumn(label: Text('単位数')),
              DataColumn(label: Text('成績')),
              DataColumn(label: Text('区分')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('政治と経済')),
                DataCell(Text('2')),
                DataCell(Text('A+')),
                DataCell(Text('教養科目')),
              ]),
              DataRow(cells: [
                DataCell(Text('戦略経営論')),
                DataCell(Text('2')),
                DataCell(Text('A+')),
                DataCell(Text('専門科目')),
              ]),
              DataRow(cells: [
                DataCell(Text('日本語上級')),
                DataCell(Text('1')),
                DataCell(Text('A+')),
                DataCell(Text('外国語（留）')),
              ]),
              DataRow(cells: [
                DataCell(Text('データ処理基礎')),
                DataCell(Text('3')),
                DataCell(Text('A')),
                DataCell(Text('教養科目')),
              ]),
              DataRow(cells: [
                DataCell(Text('心理学概論')),
                DataCell(Text('2')),
                DataCell(Text('B+')),
                DataCell(Text('教養科目')),
              ]),
              DataRow(cells: [
                DataCell(Text('美術史')),
                DataCell(Text('2')),
                DataCell(Text('A')),
                DataCell(Text('教養科目')),
              ]),
              DataRow(cells: [
                DataCell(Text('ブログラミング原理')),
                DataCell(Text('3')),
                DataCell(Text('A+')),
                DataCell(Text('教養科目')),
              ]),
              DataRow(cells: [
                DataCell(Text('中国語基礎')),
                DataCell(Text('1')),
                DataCell(Text('A')),
                DataCell(Text('外国語')),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Custom Data Table Example'),
      ),
      body: CustomDataTableWidget(
        semesterName: '2023 秋',
        gpa: 4.0,
        creditsEarned: 16,
      ),
    ),
  ));
}