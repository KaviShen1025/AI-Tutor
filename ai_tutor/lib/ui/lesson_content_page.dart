import 'package:flutter/material.dart';
import 'package:ai_tutor/models/lesson_models.dart';
import 'package:ai_tutor/models/quiz_models.dart'; // Import Quiz models
import 'package:ai_tutor/services/api_service.dart'; // Import ApiService
import 'package:ai_tutor/ui/quiz_page.dart';       // Import QuizPage

class LessonContentPage extends StatefulWidget { // Changed to StatefulWidget
  final String lessonTitle;
  final String lessonContent;
  final String courseTitle;  // Added courseTitle
  final String moduleTitle;  // Added moduleTitle

  const LessonContentPage({
    super.key,
    required this.lessonTitle,
    required this.lessonContent,
    required this.courseTitle,
    required this.moduleTitle,
  });

  @override
  _LessonContentPageState createState() => _LessonContentPageState();
}

class _LessonContentPageState extends State<LessonContentPage> { // State class
  final ApiService _apiService = ApiService();
  bool _isGeneratingQuiz = false;

  Future<void> _generateQuiz() async {
    setState(() {
      _isGeneratingQuiz = true;
    });

    final request = LessonRequest(
      courseTitle: widget.courseTitle,
      moduleTitle: widget.moduleTitle,
      lessonTitle: widget.lessonTitle,
      lessonObjective: "To assess understanding of ${widget.lessonTitle}", // Placeholder
    );

    try {
      final quizResponse = await _apiService.createQuiz(request);
      if (!mounted) return; // Check if the widget is still in the tree

      if (quizResponse.quiz.isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No quiz questions were generated.')),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(
              questions: quizResponse.quiz,
              lessonTitle: widget.lessonTitle,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate quiz: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingQuiz = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lessonTitle),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lessonContent,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isGeneratingQuiz ? null : _generateQuiz,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            minimumSize: const Size(double.infinity, 50), // Ensure button is wide
          ),
          child: _isGeneratingQuiz
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
              : const Text('Generate Quiz'),
        ),
      ),
    );
  }
}
