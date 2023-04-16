import 'dart:convert';
import 'dart:developer';

import 'package:carbon_tracker/models/question/questions_list.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_urls.dart';

class APIServices {
  static Future<List<String>> fetchCategories() async {
    List<String> categoryList = [];
    final response = await http.get(Uri.parse(AppURL.fetchAllTracksURL));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data.toString());

      for (String category in data['categories']) {
        categoryList.add(category);
      }
      return categoryList;
    } else {
      throw Exception('Failed to load categories');
      // return categoryList;
    }
  }

  static Future<QuestionsList> fetchQuestions(String category) async {
    final response = await http.get(Uri.parse(AppURL.fetchQuestionsListURL + '/$category'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print(data.toString());

      log(QuestionsList.fromJson(data).toString());
      return QuestionsList.fromJson(data);
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
