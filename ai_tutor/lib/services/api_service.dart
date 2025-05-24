import 'dart:convert';
import 'dart:io'; // Added for File type
import 'package:http/http.dart' as http;
import '../models/course_models.dart';
import '../models/document_models.dart'; // Added for document models

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
      throw Exception('Failed to connect to the server or other error: $e');
    }
  }

  Future<LessonContentResponse> createLessonContent(LessonContentRequest request) async {
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
        return LessonContentResponse.fromJson(decodedJson);
      } else {
        throw Exception('Failed to create lesson content: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or other error: $e');
    }
  }

  Future<QuizResponse> createQuiz(QuizRequest request) async {
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
      throw Exception('Failed to connect to the server or other error: $e');
    }
  }

  // Methods for document-based course generation

  Future<DocumentUploadResponse> uploadDocument(File file) async {
    final url = Uri.parse('$_baseUrl/documents/upload');
    try {
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(utf8.decode(response.bodyBytes));
        return DocumentUploadResponse.fromJson(decodedJson);
      } else {
        throw Exception('Failed to upload document: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or other error: $e');
    }
  }

  Future<DocumentDetailsResponse> getDocument(String documentId) async {
    final url = Uri.parse('$_baseUrl/documents/$documentId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(utf8.decode(response.bodyBytes));
        return DocumentDetailsResponse.fromJson(decodedJson);
      } else {
        throw Exception('Failed to get document details: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or other error: $e');
    }
  }

  Future<CourseResponse> generateCourseFromDocument(DocumentCourseGenerationRequest request) async {
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
      throw Exception('Failed to connect to the server or other error: $e');
    }
  }

  Future<ModuleResponse> generateModuleFromDocument(DocumentModuleGenerationRequest request) async {
    final url = Uri.parse('$_baseUrl/document-courses/generate-module');
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
        throw Exception('Failed to generate module from document: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or other error: $e');
    }
  }

  Future<LessonContentResponse> generateLessonFromDocument(DocumentLessonGenerationRequest request) async {
    final url = Uri.parse('$_baseUrl/document-courses/generate-lesson');
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
        return LessonContentResponse.fromJson(decodedJson);
      } else {
        throw Exception('Failed to generate lesson from document: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or other error: $e');
    }
  }

  Future<QuizResponse> generateQuizFromDocument(DocumentQuizGenerationRequest request) async {
    final url = Uri.parse('$_baseUrl/document-courses/generate-quiz');
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
        throw Exception('Failed to generate quiz from document: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server or other error: $e');
    }
  }
}
