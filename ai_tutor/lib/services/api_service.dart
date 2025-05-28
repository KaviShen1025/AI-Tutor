import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ai_tutor/models/course_models.dart';
import 'package:ai_tutor/models/module_models.dart';

class ApiService {
  final String _baseUrl =
      "http://localhost:8000/api/v1"; // Assuming backend runs on localhost:8000

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
        final decodedJson = jsonDecode(
            utf8.decode(response.bodyBytes)); // Ensure UTF-8 decoding
        return CourseResponse.fromJson(decodedJson);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception(
            'Failed to plan course: ${response.statusCode} ${response.body}');
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
        // If the server returns a 200 OK response,
        // then parse the JSON.
        final decodedJson = jsonDecode(
            utf8.decode(response.bodyBytes)); // Ensure UTF-8 decoding
        return ModuleResponse.fromJson(decodedJson);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception(
            'Failed to plan module: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      // Handle network errors or other exceptions during the request
      throw Exception('Failed to connect to the server or other error: $e');
    }
  }
}
