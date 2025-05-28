import 'dart:convert';

class GenerateCourseFromDocRequest {
  final String documentId;
  final String? additionalContext;
  final String? titleOverride;
  final String? targetAudience;
  final String? complexityLevel;

  GenerateCourseFromDocRequest({
    required this.documentId,
    this.additionalContext,
    this.titleOverride,
    this.targetAudience,
    this.complexityLevel,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'document_id': documentId,
    };
    if (additionalContext != null && additionalContext!.isNotEmpty) {
      data['additional_context'] = additionalContext;
    }
    if (titleOverride != null && titleOverride!.isNotEmpty) {
      data['title_override'] = titleOverride;
    }
    if (targetAudience != null && targetAudience!.isNotEmpty) {
      data['target_audience'] = targetAudience;
    }
    if (complexityLevel != null && complexityLevel!.isNotEmpty) {
      data['complexity_level'] = complexityLevel;
    }
    return data;
  }

  String toJsonString() => jsonEncode(toJson());
}
