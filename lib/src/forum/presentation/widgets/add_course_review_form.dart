import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:uniberry/core/common/widgets/i_field.dart';
import 'package:uniberry/src/timetable/presentation/widgets/select_school_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCourseReviewForm extends StatefulWidget {
  const AddCourseReviewForm({
    required this.titleController,
    required this.contentController,
    required this.departmentController,
    required this.yearController,
    required this.gradeController,
    required this.attendanceController,
    required this.evaluationController,
    required this.commentController,
    required this.formKey,
    required this.tagController,
    super.key,
  });

  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextEditingController departmentController;
  final TextEditingController yearController;
  final TextEditingController gradeController;
  final TextEditingController attendanceController;
  final TextEditingController evaluationController;
  final TextEditingController commentController;
  final ValueNotifier<int> tagController;
  final GlobalKey<FormState> formKey;

  @override
  State<AddCourseReviewForm> createState() => _AddCourseReviewFormState();
}

class _AddCourseReviewFormState extends State<AddCourseReviewForm> {
  String _selectedYear = DateTime.now().year.toString();
  String _selectedTerm = '봄';
  final List<String> _terms = ['봄', '가을', '통年', '여름집중', '가을집중', '기타'];
  final List<String> _attendanceOptions = [
    '카드리더(학생증)',
    '마나바(출석번호, QR코드)',
    '직접호명',
    '그외'
  ];
  final List<String> _evaluationOptions = ['소테스트', '레포트', '정기시험', '발표', '그외'];
  final List<String> _atmosphereOptions = ['全て対面', 'ハイブリッド', '全てオンライン'];
  String _selectedAtmosphere = '全て対面';

  @override
  void initState() {
    super.initState();
  }

  void _showYearTermPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String tempSelectedYear = _selectedYear;
        String tempSelectedTerm = _selectedTerm;
        return Container(
          height: 250,
          child: Column(
            children: [
              Container(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (int index) {
                          tempSelectedYear = (2020 + index).toString();
                        },
                        children: List<Widget>.generate(
                            DateTime.now().year - 2020 + 1, (int index) {
                          return Center(
                            child: Text((2020 + index).toString()),
                          );
                        }),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (int index) {
                          tempSelectedTerm = _terms[index];
                        },
                        children: _terms
                            .map((term) => Center(child: Text(term)))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedYear = tempSelectedYear;
                        _selectedTerm = tempSelectedTerm;
                        widget.yearController.text =
                            '$_selectedYear $_selectedTerm';
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('저장'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateContentSatisfaction(int rating) {
    setState(() {
      widget.tagController.value = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final selectedSchool = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectSchoolTile(
                          currentSchool: widget.departmentController.text,
                        ),
                      ),
                    );
                    if (selectedSchool != null) {
                      setState(() {
                        widget.departmentController.text = selectedSchool;
                      });
                    }
                  },
                  child: Text(
                    widget.departmentController.text.isEmpty
                        ? '학부를 선택하세요'
                        : widget.departmentController.text,
                    style: TextStyle(
                      color: widget.departmentController.text.isEmpty
                          ? Colors.grey
                          : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => _showYearTermPicker(context),
                  child: Text(
                    widget.yearController.text.isEmpty
                        ? '수강시기를 선택하세요'
                        : widget.yearController.text,
                    style: TextStyle(
                      color: widget.yearController.text.isEmpty
                          ? Colors.grey
                          : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          IField(
            controller: widget.titleController,
            hintText: '과목명을 입력하세요',
            filled: true,
            fillColour: Colors.white,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '과목명은 필수 입력 항목입니다.';
              }
              return null;
            },
          ),
          const SizedBox(height: 5),
          IField(
            controller: widget.contentController,
            hintText: '교수명을 입력하세요',
            filled: true,
            fillColour: Colors.white,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '교수명은 필수 입력 항목입니다.';
              }
              return null;
            },
          ),
          const SizedBox(height: 5),
          _buildDropdownField(
            '출결 확인 방법',
            _attendanceOptions,
            widget.attendanceController,
          ),
          const SizedBox(height: 5),
          _buildMultiSelectField(
            '성적 평가 방법',
            _evaluationOptions,
            widget.evaluationController,
          ),
          const SizedBox(height: 5),
          _buildStarRating('내용 충실도', widget.tagController.value),
          const SizedBox(height: 5),
          _buildAtmosphereOptions(),
          const SizedBox(height: 5),
          _buildTextAreaField(
            '授業の内容や学べたこと',
            '인신모독, 욕설 등은 제재 대상입니다. 수업과 관련된 내용에 대해서만 작성 부탁드립니다.',
            widget.commentController,
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(String title, int initialRating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < initialRating ? Icons.star : Icons.star_border,
                color: Colors.deepPurple,
              ),
              onPressed: () {
                _updateContentSatisfaction(index + 1);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAtmosphereOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '授業形態',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: List.generate(_atmosphereOptions.length, (index) {
            return ChoiceChip(
              label: Text(_atmosphereOptions[index]),
              selected: _selectedAtmosphere == _atmosphereOptions[index],
              onSelected: (selected) {
                setState(() {
                  _selectedAtmosphere = _atmosphereOptions[index];
                });
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTextAreaField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '내용을 입력하세요.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField(
      String label, List<String> options, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: controller.text.isNotEmpty ? controller.text : null,
          items: options
              .map((option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              controller.text = value!;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '필수 항목입니다.';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMultiSelectField(
      String label, List<String> options, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: options.map((option) {
            final isSelected = controller.text.split(',').contains(option);
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final selectedOptions = controller.text.split(',').toList();
                  if (selected) {
                    selectedOptions.add(option);
                  } else {
                    selectedOptions.remove(option);
                  }
                  controller.text = selectedOptions.join(',');
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
