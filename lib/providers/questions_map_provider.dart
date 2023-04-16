import 'package:flutter/material.dart';

class QuestionsMapProvider extends ChangeNotifier {
  Map<String, String> _questionsMap = {};

  Map<String, String> get questionsMap => _questionsMap;

  void addQuestion(String id, String selectedAmount) {
    _questionsMap[id] = selectedAmount.toString();
    notifyListeners();
  }
}
