// Dart model for Document Course Request

class DocumentCourseRequest {
  final String documentId;
  final String? titleOverride;
  final String? targetAudience;
  final String? complexityLevel;
  final String? additionalContext;

  DocumentCourseRequest({
    required this.documentId,
    this.titleOverride,
    this.targetAudience,
    this.complexityLevel,
    this.additionalContext,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'document_id': documentId,
    };
    if (titleOverride != null) {
      data['title_override'] = titleOverride;
    }
    if (targetAudience != null) {
      data['target_audience'] = targetAudience;
    }
    if (complexityLevel != null) {
      data['complexity_level'] = complexityLevel;
    }
    if (additionalContext != null) {
      data['additional_context'] = additionalContext;
    }
    return data;
  }
}
