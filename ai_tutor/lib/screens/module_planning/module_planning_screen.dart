import 'package:flutter/material.dart';
import '../../models/module_plan_request.dart';
import '../../models/module_plan_response.dart';
import '../../models/lesson_info.dart'; // Import LessonInfo
import '../../services/api_service.dart';
import '../lesson_creation/lesson_creation_screen.dart'; // Import LessonCreationScreen

class ModulePlanningScreen extends StatefulWidget {
  final String courseTitle;
  final String courseDescription;
  // In a real app, you'd likely pass the specific module that was selected
  // For now, we'll keep the sample moduleTitle in _planModule or pass it if available
  // final ModuleInfo selectedModule; // Example

  const ModulePlanningScreen({
    super.key,
    required this.courseTitle,
    required this.courseDescription,
    // required this.selectedModule, // Example
  });

  @override
  State<ModulePlanningScreen> createState() => _ModulePlanningScreenState();
}

class _ModulePlanningScreenState extends State<ModulePlanningScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  ModulePlanResponse? _response;
  String? _error;

  // Let's assume a module title is known for now, or passed.
  // For this example, we'll use a fixed one for the request.
  final String _currentModuleTitle = "Understanding Widgets";
  final String _currentModuleSummary = "Deep dive into Flutter's widget system.";

  @override
  void initState() {
    super.initState();
    // Automatically plan module when screen loads, using passed data
    _planModule();
  }

  Future<void> _planModule() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _response = null;
    });

    final request = ModulePlanRequest(
      courseTitle: widget.courseTitle,
      courseDescription: widget.courseDescription,
      moduleTitle: _currentModuleTitle, // Using the fixed module title
      moduleSummary: _currentModuleSummary, // Using the fixed module summary
    );

    try {
      final response = await _apiService.planModule(request);
      setState(() {
        _response = response;
        _isLoading = false;
      });
      // ignore: avoid_print
      print('Module Plan Response: ${response.toJsonString()}');
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      // ignore: avoid_print
      print('Error planning module: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan: $_currentModuleTitle'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: $_error',
                      style: const TextStyle(color: Colors.red)),
                ))
              : _response != null
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Module: ${_response!.moduleTitle}',
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 8),
                          Text(_response!.moduleDescription),
                          const SizedBox(height: 8),
                          Text('Estimated Time: ${_response!.estimatedTime}'),
                          const SizedBox(height: 8),
                          const Text('Learning Objectives:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          for (var obj in _response!.learningObjectives)
                            Text('- $obj'),
                          const SizedBox(height: 16),
                          const Text('Lessons:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          if (_response!.lessons.isEmpty)
                            const Text('No lessons planned for this module yet.')
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _response!.lessons.length,
                              itemBuilder: (context, index) {
                                final lesson = _response!.lessons[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    title: Text(lesson.lessonTitle),
                                    subtitle: Text(lesson.lessonSummary),
                                    trailing: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LessonCreationScreen(
                                              courseTitle: widget.courseTitle,
                                              moduleTitle: _response!.moduleTitle, // from response
                                              lessonTitle: lesson.lessonTitle, // from lesson
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Create Content'),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    )
                  : const Center(child: Text('Press the button to plan the module.')), // Should not be seen if initState calls _planModule
    );
  }
}
