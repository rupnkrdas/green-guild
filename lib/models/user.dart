import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? username;
  double? carbonCount;
  double? score;
  String? date;
  String? email;
  int? statusCode;

  UserProvider({
    this.username,
    this.carbonCount,
    this.score,
    this.date,
    this.email,
    this.statusCode,
  });

  // setter to set all the values
  void setAllValues({required String username, double? carbonCount, double? score, String? date, String? email, int? statusCode}) {
    this.username = username;
    this.carbonCount = carbonCount;
    this.score = score;
    this.date = date;
    this.email = email;
    this.statusCode = statusCode;
    notifyListeners();
  }

  // // set only username
  // void setUsername(String username) {
  //   this.username = username;
  //   notifyListeners();
  // }

  // UserProvider.fromJson(Map<String, dynamic> json) {
  //   username = json['username'];
  //   carbonCount = json['carbon_count'];
  //   score = json['score'];
  //   date = json['date'];
  //   email = json['email'];
  //   statusCode = json['status_code'];
  //   notifyListeners();
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['username'] = username;
  //   data['carbon_count'] = carbonCount;
  //   data['score'] = score;
  //   data['date'] = date;
  //   data['email'] = email;
  //   data['status_code'] = statusCode;
  //   notifyListeners();
  //   return data;
  // }
}
