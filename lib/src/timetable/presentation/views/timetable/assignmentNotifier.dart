import 'package:flutter/foundation.dart';

class AssignmentNotifier extends ChangeNotifier {
  final List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  void addAssignment(Assignment assignment) {
    _assignments.add(assignment);
    notifyListeners();
  }

  void toggleCompletion(int index) {
    _assignments[index].isComplete = !_assignments[index].isComplete;
    notifyListeners();
  }
}

class Assignment {

  Assignment({
    required this.title,
    required this.dueDate,
    required this.description,
    required this.reminder,
    this.isComplete = false,
  });
  String title;
  DateTime dueDate;
  String description;
  int reminder;
  bool isComplete;
}

