import 'dart:convert';
import 'module_info.dart';

class CoursePlanResponse {
  final String courseTitle;
  final String courseDescription;
  final String courseIntroduction;
  final List<ModuleInfo> modules;

  CoursePlanResponse({
    required this.courseTitle,
    required this.courseDescription,
    required this.courseIntroduction,
    required this.modules,
  });

  factory CoursePlanResponse.fromJson(Map<String, dynamic> json) {
    var modulesList = json['modules'] as List;
    List<ModuleInfo> modules =
        modulesList.map((i) => ModuleInfo.fromJson(i)).toList();

    return CoursePlanResponse(
      courseTitle: json['course_title'] as String,
      courseDescription: json['course_description'] as String,
      courseIntroduction: json['course_introduction'] as String,
      modules: modules,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_title': courseTitle,
      'course_description': courseDescription,
      'course_introduction': courseIntroduction,
      'modules': modules.map((module) => module.toJson()).toList(),
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
