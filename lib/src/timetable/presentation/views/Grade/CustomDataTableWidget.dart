import 'package:flutter/material.dart';

class CustomDataTableWidget extends StatelessWidget {
  final String semesterName;
  final double gpa;
  final int creditsEarned;
  final List<Map<String, dynamic>> courses;
  final Function(int, String, int, String, String) onUpdateCourse;
  final Function(int) onDeleteCourse;

  const CustomDataTableWidget({
    Key? key,
    required this.semesterName,
    required this.gpa,
    required this.creditsEarned,
    required this.courses,
    required this.onUpdateCourse,
    required this.onDeleteCourse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // 화면의 90% 너비를 차지하도록 설정
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
                semesterName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                'GPA: $gpa',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              Text(
'취득단위: $creditsEarned',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  columns: const [
DataColumn(label: Text('과목명', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
DataColumn(label: Text('단위수', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
DataColumn(label: Text('성적', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
DataColumn(label: Text('구분', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
DataColumn(label: Text('삭제', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                  ],
                  rows: courses.asMap().entries.map((entry) {
                    int index = entry.key;
                    var course = entry.value;
                    TextEditingController nameController = TextEditingController(text: course['name'] as String);
                    int credits = course['credits'] as int;
                    String grade = course['grade'] as String;
                    String type = course['type'] as String;

                    return DataRow(cells: [
                      DataCell(
                        Container(
                          width: 70,
                          child: TextField(
                            controller: nameController,
                            onSubmitted: (value) {
                              onUpdateCourse(index, value, credits, grade, type);
                            },
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 70,
                          child: DropdownButton<int>(
                            value: credits,
                            onChanged: (value) {
                              onUpdateCourse(index, nameController.text, value!, grade, type);
                            },
                            items: List.generate(5, (index) => index + 1)
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.toString()),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 70,
                          child: DropdownButton<String>(
                            value: grade,
                            onChanged: (value) {
                              onUpdateCourse(index, nameController.text, credits, value!, type);
                            },
                            items: ['A+', 'A', 'B', 'C', 'F']
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 150,
                          child: DropdownButton<String>(
                            value: type,
                            onChanged: (value) {
                              onUpdateCourse(index, nameController.text, credits, grade, value!);
                            },
items: ['전공과목', '교양과목', '외국어']
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            onDeleteCourse(index);
                          },
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
