import 'dart:convert';
import 'quiz_question.dart';

class LessonContentResponse {
  final String lessonId;
  final String lessonTitle;
  final List<String> learningObjectives;
  final String lessonContent;
  final List<QuizQuestion> quiz;

  LessonContentResponse({
    required this.lessonId,
    required this.lessonTitle,
    required this.learningObjectives,
    required this.lessonContent,
    required this.quiz,
  });

  factory LessonContentResponse.fromJson(Map<String, dynamic> json) {
    var learningObjectivesList = json['learning_objectives'] as List;
    List<String> learningObjectives =
        learningObjectivesList.map((s) => s as String).toList();

    var quizList = json['quiz'] as List;
    List<QuizQuestion> quiz =
        quizList.map((q) => QuizQuestion.fromJson(q)).toList();

    return LessonContentResponse(
      lessonId: json['lesson_id'] as String,
      lessonTitle: json['lesson_title'] as String,
      learningObjectives: learningObjectives,
      lessonContent: json['lesson_content'] as String,
      quiz: quiz,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lesson_id': lessonId,
      'lesson_title': lessonTitle,
      'learning_objectives': learningObjectives,
      'lesson_content': lessonContent,
      'quiz': quiz.map((q) => q.toJson()).toList(),
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
