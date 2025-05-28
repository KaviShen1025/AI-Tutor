import 'dart:convert';

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

  Map<String, dynamic> toJson() {
    return {
      'lesson_id': lessonId,
      'lesson_title': lessonTitle,
      'lesson_summary': lessonSummary,
    };
  }
}
