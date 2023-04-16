class QuestionsList {
  List<Questions>? questions;

  QuestionsList({this.questions});

  QuestionsList.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int? id;
  String? category;
  String? question;
  double? value;

  Questions({this.id, this.category, this.question, this.value});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    question = json['question'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    data['question'] = question;
    data['value'] = value;
    return data;
  }
}
