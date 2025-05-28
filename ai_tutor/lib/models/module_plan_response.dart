import 'dart:convert';
import 'lesson_info.dart';

class ModulePlanResponse {
  final String moduleId;
  final String moduleTitle;
  final String moduleDescription;
  final List<String> learningObjectives;
  final String estimatedTime;
  final List<LessonInfo> lessons;

  ModulePlanResponse({
    required this.moduleId,
    required this.moduleTitle,
    required this.moduleDescription,
    required this.learningObjectives,
    required this.estimatedTime,
    required this.lessons,
  });

  factory ModulePlanResponse.fromJson(Map<String, dynamic> json) {
    var lessonsList = json['lessons'] as List;
    List<LessonInfo> lessons =
        lessonsList.map((i) => LessonInfo.fromJson(i)).toList();
    var learningObjectivesList = json['learning_objectives'] as List;
    List<String> learningObjectives =
        learningObjectivesList.map((s) => s as String).toList();


    return ModulePlanResponse(
      moduleId: json['module_id'] as String,
      moduleTitle: json['module_title'] as String,
      moduleDescription: json['module_description'] as String,
      learningObjectives: learningObjectives,
      estimatedTime: json['estimated_time'] as String,
      lessons: lessons,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'module_id': moduleId,
      'module_title': moduleTitle,
      'module_description': moduleDescription,
      'learning_objectives': learningObjectives,
      'estimated_time': estimatedTime,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
