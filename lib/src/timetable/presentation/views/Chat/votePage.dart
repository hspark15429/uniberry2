import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VotePage extends StatefulWidget {
  const VotePage({required this.onVoteCreated, super.key});
  final Function(Map<String, dynamic>) onVoteCreated;

  @override
  _VotePageState createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  String _selectedOption = '텍스트';
  final List<TextEditingController> _textControllers = [
    TextEditingController(),
    TextEditingController()
  ];
  final List<DateTime> _dateOptions = [DateTime.now(), DateTime.now()];
  final List<TimeOfDay> _timeOptions = [TimeOfDay.now(), TimeOfDay.now()];
  bool _allowMultipleSelection = false;
  bool _anonymousVoting = false;
  bool _allowOptionAddition = false;
  DateTime? _deadlineDate;
  TimeOfDay? _deadlineTime;
  bool _sendNotification = false;

  void _addTextOption() =>
      setState(() => _textControllers.add(TextEditingController()));
  void _addDateOption() => setState(() => _dateOptions.add(DateTime.now()));
  void _addTimeOption() => setState(() => _timeOptions.add(TimeOfDay.now()));

  Future<void> _pickImage(int index) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          // 이미지 처리 로직
        });
      }
    } catch (e) {
      // 오류 처리 로직
      print(e);
    }
  }

  Future<void> _selectDate(BuildContext context, int index) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => _dateOptions[index] = picked);
    }
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _timeOptions[index] = picked);
    }
  }

  Future<void> _selectDeadlineDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => _deadlineDate = picked);
    }
  }

  Future<void> _selectDeadlineTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _deadlineTime = picked);
    }
  }

  void _showPreview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<VotePreviewPage>(
        builder: (context) => VotePreviewPage(
          title: _titleController.text,
          selectedOption: _selectedOption,
          textControllers: _textControllers,
          dateOptions: _dateOptions,
          timeOptions: _timeOptions,
          allowMultipleSelection: _allowMultipleSelection,
          anonymousVoting: _anonymousVoting,
          allowOptionAddition: _allowOptionAddition,
          deadlineDate: _deadlineDate,
          deadlineTime: _deadlineTime,
          sendNotification: _sendNotification,
        ),
      ),
    );
  }

  void _createVote() {
    if (_formKey.currentState!.validate()) {
      final voteData = {
        'title': _titleController.text,
        'selectedOption': _selectedOption,
        'textControllers':
            _textControllers.map((controller) => controller.text).toList(),
        'dateOptions': _dateOptions,
        'timeOptions': _timeOptions,
        'allowMultipleSelection': _allowMultipleSelection,
        'anonymousVoting': _anonymousVoting,
        'allowOptionAddition': _allowOptionAddition,
        'deadlineDate': _deadlineDate,
        'deadlineTime': _deadlineTime,
        'sendNotification': _sendNotification,
      };
      widget.onVoteCreated(voteData);
      Navigator.pop(context);
    }
  }

  Widget _buildTextOptionCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Column(
        children: [
          ..._textControllers.asMap().entries.map((entry) {
            final index = entry.key;
            var controller = entry.value;
            return Column(
              children: [
                Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) =>
                      setState(() => _textControllers.removeAt(index)),
                  background: Container(color: Colors.red),
                  child: ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.photo),
                      onPressed: () => _pickImage(index),
                    ),
                    title: TextField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: '옵션을 입력하세요'),
                    ),
                  ),
                ),
                Divider(color: Colors.grey.shade300),
              ],
            );
          }),
          TextButton(onPressed: _addTextOption, child: const Text('+ 선택지 추가')),
        ],
      ),
    );
  }

  Widget _buildDateOptionCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Column(
        children: [
          ..._dateOptions.asMap().entries.map((entry) {
            var index = entry.key;
            var date = entry.value;
            return Column(
              children: [
                Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) =>
                      setState(() => _dateOptions.removeAt(index)),
                  background: Container(color: Colors.red),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text('${date.toLocal()}'.split(' ')[0]),
                    onTap: () => _selectDate(context, index),
                  ),
                ),
                Divider(color: Colors.grey.shade300),
              ],
            );
          }),
          TextButton(onPressed: _addDateOption, child: const Text('+ 선택지 추가')),
        ],
      ),
    );
  }

  Widget _buildTimeOptionCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Column(
        children: [
          ..._timeOptions.asMap().entries.map((entry) {
            final index = entry.key;
            var time = entry.value;
            return Column(
              children: [
                Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) =>
                      setState(() => _timeOptions.removeAt(index)),
                  background: Container(color: Colors.red),
                  child: ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(time.format(context)),
                    onTap: () => _selectTime(context, index),
                  ),
                ),
                Divider(color: Colors.grey.shade300),
              ],
            );
          }),
          TextButton(onPressed: _addTimeOption, child: const Text('+ 선택지 추가')),
        ],
      ),
    );
  }

  Widget _buildOptionsCard() {
    switch (_selectedOption) {
      case '텍스트':
        return _buildTextOptionCard();
      case '날짜':
        return _buildDateOptionCard();
      case '시간':
        return _buildTimeOptionCard();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('투표 생성'),
        actions: [
          IconButton(
            icon: const Icon(Icons.preview),
            onPressed: () => _showPreview(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: '투표 주제'),
                  validator: (value) =>
                      value == null || value.isEmpty ? '주제를 입력하세요' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceChip(
                      label: const Text('텍스트'),
                      selected: _selectedOption == '텍스트',
                      onSelected: (selected) =>
                          setState(() => _selectedOption = '텍스트'),
                    ),
                    ChoiceChip(
                      label: const Text('날짜'),
                      selected: _selectedOption == '날짜',
                      onSelected: (selected) =>
                          setState(() => _selectedOption = '날짜'),
                    ),
                    ChoiceChip(
                      label: const Text('시간'),
                      selected: _selectedOption == '시간',
                      onSelected: (selected) =>
                          setState(() => _selectedOption = '시간'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildOptionsCard(),
                const SizedBox(height: 16),
                Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(
                          '마감 날짜: ${_deadlineDate != null ? _deadlineDate!.toLocal().toString().split(' ')[0] : '설정 안됨'}',
                        ),
                        onTap: () => _selectDeadlineDate(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.access_time),
                        title: Text(
                          '마감 시간: ${_deadlineTime != null ? _deadlineTime!.format(context) : '설정 안됨'}',
                        ),
                        onTap: () => _selectDeadlineTime(context),
                      ),
                    ],
                  ),
                ),
                SwitchListTile(
                  title: const Text('복수 선택 허용'),
                  value: _allowMultipleSelection,
                  onChanged: (value) =>
                      setState(() => _allowMultipleSelection = value),
                ),
                SwitchListTile(
                  title: const Text('익명 투표'),
                  value: _anonymousVoting,
                  onChanged: (value) =>
                      setState(() => _anonymousVoting = value),
                ),
                SwitchListTile(
                  title: const Text('선택지 추가 허용'),
                  value: _allowOptionAddition,
                  onChanged: (value) =>
                      setState(() => _allowOptionAddition = value),
                ),
                SwitchListTile(
                  title: const Text('투표 종료 전 알림 설정'),
                  value: _sendNotification,
                  onChanged: (value) =>
                      setState(() => _sendNotification = value),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _createVote,
                  child: const Text('투표 생성'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VotePreviewPage extends StatelessWidget {
  const VotePreviewPage({
    required this.title,
    required this.selectedOption,
    required this.textControllers,
    required this.dateOptions,
    required this.timeOptions,
    required this.allowMultipleSelection,
    required this.anonymousVoting,
    required this.allowOptionAddition,
    required this.deadlineDate,
    required this.deadlineTime,
    required this.sendNotification,
    super.key,
  });
  final String title;
  final String selectedOption;
  final List<TextEditingController> textControllers;
  final List<DateTime> dateOptions;
  final List<TimeOfDay> timeOptions;
  final bool allowMultipleSelection;
  final bool anonymousVoting;
  final bool allowOptionAddition;
  final DateTime? deadlineDate;
  final TimeOfDay? deadlineTime;
  final bool sendNotification;

  Widget _buildPreviewOptions(BuildContext context) {
    switch (selectedOption) {
      case '텍스트':
        return Column(
          children: textControllers.map((controller) {
            return ListTile(
              leading: const Icon(Icons.photo),
              title: Text(controller.text),
            );
          }).toList(),
        );
      case '날짜':
        return Column(
          children: dateOptions.map((date) {
            return ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('${date.toLocal()}'.split(' ')[0]),
            );
          }).toList(),
        );
      case '시간':
        return Column(
          children: timeOptions.map((time) {
            return ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(time.format(context)),
            );
          }).toList(),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('투표 미리보기'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('투표 주제: $title',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  if (allowMultipleSelection || anonymousVoting) ...[
                    const SizedBox(height: 8),
                    if (allowMultipleSelection)
                      const Text('*복수 선택 가능',
                          style: TextStyle(color: Colors.grey)),
                    if (anonymousVoting)
                      const Text('*익명 투표',
                          style: TextStyle(color: Colors.grey)),
                  ],
                  const SizedBox(height: 16),
                  _buildPreviewOptions(context),
                  const SizedBox(height: 16),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      deadlineDate != null
                          ? deadlineDate!.toLocal().toString().split(' ')[0]
                          : '마감 날짜: 설정 안됨',
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(
                      deadlineTime != null
                          ? deadlineTime!.format(context)
                          : '마감 시간: 설정 안됨',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
