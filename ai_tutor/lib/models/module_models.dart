// Dart models for Module Planning

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

class LessonInfo {
  final String lessonId;
  final String lessonTitle;
  final String lessonSummary;

  LessonInfo({
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonSummary,
  });

  factory LessonInfo.fromJson(Map<String, dynamic> json) {
    return LessonInfo(
      lessonId: json['lesson_id'] as String,
      lessonTitle: json['lesson_title'] as String,
      lessonSummary: json['lesson_summary'] as String,
    );
  }
}

class ModuleResponse {
  final String moduleId;
  final String moduleTitle;
  final String moduleDescription;
  final List<String> learningObjectives;
  final String estimatedTime;
  final String moduleIntroduction;
  final List<LessonInfo> lessons;
  final String courseTitle; // Added courseTitle

  ModuleResponse({
    required this.moduleId,
    required this.moduleTitle,
    required this.moduleDescription,
    required this.learningObjectives,
    required this.estimatedTime,
    required this.moduleIntroduction,
    required this.lessons,
    required this.courseTitle, // Added to constructor
  });

  factory ModuleResponse.fromJson(Map<String, dynamic> json) {
    var lessonsList = json['lessons'] as List;
    List<LessonInfo> lessons = lessonsList.map((i) => LessonInfo.fromJson(i)).toList();
    
    return ModuleResponse(
      moduleId: json['module_id'] as String,
      moduleTitle: json['module_title'] as String,
      moduleDescription: json['module_description'] as String,
      learningObjectives: List<String>.from(json['learning_objectives'] as List),
      estimatedTime: json['estimated_time'] as String,
      moduleIntroduction: json['module_introduction'] as String,
      lessons: lessons,
      // Assuming backend will provide 'course_title' in the response for plan-module
      // If not, this will be null or a default value should be handled.
      // For now, let's expect it. If it might be missing, use:
      // courseTitle: json['course_title'] as String? ?? "Default Course Title", 
      courseTitle: json['course_title'] as String, 
    );
  }
}
