import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_plan_request.dart';
import '../models/course_plan_response.dart';
import '../models/module_plan_request.dart';
import '../models/module_plan_response.dart';
import '../models/lesson_content_request.dart';
import '../models/lesson_content_response.dart';
import 'dart:io'; // For File
import 'package:http_parser/http_parser.dart'; // For MediaType
import '../models/quiz_creation_request.dart';
import '../models/quiz_creation_response.dart';
import '../models/document_upload_response.dart';
import '../models/generate_course_from_doc_request.dart'; // Import GenerateCourseFromDocRequest
import '../models/course_plan_response.dart'; // Reused for response

// Basic structure for API service
class ApiService {
  final String _baseUrl = "http://localhost:8000/api/v1";
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(
            'Request failed with status: ${response.statusCode}',
            response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: $e');
    }
  }

  Future<CoursePlanResponse> planCourse(CoursePlanRequest request) async {
    final response = await post('plan-course', request.toJson());
    return CoursePlanResponse.fromJson(response);
  }

  Future<ModulePlanResponse> planModule(ModulePlanRequest request) async {
    final response = await post('plan-module', request.toJson());
    return ModulePlanResponse.fromJson(response);
  }

  Future<LessonContentResponse> createLessonContent(LessonContentRequest request) async {
    final response = await post('create-lesson-content', request.toJson());
    return LessonContentResponse.fromJson(response);
  }

  Future<QuizCreationResponse> createQuiz(QuizCreationRequest request) async {
    final response = await post('create-quiz', request.toJson());
    return QuizCreationResponse.fromJson(response);
  }

  Future<DocumentUploadResponse> uploadDocument(String filePath) async {
    var uri = Uri.parse('$_baseUrl/documents/upload');
    var request = http.MultipartRequest('POST', uri);

    // Add the file
    File file = File(filePath);
    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // This is the field name the backend expects
        file.path,
        contentType: MediaType('application', 'octet-stream'), // Generic content type
      ),
    );

    // Add headers if necessary, though MultipartRequest sets Content-Type
    // request.headers.addAll(_headers); // _headers might be for JSON, be careful

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return DocumentUploadResponse.fromJson(jsonDecode(response.body));
      } else {
        // Try to parse error message from response if available
        String errorMessage = 'Request failed with status: ${response.statusCode}';
        try {
          var decodedBody = jsonDecode(response.body);
          if (decodedBody['detail'] != null) {
            errorMessage = decodedBody['detail'];
          }
        } catch (_) {
          // Ignore if body is not JSON or doesn't have 'detail'
        }
        throw ApiException(errorMessage, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error during file upload: $e');
    }
  }

  Future<CoursePlanResponse> generateCourseFromDocument(GenerateCourseFromDocRequest request) async {
    final response = await post('document-courses/generate-course', request.toJson());
    // Assuming the response structure matches CoursePlanResponse
    return CoursePlanResponse.fromJson(response);
  }
}

// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() {
    return "ApiException: $message (Status code: ${statusCode ?? 'N/A'})";
  }
}
