import 'dart:convert';

class ModulePlanRequest {
  final String courseTitle;
  final String courseDescription;
  final String moduleTitle;
  final String moduleSummary;

  ModulePlanRequest({
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

  String toJsonString() => jsonEncode(toJson());
}
