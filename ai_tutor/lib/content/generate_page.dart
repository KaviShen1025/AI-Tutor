import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ai_tutor/services/api_service.dart';
import 'package:ai_tutor/models/course_models.dart';
import 'package:ai_tutor/models/document_models.dart';
import 'package:ai_tutor/models/document_course_models.dart'; // Import for DocumentCourseRequest
import 'package:ai_tutor/content/content_preview_page.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/animated_background.dart';

class GeneratePage extends StatefulWidget {
  const GeneratePage({super.key});

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  String? _selectedOption; // For the drop-up menu choice
  bool _isLoading = false; // For topic-based generation
  final ApiService _apiService = ApiService();
  late TextEditingController _topicController;

  // New state variables for file upload
  File? _selectedFile;
  String? _uploadedDocumentId;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _topicController = TextEditingController();
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    Navigator.pop(context); // Close the modal bottom sheet first
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'pptx'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _uploadedDocumentId = null; // Clear previous upload ID
        });
        _uploadFile(); // Automatically start upload after picking
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final response = await _apiService.uploadDocument(_selectedFile!);
      setState(() {
        _uploadedDocumentId = response.documentId;
        // _selectedFile = null; // Keep selected file visible until new one is picked or generation starts
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'File uploaded: ${response.filename}. Document ID: ${response.documentId}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload file: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showDropUpMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(60, 0, 0, 0),
      isDismissible: true,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMenuItem('Upload Document', Icons.description_outlined, action: _pickFile),
              _buildMenuItem('Upload Presentation', Icons.slideshow_outlined, action: _pickFile),
              // For "Upload Image" and "Take an Image", we'll keep the old behavior or define new actions later.
              _buildMenuItem('Upload Image', Icons.image_outlined, action: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image upload not implemented yet.')));
              }),
              _buildMenuItem('Take an Image', Icons.photo_camera_outlined, action: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Camera not implemented yet.')));
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(String text, IconData icon, {VoidCallback? action}) {
    // final isSelected = _selectedOption == text; // _selectedOption is less relevant now if actions are direct
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
        ),
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Trailing check can be removed or adapted if _selectedOption is still used for other purposes
        // trailing: isSelected 
        //     ? const Icon(
        //         Icons.check_circle,
        //         color: Colors.blue,
        //         size: 20,
        //       )
        //     : null,
        onTap: action ?? () { // If no specific action, just pop
          Navigator.pop(context);
          setState(() {
            _selectedOption = text; // Keep this if _selectedOption is used elsewhere
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBackground(
        primaryColor: Colors.blue.shade400,
        secondaryColor: Colors.blue.shade600,
        opacity: 0.03,
        enableWaves: true,
        enableParticles: true,
        child: SafeArea(
          child: Column(
            children: [
              const AppHeader(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView( // Added SingleChildScrollView for longer content
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        // File upload status section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _uploadedDocumentId != null ? Icons.file_present_rounded : 
                                _selectedFile != null ? Icons.attach_file_rounded : Icons.cloud_upload_outlined,
                                size: 40,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(height: 8),
                              if (_isUploading)
                                const CircularProgressIndicator(),
                              if (!_isUploading && _selectedFile != null && _uploadedDocumentId == null)
                                Text('Selected: ${_selectedFile!.path.split('/').last}'),
                              if (!_isUploading && _uploadedDocumentId != null)
                                Column(
                                  children: [
                                     Text('Uploaded: ${_selectedFile?.path.split('/').last ?? "Unknown file"}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                     Text('Doc ID: $_uploadedDocumentId', style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              if (!_isUploading && _selectedFile == null && _uploadedDocumentId == null)
                                const Text('Upload a document (PDF, DOCX, PPTX) to generate a course from it.'),
                              const SizedBox(height: 10),
                               ElevatedButton.icon(
                                icon: const Icon(Icons.file_upload),
                                label: const Text('Choose Document'),
                                onPressed: _isUploading ? null : _pickFile, // Call _pickFile directly
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Generate Course from Document Button
                        ElevatedButton(
                          onPressed: _uploadedDocumentId == null || _isLoading || _isUploading ? null : () async {
                            if (_uploadedDocumentId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please upload a document first.')),
                              );
                              return;
                            }
                            setState(() {
                              _isLoading = true; // Use existing _isLoading, ensure it disables other actions
                            });

                            final request = DocumentCourseRequest(
                              documentId: _uploadedDocumentId!,
                              // Optional fields are null by default as per model
                            );

                            try {
                              final courseResponse = await _apiService.generateCourseFromDocument(request);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContentPreviewPage(courseData: courseResponse),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to generate course from document: $e')),
                              );
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          child: _isLoading && _uploadedDocumentId != null // Show progress only if this button caused loading
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Generate Course from Document'),
                        ),
                        const SizedBox(height: 20),
                        const Row(children: <Widget>[
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("OR"),
                            ),
                            Expanded(child: Divider()),
                        ]),
                        const SizedBox(height: 20),
                        const Text(
                          'What is your favorite topic?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Ask HexaElite AI row with selection indicator - RETAINED
                        Row(
                          children: [
                            const Icon(
                              Icons.star_border_rounded,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Ask HexaElite AI',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            if (_selectedOption != null) // Retaining this for other menu options if needed
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          _selectedOption!,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedOption = null;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.withOpacity(0.2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 12,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            GestureDetector(
                              onTap: () => _showDropUpMenu(context),
                              child: Row(
                                children: [
                                  Text(
                                    'Source Options', // Changed from "Show more"
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_up,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Input field for topic-based generation - RETAINED
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _topicController,
                            decoration: InputDecoration(
                              hintText: 'Enter your Topic...',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            maxLines: 3, // Allow more lines for topic description
                          ),
                        ),
                        const SizedBox(height: 20), // Added Spacer
                        // Action buttons - RETAINED but modified Generate Now
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Home button - RETAINED
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.home_outlined,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Grid button (now "Source Options") - RETAINED
                              GestureDetector(
                                onTap: () => _showDropUpMenu(context),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.grid_view_outlined,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Generate Now button (for topic-based generation) - RETAINED
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isLoading || _isUploading ? null : () async {
                                    if (_topicController.text.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Please enter a topic')),
                                      );
                                      return;
                                    }
                                    setState(() { _isLoading = true; });
                                    final request = CourseRequest(
                                      title: _topicController.text,
                                      description: "A comprehensive course on ${_topicController.text}",
                                      targetAudience: "Beginners",
                                      timeAvailable: "1 week",
                                      preferredFormat: "Text-based modules",
                                      learningObjectives: [],
                                    );
                                    try {
                                      final courseResponse = await _apiService.planCourse(request);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ContentPreviewPage(courseData: courseResponse),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Failed to plan course: $e')),
                                      );
                                    } finally {
                                      setState(() { _isLoading = false; });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(double.infinity, 44),
                                     shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Generate from Topic'),
                                            SizedBox(width: 8),
                                            Icon(Icons.arrow_forward, size: 14),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}
