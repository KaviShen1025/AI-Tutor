import 'package:flutter/material.dart';
import '../../models/lesson_content_request.dart';
import '../../models/lesson_content_response.dart';
import '../../models/quiz_creation_request.dart'; // Import QuizCreationRequest
import '../../models/quiz_creation_response.dart'; // Import QuizCreationResponse
import '../../models/quiz_question.dart'; // Ensure QuizQuestion is imported if needed for display
import '../../services/api_service.dart';

class LessonCreationScreen extends StatefulWidget {
  final String courseTitle;
  final String moduleTitle;
  final String lessonTitle; // Added to receive from ModulePlanningScreen

  const LessonCreationScreen({
    super.key,
    required this.courseTitle,
    required this.moduleTitle,
    required this.lessonTitle, // Added
  });

  @override
  State<LessonCreationScreen> createState() => _LessonCreationScreenState();
}

class _LessonCreationScreenState extends State<LessonCreationScreen> {
  final ApiService _apiService = ApiService();
  bool _isLessonLoading = false;
  LessonContentResponse? _lessonResponse;
  String? _lessonError;

  bool _isQuizLoading = false;
  QuizCreationResponse? _quizResponse;
  String? _quizError;

  Future<void> _createLessonContent() async {
    setState(() {
      _isLessonLoading = true;
      _lessonError = null;
      _lessonResponse = null;
      _quizResponse = null; // Reset quiz response if regenerating lesson
      _quizError = null;
    });

    final request = LessonContentRequest(
      courseTitle: widget.courseTitle,
      moduleTitle: widget.moduleTitle,
      lessonTitle: widget.lessonTitle,
      lessonObjective: "Understand the core concepts of ${widget.lessonTitle}",
    );

    try {
      final response = await _apiService.createLessonContent(request);
      setState(() {
        _lessonResponse = response;
        _isLessonLoading = false;
      });
      // ignore: avoid_print
      print('Lesson Content Response: ${response.toJsonString()}');
    } catch (e) {
      setState(() {
        _lessonError = e.toString();
        _isLessonLoading = false;
      });
      // ignore: avoid_print
      print('Error creating lesson content: $e');
    }
  }

  Future<void> _createQuiz() async {
    if (_lessonResponse == null) return; // Should not happen if button is shown correctly

    setState(() {
      _isQuizLoading = true;
      _quizError = null;
      _quizResponse = null;
    });

    final request = QuizCreationRequest(
      courseTitle: widget.courseTitle,
      moduleTitle: widget.moduleTitle,
      lessonTitle: widget.lessonTitle,
      lessonObjective: "Assess understanding of ${widget.lessonTitle}", // Sample objective
    );

    try {
      final response = await _apiService.createQuiz(request);
      setState(() {
        _quizResponse = response;
        _isQuizLoading = false;
      });
      // ignore: avoid_print
      print('Quiz Creation Response: ${response.toJsonString()}');
    } catch (e) {
      setState(() {
        _quizError = e.toString();
        _isQuizLoading = false;
      });
      // ignore: avoid_print
      print('Error creating quiz: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Content: ${widget.lessonTitle}'),
      ),
      body: Center(
        child: SingleChildScrollView( // Added for scrollability
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Course: ${widget.courseTitle}', style: const TextStyle(fontSize: 16)),
              Text('Module: ${widget.moduleTitle}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLessonLoading ? null : _createLessonContent,
                child: _isLessonLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Generate Lesson Content'),
              ),
              if (_lessonError != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Lesson Error: $_lessonError',
                      style: const TextStyle(color: Colors.red)),
                ),
              if (_lessonResponse != null) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lesson ID: ${_lessonResponse!.lessonId}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Title: ${_lessonResponse!.lessonTitle}',style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Learning Objectives:', style: TextStyle(fontWeight: FontWeight.bold)),
                      for (var obj in _lessonResponse!.learningObjectives) Text('- $obj'),
                      const SizedBox(height: 8),
                      const Text('Lesson Content:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(_lessonResponse!.lessonContent),
                      const SizedBox(height: 8),
                      const Text('Quiz (from lesson content):', style: TextStyle(fontWeight: FontWeight.bold)),
                      if (_lessonResponse!.quiz.isEmpty)
                        const Text('No quiz provided with lesson content.')
                      else
                        for (var q in _lessonResponse!.quiz) ...[
                          const SizedBox(height: 4),
                          Text('Q: ${q.question}'),
                          // Could display options and answer here too
                        ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isQuizLoading ? null : _createQuiz,
                        child: _isQuizLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Generate Separate Quiz'),
                      ),
                    ],
                  ),
                ),
              ],
              if (_quizError != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Quiz Error: $_quizError',
                      style: const TextStyle(color: Colors.red)),
                ),
              if (_quizResponse != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Generated Quiz (Separate):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      for (var q in _quizResponse!.quiz) ...[
                        const SizedBox(height: 8),
                        Text('Q: ${q.question}'),
                        for(var option in q.options) Text('- $option'),
                        Text('Answer: ${q.correctAnswer}'),
                        Text('Explanation: ${q.explanation}'),
                      ]
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
