import 'package:flutter/material.dart';
import 'package:ai_tutor/models/module_models.dart';
import 'package:ai_tutor/models/lesson_models.dart'; // Import Lesson models
import 'package:ai_tutor/services/api_service.dart';   // Import ApiService
import 'package:ai_tutor/ui/lesson_content_page.dart'; // Import LessonContentPage

class ModuleDetailPage extends StatefulWidget { // Changed to StatefulWidget
  final ModuleResponse moduleData;

  const ModuleDetailPage({super.key, required this.moduleData});

  @override
  _ModuleDetailPageState createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends State<ModuleDetailPage> { // State class
  final ApiService _apiService = ApiService();
  String? _loadingLessonId; // To track which lesson is currently loading

  Future<void> _generateAndNavigateToLesson(LessonInfo lesson) async {
    if (_loadingLessonId == lesson.lessonId) return; // Already loading

    setState(() {
      _loadingLessonId = lesson.lessonId;
    });

    final request = LessonRequest(
      // Assuming widget.moduleData.courseTitle is available (added in previous step)
      courseTitle: widget.moduleData.courseTitle, 
      moduleTitle: widget.moduleData.moduleTitle,
      lessonTitle: lesson.lessonTitle,
      lessonObjective: "To understand ${lesson.lessonTitle}", // Placeholder objective
    );

    try {
      final lessonResponse = await _apiService.createLessonContent(request);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LessonContentPage(
            courseTitle: widget.moduleData.courseTitle, // Pass courseTitle
            moduleTitle: widget.moduleData.moduleTitle, // Pass moduleTitle
            lessonTitle: lesson.lessonTitle,
            lessonContent: lessonResponse.lessonContent,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate lesson content: $e')),
      );
    } finally {
      setState(() {
        _loadingLessonId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moduleData.moduleTitle), // Use widget.moduleData
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Introduction',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.moduleData.moduleIntroduction, // Use widget.moduleData
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24.0),
            if (widget.moduleData.learningObjectives.isNotEmpty) ...[ // Use widget.moduleData
              Text(
                'Learning Objectives',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.moduleData.learningObjectives.length, // Use widget.moduleData
                itemBuilder: (context, index) {
                  final objective = widget.moduleData.learningObjectives[index]; // Use widget.moduleData
                  return ListTile(
                    leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                    title: Text(objective),
                  );
                },
              ),
              const SizedBox(height: 24.0),
            ],
            Text(
              'Lessons',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.moduleData.lessons.length, // Use widget.moduleData
              itemBuilder: (context, index) {
                final lesson = widget.moduleData.lessons[index]; // Use widget.moduleData
                final isLoadingThisLesson = _loadingLessonId == lesson.lessonId;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(lesson.lessonTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(lesson.lessonSummary),
                    trailing: isLoadingThisLesson
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.chevron_right),
                    onTap: isLoadingThisLesson ? null : () => _generateAndNavigateToLesson(lesson),
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            Text(
              'Estimated Time: ${widget.moduleData.estimatedTime}', // Use widget.moduleData
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
