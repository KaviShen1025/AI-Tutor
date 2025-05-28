import 'dart:convert';

class CoursePlanRequest {
  final String title;
  final String description;
  final String targetAudience;
  final String timeAvailable;
  final List<String> learningObjectives;

  CoursePlanRequest({
    required this.title,
    required this.description,
    required this.targetAudience,
    required this.timeAvailable,
    required this.learningObjectives,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'target_audience': targetAudience,
      'time_available': timeAvailable,
      'learning_objectives': learningObjectives,
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
