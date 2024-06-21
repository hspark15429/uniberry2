import 'package:flutter/widgets.dart';

class TimetableProvider extends ChangeNotifier {
  String _period = '月3';
  String _school = '학교';
  String _term = '학기';

  String get period => _period;
  String get school => _school;
  String get term => _term;

  void setPeriod(String period) {
    if (_period != period) {
      _period = period;
      notifyListeners();
    }
  }

  void setSchool(String school) {
    if (_school != school) {
      _school = school;
      notifyListeners();
    }
  }

  void setTerm(String term) {
    if (_term != term) {
      _term = term;
      notifyListeners();
    }
  }
}
