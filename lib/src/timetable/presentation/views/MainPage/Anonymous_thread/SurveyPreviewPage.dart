import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Anonymous_thread/SurveyWritePage.dart';

class SurveyPreviewPage extends StatelessWidget {
  final List<SurveyQuestion> questions;
  final String title;
  final String description;

  const SurveyPreviewPage({
    required this.questions,
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('설문조사 미리보기', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ...questions.map((question) {
              switch (question.type) {
                case SurveyQuestionType.shortAnswer:
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                                              10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: const Text(
                        '주관식 질문',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        question.controller.text,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                  );
                case SurveyQuestionType.multipleChoice:
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
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
                          '객관식 질문: ${question.controller.text}',
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        ...question.options.map((option) {
                          return ListTile(
                            leading: Radio(
                              value: option,
                              groupValue: null, // 미리보기에서는 실제 답변이 아니므로 null
                              onChanged: null,
                            ),
                            title: Text(option, style: TextStyle(color: Colors.grey[800])),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                default:
                  return const SizedBox();
              }
            }).toList(),
          ],
        ),
      ),
    );
  }
}

