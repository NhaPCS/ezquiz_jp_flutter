class Question {
  String question;
  String answer;
  Map<String, String> answers;
  String selectedAnswer;

  Question.fromJson(var map) {
    question = map["question"];
    answer = map["answer"];
    answers = Map();
    answers["a"] = map["answers"]["a"];
    answers["b"] = map["answers"]["b"];
    answers["c"] = map["answers"]["c"];
    answers["d"] = map["answers"]["d"];
  }

  bool isCorrect() {
    if (answer == null || selectedAnswer == null) return false;
    return answer.toLowerCase() == selectedAnswer.toLowerCase();
  }
}
