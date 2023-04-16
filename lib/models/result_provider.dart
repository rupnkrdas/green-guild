import 'package:flutter/material.dart';

class ResultProvider extends ChangeNotifier {
  double? totalCarbonCount;
  Categories? categories;
  Scores? scores;
  String? date;

  ResultProvider({this.totalCarbonCount, this.categories, this.scores, this.date});

  ResultProvider.fromJson(Map<String, dynamic> json) {
    totalCarbonCount = json['total_carbon_count'];
    categories = json['categories'] != null ? Categories.fromJson(json['categories']) : null;
    scores = json['scores'] != null ? Scores.fromJson(json['scores']) : null;
    date = json['date'];
    notifyListeners();
  }

  // setter to set all the values
  void setAllValues({required Categories categories, required double totalCarbonCount, required Scores scores}) {
    this.categories = categories;
    this.totalCarbonCount = totalCarbonCount;
    this.scores = scores;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_carbon_count'] = totalCarbonCount;
    if (categories != null) {
      data['categories'] = categories!.toJson();
    }
    if (scores != null) {
      data['scores'] = scores!.toJson();
    }
    data['date'] = date;
    return data;
  }
}

class Categories extends ChangeNotifier {
  double? commute;
  double? household;
  double? food;

  Categories({this.commute, this.household, this.food});

  Categories.fromJson(Map<String, dynamic> json) {
    commute = json['Commute'];
    household = json['Household'];
    food = json['Food'];
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Commute'] = commute;
    data['Household'] = household;
    data['Food'] = food;
    return data;
  }
}

class Scores extends ChangeNotifier {
  int? totalScore;
  int? commuteScore;
  int? householdScore;
  int? foodScore;

  Scores({this.totalScore, this.commuteScore, this.householdScore, this.foodScore});

  Scores.fromJson(Map<String, dynamic> json) {
    totalScore = json['total_score'];
    commuteScore = json['commute_score'];
    householdScore = json['household_score'];
    foodScore = json['food_score'];
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_score'] = totalScore;
    data['commute_score'] = commuteScore;
    data['household_score'] = householdScore;
    data['food_score'] = foodScore;
    return data;
  }
}
