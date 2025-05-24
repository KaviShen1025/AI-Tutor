// Dart models based on Python FastAPI models

class ModuleInfo {
  final String moduleId;
  final String moduleTitle;
  final String moduleSummary;

  ModuleInfo({
    required this.moduleId,
    required this.moduleTitle,
    required this.moduleSummary,
  });

  factory ModuleInfo.fromJson(Map<String, dynamic> json) {
    return ModuleInfo(
      moduleId: json['module_id'] as String,
      moduleTitle: json['module_title'] as String,
      moduleSummary: json['module_summary'] as String,
    );
  }
}

class ModuleRequest {
  final String courseTitle;
  final String courseDescription;
  final String moduleTitle;
  final String moduleSummary;

  ModuleRequest({
    required this.courseTitle,
    required this.courseDescription,
    required this.moduleTitle,
    required this.moduleSummary,
  });

  Map<String, dynamic> toJson() {
    return {
      'course_title': courseTitle,
      'course_description': courseDescription,
      'module_title': moduleTitle,
      'module_summary': moduleSummary,
    };
  }
}

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

class QuizRequest {
  final String courseTitle;
  final String moduleTitle;
  final String lessonTitle;
  final String lessonObjective;
  final int numQuestions;

  QuizRequest({
    required this.courseTitle,
    required this.moduleTitle,
    required this.lessonTitle,
    required this.lessonObjective,
    required this.numQuestions,
  });

  Map<String, dynamic> toJson() {
    return {
      'course_title': courseTitle,
      'module_title': moduleTitle,
      'lesson_title': lessonTitle,
      'lesson_objective': lessonObjective,
      'num_questions': numQuestions,
    };
  }
}

class LessonInfo {
  final String lessonId;
  final String lessonTitle;
  final String lessonObjective;

  LessonInfo({
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonObjective,
  });

  factory LessonInfo.fromJson(Map<String, dynamic> json) {
    return LessonInfo(
      lessonId: json['lesson_id'] as String,
      lessonTitle: json['lesson_title'] as String,
      lessonObjective: json['lesson_objective'] as String,
    );
  }
}

class ModuleResponse {
  final String moduleId;
  final String moduleTitle;
  final String moduleSummary;
  final List<LessonInfo> lessons;

  ModuleResponse({
    required this.moduleId,
    required this.moduleTitle,
    required this.moduleSummary,
    required this.lessons,
  });

  factory ModuleResponse.fromJson(Map<String, dynamic> json) {
    var lessonsList = json['lessons'] as List;
    List<LessonInfo> lessons = lessonsList.map((i) => LessonInfo.fromJson(i)).toList();
    return ModuleResponse(
      moduleId: json['module_id'] as String,
      moduleTitle: json['module_title'] as String,
      moduleSummary: json['module_summary'] as String,
      lessons: lessons,
    );
  }
}

class LessonContentResponse {
  final String lessonId;
  final String lessonTitle;
  final String content;

  LessonContentResponse({
    required this.lessonId,
    required this.lessonTitle,
    required this.content,
  });

  factory LessonContentResponse.fromJson(Map<String, dynamic> json) {
    return LessonContentResponse(
      lessonId: json['lesson_id'] as String,
      lessonTitle: json['lesson_title'] as String,
      content: json['content'] as String,
    );
  }
}

class QuestionInfo {
  final String questionId;
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  QuestionInfo({
    required this.questionId,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory QuestionInfo.fromJson(Map<String, dynamic> json) {
    return QuestionInfo(
      questionId: json['question_id'] as String,
      questionText: json['question_text'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswer: json['correct_answer'] as String,
      explanation: json['explanation'] as String,
    );
  }
}

class QuizResponse {
  final String quizId;
  final String lessonTitle;
  final List<QuestionInfo> questions;

  QuizResponse({
    required this.quizId,
    required this.lessonTitle,
    required this.questions,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    var questionsList = json['questions'] as List;
    List<QuestionInfo> questions = questionsList.map((i) => QuestionInfo.fromJson(i)).toList();
    return QuizResponse(
      quizId: json['quiz_id'] as String,
      lessonTitle: json['lesson_title'] as String,
      questions: questions,
    );
  }
}

class CourseResponse {
  final String courseTitle;
  final String courseDescription;
  final String courseIntroduction;
  final List<ModuleInfo> modules;

  CourseResponse({
    required this.courseTitle,
    required this.courseDescription,
    required this.courseIntroduction,
    required this.modules,
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    var modulesList = json['modules'] as List;
    List<ModuleInfo> modules = modulesList.map((i) => ModuleInfo.fromJson(i)).toList();

    return CourseResponse(
      courseTitle: json['course_title'] as String,
      courseDescription: json['course_description'] as String,
      courseIntroduction: json['course_introduction'] as String,
      modules: modules,
    );
  }
}

class CourseRequest {
  final String title;
  final String description;
  final String targetAudience;
  final String timeAvailable;
  final String preferredFormat;
  final List<String> learningObjectives;

  CourseRequest({
    required this.title,
    required this.description,
    required this.targetAudience,
    required this.timeAvailable,
    required this.preferredFormat,
    required this.learningObjectives,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'target_audience': targetAudience,
      'time_available': timeAvailable,
      'preferred_format': preferredFormat,
      'learning_objectives': learningObjectives,
    };
  }
}
