import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io'; // For File
import '../../services/api_service.dart';
import '../../models/document_upload_response.dart';
import '../../models/generate_course_from_doc_request.dart';
import '../../models/course_plan_response.dart';
import '../course_planning/course_planning_screen.dart'; // For potential navigation
import '../module_planning/module_planning_screen.dart'; // For potential navigation

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>(); // For optional parameters form

  // Document Upload State
  String? _filePath;
  String? _fileName;
  bool _isUploading = false;
  DocumentUploadResponse? _uploadResponse;
  String? _uploadError;

  // Course Generation State
  final TextEditingController _additionalContextController = TextEditingController();
  final TextEditingController _titleOverrideController = TextEditingController();
  final TextEditingController _targetAudienceController = TextEditingController();
  final TextEditingController _complexityLevelController = TextEditingController();
  bool _isGeneratingCourse = false;
  CoursePlanResponse? _coursePlanResponse;
  String? _courseGenerationError;

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt', 'docx'],
      );

      if (result != null) {
        setState(() {
          _filePath = result.files.single.path;
          _fileName = result.files.single.name;
          _uploadResponse = null;
          _uploadError = null;
          _coursePlanResponse = null; // Reset course plan if new file picked
          _courseGenerationError = null;
        });
      } else {
        setState(() {
          _fileName = "No file selected.";
        });
      }
    } catch (e) {
      setState(() {
        _uploadError = "Error picking file: $e";
        _fileName = "Error picking file.";
      });
    }
  }

  Future<void> _uploadDocument() async {
    if (_filePath == null) {
      setState(() {
        _uploadError = "Please pick a document first.";
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadResponse = null;
      _uploadError = null;
      _coursePlanResponse = null;
      _courseGenerationError = null;
    });

    try {
      final response = await _apiService.uploadDocument(_filePath!);
      setState(() {
        _uploadResponse = response;
        _isUploading = false;
      });
      // ignore: avoid_print
      print('Document Upload Response: ${response.toJsonString()}');
    } catch (e) {
      setState(() {
        _uploadError = e.toString();
        _isUploading = false;
      });
      // ignore: avoid_print
      print('Error uploading document: $e');
    }
  }

  Future<void> _generateCourse() async {
    if (_uploadResponse == null || _uploadResponse!.documentId.isEmpty) {
      setState(() {
        _courseGenerationError = "Please upload a document successfully first.";
      });
      return;
    }
    if (!_formKey.currentState!.validate()) {
        return; // Form validation failed
    }

    setState(() {
      _isGeneratingCourse = true;
      _coursePlanResponse = null;
      _courseGenerationError = null;
    });

    final request = GenerateCourseFromDocRequest(
      documentId: _uploadResponse!.documentId,
      additionalContext: _additionalContextController.text,
      titleOverride: _titleOverrideController.text,
      targetAudience: _targetAudienceController.text,
      complexityLevel: _complexityLevelController.text,
    );

    try {
      final response = await _apiService.generateCourseFromDocument(request);
      setState(() {
        _coursePlanResponse = response;
        _isGeneratingCourse = false;
      });
      // ignore: avoid_print
      print('Generated Course Plan: ${response.toJsonString()}');
    } catch (e) {
      setState(() {
        _courseGenerationError = e.toString();
        _isGeneratingCourse = false;
      });
      // ignore: avoid_print
      print('Error generating course: $e');
    }
  }

  @override
  void dispose() {
    _additionalContextController.dispose();
    _titleOverrideController.dispose();
    _targetAudienceController.dispose();
    _complexityLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload & Generate Course'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: _pickDocument,
              icon: const Icon(Icons.attach_file),
              label: const Text('Pick Document'),
            ),
            const SizedBox(height: 10),
            if (_fileName != null) Text('Selected File: $_fileName', textAlign: TextAlign.center),
            const SizedBox(height: 10),
            if (_filePath != null)
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadDocument,
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Upload Document'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade300),
              ),
            if (_isUploading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (_uploadResponse != null)
              Card(
                color: Colors.green.shade50,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Upload Success!', style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Document ID: ${_uploadResponse!.documentId}'),
                      Text('Filename: ${_uploadResponse!.filename}'),
                      Text('Content Extracted: ${_uploadResponse!.contentExtracted ? "Yes" : "No"}'),
                    ],
                  ),
                )
              ),
            if (_uploadError != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Upload Error: $_uploadError',
                    style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
              ),
            
            const SizedBox(height: 20),
            if (_uploadResponse != null && _uploadResponse!.documentId.isNotEmpty) ...[
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              Text('Generate Course Options', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleOverrideController,
                      decoration: const InputDecoration(labelText: 'Course Title Override (Optional)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _additionalContextController,
                      decoration: const InputDecoration(labelText: 'Additional Context (Optional)', border: OutlineInputBorder()),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _targetAudienceController,
                      decoration: const InputDecoration(labelText: 'Target Audience (Optional)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _complexityLevelController,
                      decoration: const InputDecoration(labelText: 'Complexity (e.g., beginner) (Optional)', border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isGeneratingCourse ? null : _generateCourse,
                icon: const Icon(Icons.school),
                label: const Text('Generate Course from Document'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade400, minimumSize: const Size(double.infinity, 40)),
              ),
            ],
            if (_isGeneratingCourse)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (_courseGenerationError != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Course Generation Error: $_courseGenerationError',
                    style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
              ),
            if (_coursePlanResponse != null)
              Card(
                color: Colors.blue.shade50,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Course Generated: ${_coursePlanResponse!.courseTitle}', style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(_coursePlanResponse!.courseDescription),
                      const SizedBox(height: 8),
                      Text('Introduction:', style: Theme.of(context).textTheme.titleSmall),
                      Text(_coursePlanResponse!.courseIntroduction),
                      const SizedBox(height: 8),
                      Text('Modules (${_coursePlanResponse!.modules.length}):', style: Theme.of(context).textTheme.titleSmall),
                      for (var module in _coursePlanResponse!.modules)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('- ${module.moduleTitle}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Padding(
                                padding: const EdgeInsets.only(left:16.0),
                                child: Text(module.moduleSummary),
                              )
                            ],
                          ),
                        ),
                       // TODO: Add a button to navigate to a full course view if needed
                    ],
                  ),
                )
              ),
          ],
        ),
      ),
    );
  }
}
