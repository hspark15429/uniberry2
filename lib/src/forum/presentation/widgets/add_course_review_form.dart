import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:uniberry/core/common/widgets/i_field.dart';
import 'package:uniberry/src/timetable/presentation/widgets/select_school_tile.dart';

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
    required this.onSave,
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
  final VoidCallback onSave;

  @override
  State<AddCourseReviewForm> createState() => _AddCourseReviewFormState();
}

class _AddCourseReviewFormState extends State<AddCourseReviewForm> {
  String _selectedYear = DateTime.now().year.toString();
  String _selectedTerm = '春セメスター';
  final List<String> _terms = ['春セメスター', '秋セメスター', '通年', '夏集中', '秋集中', 'その他'];
  final List<String> _attendanceOptions = [
    'カードリーダー(学生証)',
    'MANABA(出席番号, QRコード)',
    '直接点呼',
    'その他',
    'なし'
  ];
  final List<String> _evaluationOptions = [
    '小テスト',
    'レポート',
    '定期試験',
    '発表',
    'その他',
    'なし'
  ];
  final List<String> _atmosphereOptions = ['全て対面', 'ハイブリッド', '全てオンライン'];
  String? _selectedAtmosphere; // 초기 상태를 null로 설정

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
                    child: const Text('取消'),
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
                    child: const Text('保存'),
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

  void _saveReview() {
    if (widget.formKey.currentState!.validate() &&
        widget.departmentController.text.isNotEmpty &&
        widget.yearController.text.isNotEmpty &&
        widget.attendanceController.text.isNotEmpty &&
        widget.evaluationController.text.isNotEmpty &&
        widget.tagController.value != 0 &&
        _selectedAtmosphere != null) {
      widget.onSave();
    } else {
      // 필수 입력값이 누락된 경우 스낵바 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '필수 입력값을 모두 입력해주세요',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            ? '専攻を選択'
                            : widget.departmentController.text,
                        style: TextStyle(
                            color: widget.departmentController.text.isEmpty
                                ? Colors.black
                                : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => _showYearTermPicker(context),
                      child: Text(
                        widget.yearController.text.isEmpty
                            ? '受講時期を選択'
                            : widget.yearController.text,
                        style: TextStyle(
                            color: widget.yearController.text.isEmpty
                                ? Colors.black
                                : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              IField(
                controller: widget.titleController,
                hintText: '授業名を入力してください',
                filled: true,
                fillColour: Colors.white,
              ),
              const SizedBox(height: 5),
              IField(
                controller: widget.contentController,
                hintText: '教授名を入力してください',
                filled: true,
                fillColour: Colors.white,
              ),
              const SizedBox(height: 5),
              _buildDropdownField(
                '出席確認方法',
                _attendanceOptions,
                widget.attendanceController,
              ),
              const SizedBox(height: 5),
              _buildMultiSelectField(
                '成績評価方法',
                _evaluationOptions,
                widget.evaluationController,
              ),
              const SizedBox(height: 5),
              _buildStarRating('授業の満足度', widget.tagController.value),
              const SizedBox(height: 5),
              _buildAtmosphereOptions(),
              const SizedBox(height: 5),
              _buildTextAreaField(
                '授業の内容や学べたこと',
                '人身攻撃、悪口などは禁止です。授業に関連した内容のみ記入してください。',
                widget.commentController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating(String title, int initialRating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        if (widget.tagController.value == 0)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              '授業の満足度は必須項目です。',
              style: TextStyle(
                  color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _buildAtmosphereOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
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
        if (_selectedAtmosphere == null)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              '授業形態は必須項目です。',
              style: TextStyle(
                  color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
            ),
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '入力必須です';
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        if (controller.text.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '$labelは必須項目です。',
              style: const TextStyle(
                  color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
