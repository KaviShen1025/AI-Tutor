// Dart models for Lesson Content Generation

class LessonRequest {
  final String courseTitle;
  final String moduleTitle;
  final String lessonTitle;
  final String lessonObjective;

  LessonRequest({
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

class LessonResponse {
  final String lessonContent;

  LessonResponse({
    required this.lessonContent,
  });

  factory LessonResponse.fromJson(Map<String, dynamic> json) {
    return LessonResponse(
      lessonContent: json['lesson_content'] as String,
    );
  }
}
