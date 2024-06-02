import 'package:flutter/material.dart';
import 'package:uniberry2/src/timetable/presentation/views/MainPage/Anonymous_thread/SurveyPreviewPage.dart';

class SurveyTheme {
  final Color primaryColor;
  final Color backgroundColor;
  final TextStyle questionStyle;
  final TextStyle answerStyle;

  SurveyTheme({
    required this.primaryColor,
    required this.backgroundColor,
    required this.questionStyle,
    required this.answerStyle,
  });
}

final SurveyTheme defaultSurveyTheme = SurveyTheme(
  primaryColor: Colors.blue,
  backgroundColor: Colors.white,
  questionStyle: const TextStyle(fontSize: 18, color: Colors.black),
  answerStyle: const TextStyle(fontSize: 16),
);

class SurveyWritePage extends StatefulWidget {
  final SurveyTheme theme;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const SurveyWritePage({
    required this.theme,
    required this.titleController,
    required this.descriptionController,
    Key? key,
  }) : super(key: key);

  @override
  _SurveyWritePageState createState() => _SurveyWritePageState();
}

class _SurveyWritePageState extends State<SurveyWritePage> {
  final _formKey = GlobalKey<FormState>();
  final List<SurveyQuestion> _questions = [];
  final Set<int> _selectedQuestions = {};

  void _addBlankSurvey() {
    setState(() {
      _questions.add(
        SurveyQuestion(
          type: SurveyQuestionType.shortAnswer,
          controller: TextEditingController(),
        ),
      );
    });
  }

  void _deleteQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      final deletedQuestion = _questions.removeAt(index);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('질문이 삭제되었습니다.'),
          action: SnackBarAction(
            label: '복원',
            onPressed: () {
              setState(() {
                _questions.insert(index, deletedQuestion);
              });
            },
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      _selectedQuestions.remove(index);
    }
  }

  void _deleteSelectedQuestions() {
    setState(() {
      for (final index in _selectedQuestions.toList()) {
        _deleteQuestion(index);
      }
      _selectedQuestions.clear();
    });
  }

  void _previewSurvey() {
    if (_formKey.currentState?.validate() == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SurveyPreviewPage(
            questions: _questions,
            title: widget.titleController.text,
            description: widget.descriptionController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          _selectedQuestions.isNotEmpty ? '선택 모드' : '설문조사 작성',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          if (_selectedQuestions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _deleteSelectedQuestions,
            ),
          IconButton(
            icon: const Icon(Icons.preview, color: Colors.white),
            onPressed: _previewSurvey,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              setState(() {
                final item = _questions.removeAt(oldIndex);
                _questions.insert(newIndex, item);
              });
            },
            children: _questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              return Dismissible(
                key: Key(index.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _deleteQuestion(index),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SurveyQuestionWidget(
                    question: question,
                    onDelete: () => _deleteQuestion(index),
                    onMoveUp: () {},
                    onMoveDown: () {},
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _addBlankSurvey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

enum SurveyQuestionType {
  shortAnswer,
  multipleChoice,
  dropdown,
  checkbox,
  multipleSelect,
  date,
  time,
  fileUpload,
}

class SurveyQuestion {
  SurveyQuestionType type;
  final TextEditingController controller;
  final List<String> options = [];
  bool isRequired = false;

  SurveyQuestion({
    required this.type,
    required this.controller,
    this.isRequired = false,
  });
}

class SurveyQuestionWidget extends StatefulWidget {
  final SurveyQuestion question;
  final VoidCallback onDelete;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  const SurveyQuestionWidget({
    required this.question,
    required this.onDelete,
    required this.onMoveUp,
    required this.onMoveDown,
    Key? key,
  }) : super(key: key);

  @override
  _SurveyQuestionWidgetState createState() => _SurveyQuestionWidgetState();
}

class _SurveyQuestionWidgetState extends State<SurveyQuestionWidget> {
  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<SurveyQuestionType>(
                value: widget.question.type,
                onChanged: (SurveyQuestionType? newType) {
                  if (newType != null) {
                    setState(() {
                      widget.question.type = newType;
                    });
                  }
                },
                items: SurveyQuestionType.values.map((SurveyQuestionType type) {
                  return DropdownMenuItem<SurveyQuestionType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
              ),
              Checkbox(
                value: widget.question.isRequired,
                onChanged: (bool? newValue) {
                  if (newValue != null) {
                    setState(() {
                      widget.question.isRequired = newValue;
                    });
                  }
                },
              ),
            ],
          ),
          TextFormField(
            controller: widget.question.controller,
            decoration: const InputDecoration(
              labelText: '질문 내용',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '질문을 입력해주세요';
              }
              return null;
            },
          ),
          if (widget.question.type == SurveyQuestionType.multipleChoice ||
              widget.question.type == SurveyQuestionType.dropdown ||
              widget.question.type == SurveyQuestionType.checkbox)
            _buildOptionsSection(widget.question),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward, color: Colors.black),
                  onPressed: widget.onMoveUp,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward, color: Colors.black),
                  onPressed: widget.onMoveDown,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.black),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection(SurveyQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('옵션', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ...question.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          return ListTile(
            title: TextFormField(
              initialValue: option,
              onChanged: (value) {
                question.options[index] = value;
              },
            ),
          );
        }).toList(),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.black),
          onPressed: () {
            setState(() {
              question.options.add('');
            });
          },
        ),
      ],
    );
  }
}
