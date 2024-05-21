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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$semesterName',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            'GPA: $gpa',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            '取得単位: $creditsEarned',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          DataTable(
            columnSpacing: 16,
            columns: const [
              DataColumn(label: Text('科目名', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(label: Text('単位数', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(label: Text('成績', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
              DataColumn(label: Text('区分', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('政治と経済', style: TextStyle(color: Colors.black54))),
                DataCell(Text('2', style: TextStyle(color: Colors.black54))),
                DataCell(Text('A+', style: TextStyle(color: Colors.black54))),
                DataCell(Text('教養科目', style: TextStyle(color: Colors.black54))),
              ]),
              DataRow(cells: [
                DataCell(Text('戦略経営論', style: TextStyle(color: Colors.black54))),
                DataCell(Text('2', style: TextStyle(color: Colors.black54))),
                DataCell(Text('A+', style: TextStyle(color: Colors.black54))),
                DataCell(Text('専門科目', style: TextStyle(color: Colors.black54))),
              ]),
              DataRow(cells: [
                DataCell(Text('日本語上級', style: TextStyle(color: Colors.black54))),
                DataCell(Text('1', style: TextStyle(color: Colors.black54))),
                DataCell(Text('A+', style: TextStyle(color: Colors.black54))),
                DataCell(Text('外国語（留）', style: TextStyle(color: Colors.black54))),
              ]),
              DataRow(cells: [
                DataCell(Text('データ処理基礎', style: TextStyle(color: Colors.black54))),
                DataCell(Text('3', style: TextStyle(color: Colors.black54))),
                DataCell(Text('A', style: TextStyle(color: Colors.black54))),
                DataCell(Text('教養科目', style: TextStyle(color: Colors.black54))),
              ]),
              DataRow(cells: [
                DataCell(Text('心理学概論', style: TextStyle(color: Colors.black54))),
                DataCell(Text('2', style: TextStyle(color: Colors.black54))),
                DataCell(Text('B+', style: TextStyle(color: Colors.black54))),
                DataCell(Text('教養科目', style: TextStyle(color: Colors.black54))),
              ]),
              DataRow(cells: [
                DataCell(Text('美術史', style: TextStyle(color: Colors.black54))),
                DataCell(Text('2', style: TextStyle(color: Colors.black54))),
                DataCell(Text('A', style: TextStyle(color: Colors.black54))),
                DataCell(Text('教養科目', style: TextStyle(color: Colors.black54))),
              ]),
              DataRow(cells: [
                DataCell(Text('ブログラミング原理', style: TextStyle(color: Colors.black54))),
                DataCell(Text('3', style: TextStyle(color: Colors.black54))),
                DataCell(Text('A+', style: TextStyle(color: Colors.black54))),
                DataCell(Text('教養科目', style: TextStyle(color: Colors.black54))),
              ]),
              DataRow(cells: [
                DataCell(Text('中国語基礎', style: TextStyle(color: Colors.black54))),
                DataCell(Text('1', style: TextStyle(color: Colors.black54))),
                DataCell(Text('A', style: TextStyle(color: Colors.black54))),
                DataCell(Text('外国語', style: TextStyle(color: Colors.black54))),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
