// Dart models for Quiz feature

class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswer: json['correct_answer'] as String,
      explanation: json['explanation'] as String,
    );
  }
}

class QuizResponse {
  final List<QuizQuestion> quiz;

  QuizResponse({
    required this.quiz,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    var quizList = json['quiz'] as List;
    List<QuizQuestion> quiz = quizList.map((i) => QuizQuestion.fromJson(i)).toList();
    return QuizResponse(
      quiz: quiz,
    );
  }
}
