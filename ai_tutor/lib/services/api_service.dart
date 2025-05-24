import 'dart:convert';
import 'dart:io'; // For File
import 'package:http/http.dart' as http;
import '../models/course_models.dart';
import '../models/document_models.dart';
import '../models/document_course_models.dart';
import '../models/module_models.dart';
import '../models/lesson_models.dart';
import '../models/quiz_models.dart'; // Import quiz models

class ApiService {
  final String _baseUrl = "http://localhost:8000/api/v1"; // Assuming backend runs on localhost:8000

  Future<CourseResponse> planCourse(CourseRequest request) async {
    final url = Uri.parse('$_baseUrl/plan-course');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response,
        // then parse the JSON.
        final decodedJson = jsonDecode(utf8.decode(response.bodyBytes)); // Ensure UTF-8 decoding
        return CourseResponse.fromJson(decodedJson);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to plan course: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      // Handle network errors or other exceptions during the request
      throw Exception('Failed to connect to the server or other error: $e');
    }
  }

  Future<DocumentUploadResponse> uploadDocument(File file) async {
    final url = Uri.parse('$_baseUrl/documents/upload');
    try {
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      
      var streamedResponse = await request.send();
      
      if (streamedResponse.statusCode == 200) {
        final responseString = await streamedResponse.stream.bytesToString();
        final decodedJson = jsonDecode(responseString);
        return DocumentUploadResponse.fromJson(decodedJson);
      } else {
        throw Exception('Failed to upload document: ${streamedResponse.statusCode} ${streamedResponse.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or other error during document upload: $e');
    }
  }

  Future<DocumentContent> getDocumentDetails(String documentId) async {
    final url = Uri.parse('$_baseUrl/documents/$documentId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(utf8.decode(response.bodyBytes)); // Ensure UTF-8 decoding
        return DocumentContent.fromJson(decodedJson);
      } else {
        throw Exception('Failed to get document details: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or other error during fetching document details: $e');
    }
  }

  Future<CourseResponse> generateCourseFromDocument(DocumentCourseRequest request) async {
    final url = Uri.parse('$_baseUrl/document-courses/generate-course');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(utf8.decode(response.bodyBytes));
        return CourseResponse.fromJson(decodedJson);
      } else {
        throw Exception('Failed to generate course from document: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or other error during document course generation: $e');
    }
  }

  Future<ModuleResponse> planModule(ModuleRequest request) async {
    final url = Uri.parse('$_baseUrl/plan-module');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(utf8.decode(response.bodyBytes));
        return ModuleResponse.fromJson(decodedJson);
      } else {
        throw Exception('Failed to plan module: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or other error during module planning: $e');
    }
  }

  Future<LessonResponse> createLessonContent(LessonRequest request) async {
    final url = Uri.parse('$_baseUrl/create-lesson-content');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(utf8.decode(response.bodyBytes));
        return LessonResponse.fromJson(decodedJson);
      } else {
        throw Exception('Failed to create lesson content: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or other error during lesson content creation: $e');
    }
  }

  Future<QuizResponse> createQuiz(LessonRequest request) async {
    final url = Uri.parse('$_baseUrl/create-quiz');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(utf8.decode(response.bodyBytes));
        return QuizResponse.fromJson(decodedJson);
      } else {
        throw Exception('Failed to create quiz: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or other error during quiz creation: $e');
    }
  }
}
