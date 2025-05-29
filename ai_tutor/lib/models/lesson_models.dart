class LessonContentRequest {
  final String courseTitle;
  final String moduleTitle;
  final String lessonTitle;
  final String lessonObjective;

  LessonContentRequest({
    required this.courseTitle,
    required this.moduleTitle,
    required this.lessonTitle,
    required this.lessonObjective,
  });

  Map<String, dynamic> toJson() {
    return {
      'course_title': courseTitle,
      'module_title': moduleTitle,
      'lesson_title': lessonTitle,
      'lesson_objective': lessonObjective,
    };
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String? explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] ?? 'Question not available',
      options: List<String>.from(json['options'] ?? []),
      correctOptionIndex: json['correct_option_index'] ?? 0,
      explanation: json['explanation'],
    );
  }
}

class LessonContentResponse {
  final String? lessonId;
  final String lessonTitle;
  final String? lessonIntroduction;
  final String? lessonContent;
  final List<String>? keyTakeaways;
  final List<QuizQuestion>? quizQuestions;

  LessonContentResponse({
    this.lessonId,
    required this.lessonTitle,
    this.lessonIntroduction,
    this.lessonContent,
    this.keyTakeaways,
    this.quizQuestions,
  });

  factory LessonContentResponse.fromJson(Map<String, dynamic> json) {
    // Handle case where lesson_content might be null
    var lessonContent = json['lesson_content'];

    // Handle case where key_takeaways might be null or not a list
    List<String> keyTakeaways = [];
    if (json['key_takeaways'] != null && json['key_takeaways'] is List) {
      keyTakeaways = List<String>.from(json['key_takeaways']);
    }

    // Handle case where quiz_questions might be null
    List<QuizQuestion> quizQuestions = [];
    if (json['quiz_questions'] != null && json['quiz_questions'] is List) {
      quizQuestions = List<QuizQuestion>.from(
        json['quiz_questions'].map((q) => QuizQuestion.fromJson(q)),
      );
    }

    return LessonContentResponse(
      lessonId: json['lesson_id'],
      lessonTitle: json['lesson_title'] ?? 'Untitled Lesson',
      lessonIntroduction: json['lesson_introduction'],
      lessonContent: lessonContent,
      keyTakeaways: keyTakeaways,
      quizQuestions: quizQuestions,
    );
  }
}

// Add new class for quiz requests
class QuizRequest {
  final String courseTitle;
  final String moduleTitle;
  final String lessonTitle;
  final String lessonObjective;

  QuizRequest({
    required this.courseTitle,
    required this.moduleTitle,
    required this.lessonTitle,
    required this.lessonObjective,
  });

  Map<String, dynamic> toJson() {
    return {
      'course_title': courseTitle,
      'module_title': moduleTitle,
      'lesson_title': lessonTitle,
      'lesson_objective': lessonObjective,
    };
  }
}

// Add new class for quiz responses
class QuizResponse {
  final List<QuizQuestion> quiz;

  QuizResponse({
    required this.quiz,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    List<QuizQuestion> quizQuestions = [];
    if (json['quiz'] != null && json['quiz'] is List) {
      quizQuestions = (json['quiz'] as List).map((questionJson) {
        final options = List<String>.from(questionJson['options'] ?? []);
        final correctAnswer = questionJson['correct_answer'] as String;
        // Find the index of the correct answer in the options list
        final correctOptionIndex = options.indexOf(correctAnswer);

        return QuizQuestion(
          question: questionJson['question'] ?? 'Question not available',
          options: options,
          correctOptionIndex: correctOptionIndex >= 0 ? correctOptionIndex : 0,
          explanation: questionJson['explanation'],
        );
      }).toList();
    }

    return QuizResponse(quiz: quizQuestions);
  }
}
