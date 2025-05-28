import 'dart:convert';
import 'quiz_question.dart'; // Reusing the existing model

class QuizCreationResponse {
  final List<QuizQuestion> quiz;

  QuizCreationResponse({
    required this.quiz,
  });

  factory QuizCreationResponse.fromJson(Map<String, dynamic> json) {
    var quizList = json['quiz'] as List;
    List<QuizQuestion> quiz =
        quizList.map((q) => QuizQuestion.fromJson(q)).toList();

    return QuizCreationResponse(
      quiz: quiz,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz': quiz.map((q) => q.toJson()).toList(),
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
