import 'package:flutter/material.dart';
import '../../models/course_plan_request.dart';
import '../../models/course_plan_response.dart';
import '../../services/api_service.dart';
import '../module_planning/module_planning_screen.dart'; // Import the new screen

class CoursePlanningScreen extends StatefulWidget {
  const CoursePlanningScreen({super.key});

  @override
  State<CoursePlanningScreen> createState() => _CoursePlanningScreenState();
}

class _CoursePlanningScreenState extends State<CoursePlanningScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  CoursePlanResponse? _response;
  String? _error;

  Future<void> _planCourse() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _response = null;
    });

    final request = CoursePlanRequest(
      title: "Introduction to Flutter",
      description: "A beginner-friendly course on Flutter development.",
      targetAudience: "Aspiring mobile developers",
      timeAvailable: "4 weeks",
      learningObjectives: [
        "Understand Dart basics",
        "Learn about Flutter widgets",
        "Build a simple Flutter app"
      ],
    );

    try {
      final response = await _apiService.planCourse(request);
      setState(() {
        _response = response;
        _isLoading = false;
      });
      // ignore: avoid_print
      print('Course Plan Response: ${response.toJsonString()}');
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      // ignore: avoid_print
      print('Error planning course: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Planning'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _isLoading ? null : _planCourse,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Plan Course'),
            ),
            if (_response != null) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                    'Course Title: ${_response!.courseTitle}\nDescription: ${_response!.courseDescription}'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // In a real app, you might pass some data from _response
                  // to the ModulePlanningScreen, for example, the course title and description.
                  if (_response != null) { // Ensure response is not null
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModulePlanningScreen(
                          courseTitle: _response!.courseTitle,
                          courseDescription: _response!.courseDescription,
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Plan Modules for this Course (Select a Module)'),
              ),
            ],
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: $_error',
                    style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
